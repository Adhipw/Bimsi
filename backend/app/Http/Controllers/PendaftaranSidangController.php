<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Models\PendaftaranSidang;

class PendaftaranSidangController extends Controller
{
    public function index(Request $request)
    {
        $mahasiswa = $request->user()->mahasiswa;
        if (!$mahasiswa) {
            return response()->json(['message' => 'Data mahasiswa tidak ditemukan.'], 404);
        }

        $data = PendaftaranSidang::with(['mahasiswa.user', 'pengajuanJudul'])
            ->where('mahasiswa_id', $mahasiswa->id)
            ->get();
        return response()->json($data);
    }

    public function store(Request $request)
    {
        $mahasiswa = $request->user()->mahasiswa;
        if (!$mahasiswa) {
            return response()->json(['message' => 'Data mahasiswa tidak ditemukan.'], 404);
        }

        $validated = $request->validate([
            'pengajuan_judul_id' => 'required|exists:pengajuan_juduls,id',
            'jenis_sidang' => 'required|in:sempro,akhir',
            'file_syarat_url' => 'nullable|string',
        ]);

        $validated['mahasiswa_id'] = $mahasiswa->id;

        $pendaftaran = PendaftaranSidang::create($validated);
        return response()->json($pendaftaran, 201);
    }

    public function uploadTurnitin(Request $request, $id)
    {
        $mahasiswa = $request->user()->mahasiswa;
        if (!$mahasiswa) {
            return response()->json(['message' => 'Data mahasiswa tidak ditemukan.'], 404);
        }

        $pendaftaran = PendaftaranSidang::where('id', $id)
            ->where('mahasiswa_id', $mahasiswa->id)
            ->firstOrFail();

        $validated = $request->validate([
            'turnitin_score' => 'required|integer|min:0|max:100',
            'turnitin_file_url' => 'required|string',
        ]);

        $pendaftaran->update([
            'turnitin_score' => $validated['turnitin_score'],
            'turnitin_file_url' => $validated['turnitin_file_url'],
            'turnitin_status' => 'pending',
        ]);

        return response()->json(['status' => 'success', 'message' => 'File Turnitin berhasil diunggah']);
    }

    public function show($id)
    {
        $pendaftaran = PendaftaranSidang::with(['mahasiswa.user', 'pengajuanJudul'])->findOrFail($id);
        return response()->json($pendaftaran);
    }

    public function updateStatus(Request $request, $id)
    {
        $validated = $request->validate([
            'status' => 'required|in:pending,approved,rejected',
            'keterangan' => 'nullable|string',
        ]);

        $pendaftaran = PendaftaranSidang::findOrFail($id);
        $pendaftaran->update($validated);

        return response()->json($pendaftaran);
    }

    public function indexDosen(Request $request)
    {
        $dosen = $request->user()->dosen;
        if (!$dosen) {
            return response()->json(['message' => 'Data dosen tidak ditemukan.'], 404);
        }

        $pendaftarans = PendaftaranSidang::with(['mahasiswa.user', 'pengajuanJudul'])
            ->whereHas('pengajuanJudul.pembimbings', function ($query) use ($dosen) {
                $query->where('dosen_id', $dosen->id);
            })
            ->get();
            
        return response()->json($pendaftarans);
    }

    public function approveSidang(Request $request, $id)
    {
        $pendaftaran = PendaftaranSidang::findOrFail($id);
        
        $hash = hash('sha256', $pendaftaran->id . time() . rand());
        
        $pendaftaran->update([
            'acc_pembimbing' => true,
            'tanggal_acc' => now(),
            'ttd_digital_hash' => $hash,
        ]);

        return response()->json([
            'message' => 'Sidang approved successfully',
            'data' => $pendaftaran
        ]);
    }

    public function verifyTtd($hash)
    {
        $pendaftaran = PendaftaranSidang::with(['mahasiswa.user', 'pengajuanJudul.pembimbings.dosen.user'])
            ->where('ttd_digital_hash', $hash)
            ->first();

        if (!$pendaftaran) {
            return response()->json(['valid' => false, 'message' => 'QR Code / Tanda tangan tidak valid'], 404);
        }

        return response()->json([
            'valid' => true,
            'data' => [
                'mahasiswa' => $pendaftaran->mahasiswa->user->name ?? 'Unknown',
                'nim' => $pendaftaran->mahasiswa->nim ?? '-',
                'judul' => $pendaftaran->pengajuanJudul->judul ?? '-',
                'tanggal_acc' => $pendaftaran->tanggal_acc,
            ]
        ]);
    }
}
