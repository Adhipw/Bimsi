<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\DokumenSkripsi;
use App\Models\VersiDokumen;
use App\Models\ReviewDokumen;
use App\Models\PengajuanJudul;
use App\Services\CloudinaryService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class UploadController extends Controller
{
    protected $cloudinaryService;

    public function __construct(CloudinaryService $cloudinaryService)
    {
        $this->cloudinaryService = $cloudinaryService;
    }

    /**
     * Tampilkan seluruh dokumen skripsi milik Mahasiswa yang login beserta versi & reviewnya.
     */
    public function mahasiswaIndex(Request $request)
    {
        $mahasiswa = $request->user()->mahasiswa;
        if (!$mahasiswa) {
            return response()->json([
                'status' => 'error',
                'message' => 'Data mahasiswa tidak ditemukan.'
            ], 404);
        }

        $pengajuan = PengajuanJudul::where('mahasiswa_id', $mahasiswa->id)
            ->where('status', 'disetujui')
            ->first();

        if (!$pengajuan) {
            return response()->json([
                'status' => 'success',
                'data' => []
            ]);
        }

        $list = DokumenSkripsi::with(['versiDokumens.reviewDokumens.dosen.user'])
            ->where('pengajuan_judul_id', $pengajuan->id)
            ->latest()
            ->get();

        return response()->json([
            'status' => 'success',
            'data' => $list
        ]);
    }

    /**
     * Tampilkan seluruh dokumen bimbingan mahasiswa yang masuk ke Dosen yang login.
     */
    public function dosenIndex(Request $request)
    {
        $dosen = $request->user()->dosen;
        if (!$dosen) {
            return response()->json([
                'status' => 'error',
                'message' => 'Data dosen tidak ditemukan.'
            ], 404);
        }

        $list = DokumenSkripsi::with(['versiDokumens.reviewDokumens.dosen.user', 'pengajuanJudul.mahasiswa.user', 'pengajuanJudul.mahasiswa.kelas'])
            ->whereHas('pengajuanJudul.pembimbings', function ($q) use ($dosen) {
                $q->where('dosen_id', $dosen->id);
            })
            ->latest()
            ->get();

        return response()->json([
            'status' => 'success',
            'data' => $list
        ]);
    }

    /**
     * Unggah dokumen skripsi baru oleh Mahasiswa (Multipart Request).
     */
    public function store(Request $request)
    {
        $mahasiswa = $request->user()->mahasiswa;
        if (!$mahasiswa) {
            return response()->json([
                'status' => 'error',
                'message' => 'Data mahasiswa tidak ditemukan.'
            ], 404);
        }

        $pengajuan = PengajuanJudul::where('mahasiswa_id', $mahasiswa->id)
            ->where('status', 'disetujui')
            ->first();

        if (!$pengajuan) {
            return response()->json([
                'status' => 'error',
                'message' => 'Anda belum memiliki usulan judul skripsi yang disetujui untuk mengunggah dokumen.'
            ], 422);
        }

        $request->validate([
            'file' => 'required|file|mimes:pdf,doc,docx,zip,rar|max:10240', // Maksimal 10MB
            'jenis_dokumen' => 'required|string|in:proposal,bab1,bab2,bab3,bab4,bab5,final',
            'catatan_revisi' => 'nullable|string', // Catatan versi dari mahasiswa
        ]);

        $fileUrl = $this->cloudinaryService->upload($request->file('file'), 'skripsi_dokumen');

        $dokumen = DB::transaction(function () use ($pengajuan, $request, $fileUrl) {
            // Cek apakah data DokumenSkripsi untuk jenis ini sudah ada
            $dokumen = DokumenSkripsi::where('pengajuan_judul_id', $pengajuan->id)
                ->where('jenis_dokumen', $request->jenis_dokumen)
                ->first();

            if (!$dokumen) {
                // Buat DokumenSkripsi baru
                $dokumen = DokumenSkripsi::create([
                    'pengajuan_judul_id' => $pengajuan->id,
                    'jenis_dokumen' => $request->jenis_dokumen,
                    'file_url' => $fileUrl,
                ]);
                $versiNomor = 1;
            } else {
                // Ambil nomor versi terakhir
                $latestVersi = VersiDokumen::where('dokumen_skripsi_id', $dokumen->id)
                    ->max('versi') ?? 0;
                $versiNomor = $latestVersi + 1;

                // Update file_url utama dokumen ke yang terbaru
                $dokumen->update([
                    'file_url' => $fileUrl,
                ]);
            }

            // Buat versi dokumen baru
            VersiDokumen::create([
                'dokumen_skripsi_id' => $dokumen->id,
                'versi' => $versiNomor,
                'file_url' => $fileUrl,
                'catatan_revisi' => $request->catatan_revisi ?? "Unggahan Versi {$versiNomor}",
            ]);

            return $dokumen;
        });

        return response()->json([
            'status' => 'success',
            'message' => 'Dokumen skripsi berhasil diunggah.',
            'data' => $dokumen->load(['versiDokumens.reviewDokumens'])
        ], 201);
    }

    /**
     * Berikan ulasan / review dokumen oleh Dosen Pembimbing.
     */
    public function review(Request $request)
    {
        $dosen = $request->user()->dosen;
        if (!$dosen) {
            return response()->json([
                'status' => 'error',
                'message' => 'Data dosen tidak ditemukan.'
            ], 404);
        }

        $validated = $request->validate([
            'versi_dokumen_id' => 'required|exists:versi_dokumens,id',
            'komentar' => 'required|string',
            'status' => 'required|string|in:approved,revisi,rejected',
        ]);

        $versi = VersiDokumen::findOrFail($validated['versi_dokumen_id']);
        $dokumen = $versi->dokumenSkripsi;
        $pengajuan = $dokumen->pengajuanJudul;

        // Validasi: Pastikan dosen adalah pembimbing aktif mahasiswa tersebut
        $isAdvisor = $pengajuan->pembimbings()->where('dosen_id', $dosen->id)->exists();
        if (!$isAdvisor) {
            return response()->json([
                'status' => 'error',
                'message' => 'Anda tidak berwenang memberikan review pada dokumen mahasiswa ini.'
            ], 403);
        }

        // Simpan review dokumen
        $review = ReviewDokumen::create([
            'versi_dokumen_id' => $validated['versi_dokumen_id'],
            'dosen_id' => $dosen->id,
            'komentar' => $validated['komentar'],
            'status' => $validated['status'],
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Review dokumen berhasil disimpan.',
            'data' => $review->load(['dosen.user'])
        ], 201);
    }
}
