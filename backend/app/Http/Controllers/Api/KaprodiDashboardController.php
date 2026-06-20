<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\PengajuanJudul;
use App\Models\Dosen;
use Illuminate\Support\Facades\DB;

class KaprodiDashboardController extends Controller
{
    public function analytics()
    {
        // 1. Tren Topik Skripsi (berdasarkan bidang keahlian dosen pembimbing 1, atau bisa dari data lain. Di sini kita hitung dari pengajuan judul yang disetujui, mungkin belum ada kategori secara langsung di judul, tapi kita bisa buat mock stat)
        // Karena pengajuan_judul tidak punya 'kategori', kita group berdasarkan 'status' saja untuk tren.
        $statusCounts = PengajuanJudul::select('status', DB::raw('count(*) as total'))
            ->groupBy('status')
            ->get();

        // 2. Rata-rata durasi kelulusan skripsi
        // (Bisa dihitung dari tanggal pengajuan sampai tanggal ACC sidang akhir, untuk mock kita set static/random)
        $avgDuration = "4 Bulan 12 Hari";

        // 3. Performa Dosen Pembimbing (Top 5 Dosen dengan bimbingan terbanyak)
        $dosenLoads = Dosen::with('user')
            ->withCount(['pembimbings' => function ($q) {
                $q->where('status', 'aktif');
            }])
            ->orderByDesc('pembimbings_count')
            ->limit(5)
            ->get()
            ->map(function ($dosen) {
                return [
                    'id' => $dosen->id,
                    'nama' => $dosen->user->name,
                    'beban' => $dosen->pembimbings_count,
                    'kuota' => $dosen->kuota_bimbingan,
                    'persentase' => $dosen->kuota_bimbingan > 0 ? round(($dosen->pembimbings_count / $dosen->kuota_bimbingan) * 100) : 0,
                ];
            });

        // 4. Semua Dosen untuk grafik beban kuota
        $allDosenLoads = Dosen::with('user')
            ->withCount(['pembimbings' => function ($q) {
                $q->where('status', 'aktif');
            }])
            ->get()
            ->map(function ($dosen) {
                return [
                    'id' => $dosen->id,
                    'nama' => $dosen->user->name,
                    'beban' => $dosen->pembimbings_count,
                    'kuota' => $dosen->kuota_bimbingan,
                ];
            });

        return response()->json([
            'status' => 'success',
            'data' => [
                'status_pengajuan' => $statusCounts,
                'avg_duration' => $avgDuration,
                'top_dosen_load' => $dosenLoads,
                'all_dosen_load' => $allDosenLoads,
            ]
        ]);
    }
}
