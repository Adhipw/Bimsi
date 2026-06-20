<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\PengajuanJudul;
use App\Models\PeriodeSkripsi;
use App\Models\RiwayatPengajuanJudul;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class PengajuanJudulController extends Controller
{
    public function status(Request $request)
    {
        $user = $request->user();
        $mahasiswa = $user->mahasiswa;

        if (!$mahasiswa) {
            return response()->json([
                'status' => 'error',
                'message' => 'Data mahasiswa tidak ditemukan.'
            ], 404);
        }

        $periode = PeriodeSkripsi::where('is_active', true)->first();
        if (!$periode) {
            return response()->json([
                'status' => 'success',
                'message' => 'Tidak ada periode skripsi aktif saat ini.',
                'data' => null
            ]);
        }

        $pengajuan = PengajuanJudul::where('mahasiswa_id', $mahasiswa->id)
            ->where('periode_skripsi_id', $periode->id)
            ->latest()
            ->first();

        return response()->json([
            'status' => 'success',
            'data' => $pengajuan ? $pengajuan->load('periodeSkripsi') : null
        ]);
    }

    public function store(Request $request)
    {
        $user = $request->user();
        $mahasiswa = $user->mahasiswa;

        if (!$mahasiswa) {
            return response()->json([
                'status' => 'error',
                'message' => 'Data mahasiswa tidak ditemukan.'
            ], 403);
        }

        $periode = PeriodeSkripsi::where('is_active', true)->first();
        if (!$periode) {
            return response()->json([
                'status' => 'error',
                'message' => 'Tidak ada periode skripsi aktif saat ini. Pengajuan ditolak.'
            ], 422);
        }

        $validated = $request->validate([
            'judul' => 'required|string|max:255',
            'deskripsi' => 'nullable|string',
        ]);

        // Cek apakah ada pengajuan aktif yang tidak ditolak
        $existing = PengajuanJudul::where('mahasiswa_id', $mahasiswa->id)
            ->where('periode_skripsi_id', $periode->id)
            ->whereIn('status', ['pending', 'disetujui', 'revisi'])
            ->first();

        if ($existing) {
            return response()->json([
                'status' => 'error',
                'message' => "Anda memiliki pengajuan judul aktif dengan status: {$existing->status}."
            ], 422);
        }

        $pengajuan = DB::transaction(function () use ($user, $request, $mahasiswa, $periode) {
            $pengajuan = PengajuanJudul::create([
                'mahasiswa_id' => $user->id,
                'periode_skripsi_id' => $request->periode_skripsi_id,
                'judul' => $request->judul,
                'deskripsi' => $request->deskripsi,
                'status' => 'pending',
            ]);

            RiwayatPengajuanJudul::create([
                'pengajuan_judul_id' => $pengajuan->id,
                'status_sebelumnya' => 'none',
                'status_baru' => 'pending',
                'keterangan' => 'Judul skripsi diajukan pertama kali.',
            ]);

            event(new \App\Events\JudulDiajukanEvent($pengajuan));

            $kaprodi = \App\Models\User::where('role', 'kaprodi')->first();
            if ($kaprodi && $kaprodi->fcm_token) {
                app(\App\Services\FirebaseNotificationService::class)->sendPushNotification(
                    $kaprodi->fcm_token,
                    'Judul Baru Diajukan',
                    'Terdapat pengajuan judul baru dari ' . $user->name
                );
            }

            return $pengajuan;
        });

        return response()->json([
            'status' => 'success',
            'message' => 'Judul skripsi berhasil diajukan.',
            'data' => $pengajuan
        ], 201);
    }

    public function update(Request $request, $id)
    {
        $user = $request->user();
        $mahasiswa = $user->mahasiswa;

        if (!$mahasiswa) {
            return response()->json([
                'status' => 'error',
                'message' => 'Data mahasiswa tidak ditemukan.'
            ], 403);
        }

        $pengajuan = PengajuanJudul::findOrFail($id);

        if ($pengajuan->mahasiswa_id !== $mahasiswa->id) {
            return response()->json([
                'status' => 'error',
                'message' => 'Anda tidak berwenang mengedit pengajuan ini.'
            ], 403);
        }

        if (!in_array($pengajuan->status, ['pending', 'revisi'])) {
            return response()->json([
                'status' => 'error',
                'message' => 'Pengajuan yang sudah disetujui atau ditolak tidak dapat diubah.'
            ], 422);
        }

        $validated = $request->validate([
            'judul' => 'required|string|max:255',
            'deskripsi' => 'nullable|string',
        ]);

        $statusSebelumnya = $pengajuan->status;

        DB::transaction(function () use ($pengajuan, $validated, $statusSebelumnya) {
            $pengajuan->update([
                'judul' => $validated['judul'],
                'deskripsi' => $validated['deskripsi'] ?? null,
                'status' => 'pending', // kembali ke pending untuk re-approve Kaprodi
            ]);

            RiwayatPengajuanJudul::create([
                'pengajuan_judul_id' => $pengajuan->id,
                'status_sebelumnya' => $statusSebelumnya,
                'status_baru' => 'pending',
                'keterangan' => 'Judul skripsi direvisi oleh mahasiswa.',
            ]);
        });

        return response()->json([
            'status' => 'success',
            'message' => 'Pengajuan judul skripsi berhasil direvisi.',
            'data' => $pengajuan
        ]);
    }
}
