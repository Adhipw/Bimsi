<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\PendaftaranSidang;
use App\Models\PengujiSidang;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class KaprodiPengujiController extends Controller
{
    /**
     * Tampilkan daftar pendaftaran sidang yang disetujui (ACC Pembimbing) 
     * tetapi belum memiliki penguji.
     */
    public function listSidang()
    {
        $list = PendaftaranSidang::with(['mahasiswa.user', 'pengajuanJudul', 'pengujis.dosen.user'])
            ->where('acc_pembimbing', true)
            ->latest()
            ->get();

        return response()->json([
            'status' => 'success',
            'data' => $list
        ]);
    }

    /**
     * Tetapkan Penguji 1 dan Penguji 2 untuk pendaftaran sidang.
     */
    public function assign(Request $request, $id)
    {
        $validated = $request->validate([
            'penguji_1_dosen_id' => 'required|exists:dosens,id',
            'penguji_2_dosen_id' => 'required|exists:dosens,id|different:penguji_1_dosen_id',
        ]);

        $pendaftaran = PendaftaranSidang::findOrFail($id);
        
        if (!$pendaftaran->acc_pembimbing) {
            return response()->json([
                'status' => 'error',
                'message' => 'Sidang ini belum di-ACC oleh pembimbing.'
            ], 422);
        }

        DB::transaction(function () use ($validated, $pendaftaran) {
            // Hapus penguji lama jika ada
            PengujiSidang::where('pendaftaran_sidang_id', $pendaftaran->id)->delete();

            // Buat Penguji 1
            PengujiSidang::create([
                'pendaftaran_sidang_id' => $pendaftaran->id,
                'dosen_id' => $validated['penguji_1_dosen_id'],
                'peran' => 'Penguji 1',
            ]);

            // Buat Penguji 2
            PengujiSidang::create([
                'pendaftaran_sidang_id' => $pendaftaran->id,
                'dosen_id' => $validated['penguji_2_dosen_id'],
                'peran' => 'Penguji 2',
            ]);
        });

        return response()->json([
            'status' => 'success',
            'message' => 'Dosen Penguji berhasil ditetapkan.'
        ]);
    }
}
