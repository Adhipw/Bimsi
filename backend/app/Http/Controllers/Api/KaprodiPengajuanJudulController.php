<?php
 
namespace App\Http\Controllers\Api;
 
use App\Http\Controllers\Controller;
use App\Models\PengajuanJudul;
use App\Models\RiwayatPengajuanJudul;
use App\Models\Notifikasi;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
 
class KaprodiPengajuanJudulController extends Controller
{
    /**
     * Tampilkan daftar pengajuan judul untuk Kaprodi.
     */
    public function index(Request $request)
    {
        $query = PengajuanJudul::with(['mahasiswa.user', 'mahasiswa.programStudi', 'periodeSkripsi'])
            ->latest();
 
        // Filter berdasarkan status
        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }
 
        // Pencarian berdasarkan judul, nama mahasiswa, atau NIM
        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('judul', 'like', "%{$search}%")
                  ->orWhereHas('mahasiswa', function ($q2) use ($search) {
                      $q2->where('nim', 'like', "%{$search}%")
                         ->orWhereHas('user', function ($q3) use ($search) {
                             $q3->where('name', 'like', "%{$search}%");
                         });
                  });
            });
        }
 
        return response()->json([
            'status' => 'success',
            'data' => $query->get()
        ]);
    }
 
    /**
     * Tampilkan rincian pengajuan judul beserta riwayat statusnya.
     */
    public function show($id)
    {
        $pengajuan = PengajuanJudul::with([
            'mahasiswa.user',
            'mahasiswa.programStudi',
            'periodeSkripsi',
            'riwayatPengajuans' => function ($q) {
                $q->latest();
            }
        ])->findOrFail($id);
 
        return response()->json([
            'status' => 'success',
            'data' => $pengajuan
        ]);
    }
 
    /**
     * Setujui pengajuan judul skripsi.
     */
    public function approve(Request $request, $id)
    {
        $pengajuan = PengajuanJudul::findOrFail($id);
 
        if ($pengajuan->status === 'disetujui') {
            return response()->json([
                'status' => 'error',
                'message' => 'Pengajuan judul ini sudah disetujui sebelumnya.'
            ], 422);
        }
 
        $catatan = $request->input('catatan', 'Judul skripsi disetujui oleh Kaprodi.');
        $statusSebelumnya = $pengajuan->status;
 
        DB::transaction(function () use ($pengajuan, $statusSebelumnya, $catatan) {
            $pengajuan->update([
                'status' => 'disetujui'
            ]);
 
            RiwayatPengajuanJudul::create([
                'pengajuan_judul_id' => $pengajuan->id,
                'status_sebelumnya' => $statusSebelumnya,
                'status_baru' => 'disetujui',
                'keterangan' => $catatan,
            ]);
 
            // Kirim notifikasi internal ke mahasiswa
            Notifikasi::create([
                'user_id' => $pengajuan->mahasiswa->user_id,
                'judul' => 'Judul Skripsi Disetujui',
                'pesan' => "Pengajuan judul skripsi Anda yang berjudul \"{$pengajuan->judul}\" telah disetujui oleh Kaprodi.",
            ]);

            event(new \App\Events\StatusJudulUpdatedEvent($pengajuan));

            $fcmToken = $pengajuan->mahasiswa->user->fcm_token;
            if ($fcmToken) {
                app(\App\Services\FirebaseNotificationService::class)->sendPushNotification(
                    $fcmToken,
                    'Judul Skripsi Disetujui',
                    "Pengajuan judul skripsi Anda yang berjudul \"{$pengajuan->judul}\" telah disetujui oleh Kaprodi."
                );
            }
        });
 
        return response()->json([
            'status' => 'success',
            'message' => 'Pengajuan judul berhasil disetujui.',
            'data' => $pengajuan->load('periodeSkripsi')
        ]);
    }
 
    /**
     * Tolak atau minta revisi pengajuan judul skripsi.
     */
    public function reject(Request $request, $id)
    {
        $pengajuan = PengajuanJudul::findOrFail($id);
 
        $validated = $request->validate([
            'status' => 'required|in:ditolak,revisi',
            'catatan' => 'required|string|min:5',
        ]);
 
        $statusSebelumnya = $pengajuan->status;
        $statusBaru = $validated['status'];
        $catatan = $validated['catatan'];
 
        DB::transaction(function () use ($pengajuan, $statusSebelumnya, $statusBaru, $catatan) {
            $pengajuan->update([
                'status' => $statusBaru
            ]);
 
            RiwayatPengajuanJudul::create([
                'pengajuan_judul_id' => $pengajuan->id,
                'status_sebelumnya' => $statusSebelumnya,
                'status_baru' => $statusBaru,
                'keterangan' => $catatan,
            ]);
 
            $judulNotifikasi = $statusBaru === 'revisi' ? 'Judul Skripsi Butuh Revisi' : 'Judul Skripsi Ditolak';
            $pesanNotifikasi = $statusBaru === 'revisi'
                ? "Kaprodi meminta Anda merevisi judul skripsi. Catatan: \"{$catatan}\""
                : "Pengajuan judul skripsi Anda telah ditolak oleh Kaprodi. Catatan: \"{$catatan}\"";
 
            // Kirim notifikasi internal ke mahasiswa
            Notifikasi::create([
                'user_id' => $pengajuan->mahasiswa->user_id,
                'judul' => $judulNotifikasi,
                'pesan' => $pesanNotifikasi,
            ]);

            event(new \App\Events\StatusJudulUpdatedEvent($pengajuan));

            $fcmToken = $pengajuan->mahasiswa->user->fcm_token;
            if ($fcmToken) {
                app(\App\Services\FirebaseNotificationService::class)->sendPushNotification(
                    $fcmToken,
                    $judulNotifikasi,
                    $pesanNotifikasi
                );
            }
        });
 
        return response()->json([
            'status' => 'success',
            'message' => "Pengajuan judul berhasil diproses dengan status: {$statusBaru}.",
            'data' => $pengajuan->load('periodeSkripsi')
        ]);
    }
 
    /**
     * Cek kemiripan judul sederhana berbasis keyword overlap.
     */
    public function cekKemiripan(Request $request)
    {
        $judul = $request->query('judul');
        $excludeId = $request->query('exclude_id');
 
        if (!$judul) {
            return response()->json([
                'status' => 'success',
                'data' => []
            ]);
        }
 
        // Stop words removal list (Bahasa Indonesia & Inggris umum dalam judul skripsi)
        $stopWords = [
            'aplikasi', 'sistem', 'informasi', 'berbasis', 'web', 'android', 'pada', 
            'menggunakan', 'metode', 'dengan', 'dan', 'di', 'rancang', 'bangun', 
            'uji', 'analisis', 'desain', 'pembuatan', 'implementasi', 'studi', 'kasus',
            'the', 'of', 'and', 'in', 'using', 'based', 'on', 'development', 'for', 'to'
        ];
 
        // Bersihkan tanda baca, jadikan lowercase
        $cleanJudul = strtolower(preg_replace('/[^a-zA-Z0-9\s]/', '', $judul));
        $words = array_filter(explode(' ', $cleanJudul));
        
        // Dapatkan kata kunci utama
        $keywords = array_values(array_diff($words, $stopWords));
 
        if (empty($keywords)) {
            return response()->json([
                'status' => 'success',
                'data' => []
            ]);
        }
 
        // Tarik semua judul pengajuan skripsi yang ada
        $query = PengajuanJudul::with('mahasiswa.user');
        if ($excludeId) {
            $query->where('id', '!=', $excludeId);
        }
        $allTitles = $query->get();
 
        $results = [];
        foreach ($allTitles as $item) {
            $targetClean = strtolower(preg_replace('/[^a-zA-Z0-9\s]/', '', $item->judul));
            $targetWords = array_filter(explode(' ', $targetClean));
 
            // Hitung kata yang sama
            $matchedWords = array_intersect($keywords, $targetWords);
            $score = 0;
            if (count($keywords) > 0) {
                $score = round((count($matchedWords) / count($keywords)) * 100);
            }
 
            // Tampilkan yang memiliki kemiripan minimal 10%
            if ($score >= 10) {
                $results[] = [
                    'id' => $item->id,
                    'judul' => $item->judul,
                    'mahasiswa' => $item->mahasiswa->user->name ?? 'Mahasiswa',
                    'nim' => $item->mahasiswa->nim ?? '',
                    'status' => $item->status,
                    'persentase' => $score,
                    'kata_kunci_cocok' => array_values($matchedWords)
                ];
            }
        }
 
        // Urutkan dari persentase kemiripan tertinggi
        usort($results, function ($a, $b) {
            return $b['persentase'] <=> $a['persentase'];
        });
 
        return response()->json([
            'status' => 'success',
            'data' => array_slice($results, 0, 5) // Ambil 5 teratas saja
        ]);
    }
}
