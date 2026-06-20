<?php
 
namespace App\Http\Controllers\Api;
 
use App\Http\Controllers\Controller;
use App\Models\PengajuanJudul;
use App\Models\Dosen;
use App\Models\Pembimbing;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
 
class KaprodiPembimbingController extends Controller
{
    /**
     * Tampilkan daftar mahasiswa dengan judul yang sudah disetujui beserta pembimbing saat ini (jika ada).
     */
    public function mahasiswaDisetujui()
    {
        $list = PengajuanJudul::with(['mahasiswa.user', 'mahasiswa.programStudi', 'periodeSkripsi', 'pembimbings.dosen.user'])
            ->where('status', 'disetujui')
            ->latest()
            ->get();
 
        return response()->json([
            'status' => 'success',
            'data' => $list
        ]);
    }
 
    /**
     * Tampilkan daftar dosen lengkap dengan bidang keahlian dan sisa kuota bimbingan aktif.
     */
    public function dosenList()
    {
        // Menghitung kuota terpakai dari pembimbingan aktif
        $dosens = Dosen::with(['user', 'bidangKeahlians'])
            ->withCount(['pembimbings' => function ($q) {
                $q->where('status', 'aktif');
            }])
            ->get();
 
        return response()->json([
            'status' => 'success',
            'data' => $dosens
        ]);
    }
 
    /**
     * Tetapkan Pembimbing 1 dan Pembimbing 2 untuk judul skripsi yang disetujui.
     */
    public function assign(Request $request)
    {
        $validated = $request->validate([
            'pengajuan_judul_id' => 'required|exists:pengajuan_juduls,id',
            'pembimbing_1_dosen_id' => 'required|exists:dosens,id',
            'pembimbing_2_dosen_id' => 'nullable|exists:dosens,id|different:pembimbing_1_dosen_id',
        ]);
 
        $pengajuan = PengajuanJudul::findOrFail($validated['pengajuan_judul_id']);
        if ($pengajuan->status !== 'disetujui') {
            return response()->json([
                'status' => 'error',
                'message' => 'Pembimbing hanya dapat ditentukan jika status pengajuan judul sudah Disetujui.'
            ], 422);
        }
 
        DB::transaction(function () use ($validated) {
            // Hapus alokasi pembimbing lama jika ada
            Pembimbing::where('pengajuan_judul_id', $validated['pengajuan_judul_id'])->delete();
 
            // Buat Pembimbing 1
            Pembimbing::create([
                'pengajuan_judul_id' => $validated['pengajuan_judul_id'],
                'dosen_id' => $validated['pembimbing_1_dosen_id'],
                'peran' => 'Pembimbing 1',
                'status' => 'aktif',
            ]);
 
            // Buat Pembimbing 2 (jika diisi)
            if (!empty($validated['pembimbing_2_dosen_id'])) {
                Pembimbing::create([
                    'pengajuan_judul_id' => $validated['pengajuan_judul_id'],
                    'dosen_id' => $validated['pembimbing_2_dosen_id'],
                    'peran' => 'Pembimbing 2',
                    'status' => 'aktif',
                ]);
            }
        });
 
        return response()->json([
            'status' => 'success',
            'message' => 'Dosen Pembimbing berhasil dialokasikan.'
        ]);
    }
}
