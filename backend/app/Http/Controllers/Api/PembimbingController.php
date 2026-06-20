<?php
 
namespace App\Http\Controllers\Api;
 
use App\Http\Controllers\Controller;
use App\Models\Pembimbing;
use App\Models\PengajuanJudul;
use App\Models\PeriodeSkripsi;
use Illuminate\Http\Request;
 
class PembimbingController extends Controller
{
    /**
     * Tampilkan dosen pembimbing mahasiswa yang sedang login.
     */
    public function mahasiswaPembimbing(Request $request)
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
                'data' => []
            ]);
        }
 
        // Ambil judul aktif yang disetujui pada periode ini
        $pengajuan = PengajuanJudul::with(['pembimbings.dosen.user', 'pembimbings.dosen.bidangKeahlians'])
            ->where('mahasiswa_id', $mahasiswa->id)
            ->where('periode_skripsi_id', $periode->id)
            ->where('status', 'disetujui')
            ->first();
 
        if (!$pengajuan) {
            return response()->json([
                'status' => 'success',
                'data' => []
            ]);
        }
 
        return response()->json([
            'status' => 'success',
            'data' => $pengajuan->pembimbings
        ]);
    }
 
    /**
     * Tampilkan daftar mahasiswa bimbingan aktif untuk dosen yang sedang login.
     */
    public function dosenMahasiswaBimbingan(Request $request)
    {
        $user = $request->user();
        $dosen = $user->dosen;
 
        if (!$dosen) {
            return response()->json([
                'status' => 'error',
                'message' => 'Data dosen tidak ditemukan.'
            ], 404);
        }
 
        // Ambil mahasiswa bimbingan yang aktif
        $bimbingans = Pembimbing::with([
            'pengajuanJudul.mahasiswa.user',
            'pengajuanJudul.mahasiswa.programStudi',
            'pengajuanJudul.mahasiswa.kelas',
            'pengajuanJudul.periodeSkripsi'
        ])
        ->where('dosen_id', $dosen->id)
        ->where('status', 'aktif')
        ->whereHas('pengajuanJudul', function ($q) {
            $q->where('status', 'disetujui');
        })
        ->get();
 
        return response()->json([
            'status' => 'success',
            'data' => $bimbingans
        ]);
    }
}
