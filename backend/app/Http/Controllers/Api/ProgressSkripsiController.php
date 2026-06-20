<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\PengajuanJudul;
use App\Models\ProgressSkripsi;
use Illuminate\Support\Facades\Validator;

class ProgressSkripsiController extends Controller
{
    // Mahasiswa: Melihat progress skripsinya sendiri
    public function mahasiswaIndex(Request $request)
    {
        $mahasiswa = $request->user()->mahasiswa;

        if (!$mahasiswa) {
            return response()->json([
                'success' => false,
                'message' => 'Data mahasiswa tidak ditemukan.',
            ], 404);
        }

        // Ambil pengajuan judul yang disetujui
        $pengajuan = PengajuanJudul::where('mahasiswa_id', $mahasiswa->id)
            ->where('status', 'disetujui')
            ->first();

        if (!$pengajuan) {
            return response()->json([
                'success' => false,
                'message' => 'Belum ada judul skripsi yang disetujui.',
            ], 404);
        }

        $progress = ProgressSkripsi::where('pengajuan_judul_id', $pengajuan->id)->get();
        $totalPersentase = $progress->sum('persentase');

        return response()->json([
            'success' => true,
            'message' => 'Data progress berhasil diambil.',
            'data' => [
                'pengajuan_judul' => $pengajuan,
                'total_persentase' => min($totalPersentase, 100),
                'progress_detail' => $progress
            ]
        ], 200);
    }

    // Dosen: Mengupdate progress skripsi mahasiswa bimbingan per BAB
    public function dosenUpdate(Request $request, $pengajuan_judul_id)
    {
        $dosen = $request->user()->dosen;

        if (!$dosen) {
            return response()->json([
                'success' => false,
                'message' => 'Akses ditolak. Anda bukan dosen.',
            ], 403);
        }

        $validator = Validator::make($request->all(), [
            'bab' => 'required|string',
            'status' => 'required|string|in:Revisi,Disetujui',
            'keterangan' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal.',
                'errors' => $validator->errors()
            ], 422);
        }

        $pengajuan = PengajuanJudul::find($pengajuan_judul_id);

        if (!$pengajuan) {
            return response()->json([
                'success' => false,
                'message' => 'Pengajuan judul tidak ditemukan.',
            ], 404);
        }

        // Pastikan dosen adalah pembimbing untuk judul ini
        $isPembimbing = $pengajuan->pembimbings()->where('dosen_id', $dosen->id)->exists();
        if (!$isPembimbing) {
            return response()->json([
                'success' => false,
                'message' => 'Anda bukan pembimbing untuk judul ini.',
            ], 403);
        }

        $persentase = $request->status === 'Disetujui' ? 20 : 0; // Asumsi per BAB bernilai 20%

        $progress = ProgressSkripsi::updateOrCreate(
            [
                'pengajuan_judul_id' => $pengajuan->id,
                'bab' => $validated['bab']
            ],
            [
                'status' => $validated['status'],
                'persentase' => $persentase,
                'keterangan' => $validated['keterangan'] ?? '-',
                'updated_by' => $user->id,
            ]
        );

        event(new \App\Events\ProgressUpdatedEvent($progress, $pengajuan));

        $fcmToken = $pengajuan->mahasiswa->user->fcm_token;
        if ($fcmToken) {
            app(\App\Services\FirebaseNotificationService::class)->sendPushNotification(
                $fcmToken,
                'Progress Skripsi Diupdate',
                'Progress ' . $progress->bab . ' Anda telah diupdate menjadi ' . $progress->status
            );
        }

        return response()->json([
            'success' => true,
            'message' => 'Progress skripsi berhasil diupdate.',
            'data' => $progress
        ], 200);
    }

    // Kaprodi: Monitoring progress skripsi seluruh mahasiswa
    public function kaprodiIndex(Request $request)
    {
        $search = $request->query('search');

        $pengajuans = PengajuanJudul::with(['mahasiswa.user', 'progressSkripsis', 'pembimbings.dosen.user'])
            ->where('status', 'disetujui')
            ->when($search, function ($query, $search) {
                return $query->whereHas('mahasiswa.user', function ($q) use ($search) {
                    $q->where('name', 'ilike', '%' . $search . '%')
                      ->orWhere('nim', 'ilike', '%' . $search . '%');
                });
            })
            ->paginate(15);

        $pengajuans->getCollection()->transform(function ($pengajuan) {
            $totalPersentase = $pengajuan->progressSkripsis->sum('persentase');
            $pengajuan->total_persentase = min($totalPersentase, 100);
            return $pengajuan;
        });

        return response()->json([
            'success' => true,
            'message' => 'Data monitoring progress berhasil diambil.',
            'data' => $pengajuans
        ], 200);
    }
}
