<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Mahasiswa;
use App\Models\ProgressSkripsi;
use Illuminate\Http\Request;
use Barryvdh\DomPDF\Facade\Pdf;
use App\Services\AuditLogService;

class LaporanController extends Controller
{
    public function mahasiswaSkripsi(Request $request)
    {
        $type = $request->query('export', 'json');
        
        $data = Mahasiswa::with(['user', 'programStudi', 'kelas', 'pengajuanJuduls' => function($q) {
            $q->where('status', 'disetujui');
        }])->get();

        AuditLogService::log('export_laporan', 'Laporan', 0, null, ['jenis' => 'Mahasiswa Skripsi', 'tipe' => $type]);

        if ($type === 'pdf') {
            return response()->json([
                'success' => true,
                'message' => 'Export PDF mahasiswa berhasil',
                'download_url' => url('/api/kaprodi/laporan/mahasiswa-skripsi/download?type=pdf&token=' . $request->bearerToken())
            ]);
        } else if ($type === 'excel') {
            return response()->json([
                'success' => true,
                'message' => 'Export Excel mahasiswa berhasil',
                'download_url' => url('/api/kaprodi/laporan/mahasiswa-skripsi/download?type=excel&token=' . $request->bearerToken())
            ]);
        }

        return response()->json([
            'success' => true,
            'data' => $data
        ]);
    }

    public function download(Request $request)
    {
        $token = $request->query('token');
        if ($token) {
            $accessToken = \Laravel\Sanctum\PersonalAccessToken::findToken($token);
            if (!$accessToken || !$accessToken->tokenable) {
                return response('Unauthorized', 401);
            }
        } else {
             return response('Unauthorized', 401);
        }

        $type = $request->query('type');
        $data = Mahasiswa::with(['user', 'programStudi', 'kelas', 'pengajuanJuduls' => function($q) {
            $q->where('status', 'disetujui');
        }])->get();

        if ($type === 'pdf') {
            $pdf = Pdf::loadView('exports.mahasiswa', compact('data'));
            return $pdf->download('laporan_mahasiswa.pdf');
        } else if ($type === 'excel') {
            $csvData = "No,NIM,Nama Mahasiswa,Program Studi,Kelas,Status Skripsi\n";
            foreach($data as $index => $mhs) {
                $status = ($mhs->pengajuanJuduls && $mhs->pengajuanJuduls->count() > 0) ? 'Disetujui' : 'Belum Mengajukan/Proses';
                $nama = $mhs->user->name ?? '-';
                $prodi = $mhs->programStudi->nama_prodi ?? '-';
                $kelas = $mhs->kelas->nama_kelas ?? '-';
                $csvData .= "".($index+1).",{$mhs->nim},\"{$nama}\",\"{$prodi}\",\"{$kelas}\",\"{$status}\"\n";
            }
            return response($csvData, 200, [
                'Content-Type' => 'text/csv',
                'Content-Disposition' => 'attachment; filename="laporan_mahasiswa.csv"',
            ]);
        }
        
        return response('Invalid type', 400);
    }
}
