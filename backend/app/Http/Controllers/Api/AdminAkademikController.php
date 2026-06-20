<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\PendaftaranSidang;
use App\Models\Ruangan;
use Illuminate\Http\Request;
use Barryvdh\DomPDF\Facade\Pdf;

class AdminAkademikController extends Controller
{
    public function menungguJadwal()
    {
        $list = PendaftaranSidang::with(['mahasiswa.user', 'pengajuanJudul', 'pengujis.dosen.user', 'ruangan'])
            ->where('acc_pembimbing', true)
            ->whereHas('pengujis') // Harus sudah ada pengujinya (di-plot kaprodi)
            ->latest()
            ->get();

        return response()->json([
            'status' => 'success',
            'data' => $list
        ]);
    }

    public function getRuangans()
    {
        return response()->json([
            'status' => 'success',
            'data' => Ruangan::where('status_aktif', true)->get()
        ]);
    }

    public function plotJadwal(Request $request, $id)
    {
        $validated = $request->validate([
            'tanggal_sidang' => 'required|date',
            'waktu_mulai' => 'required|date_format:H:i',
            'waktu_selesai' => 'required|date_format:H:i|after:waktu_mulai',
            'ruangan_id' => 'required|exists:ruangans,id',
        ]);

        // Cek bentrok ruangan
        $bentrok = PendaftaranSidang::where('ruangan_id', $validated['ruangan_id'])
            ->where('tanggal_sidang', $validated['tanggal_sidang'])
            ->where(function ($query) use ($validated) {
                $query->whereBetween('waktu_mulai', [$validated['waktu_mulai'], $validated['waktu_selesai']])
                      ->orWhereBetween('waktu_selesai', [$validated['waktu_mulai'], $validated['waktu_selesai']]);
            })
            ->where('id', '!=', $id)
            ->exists();

        if ($bentrok) {
            return response()->json([
                'status' => 'error',
                'message' => 'Ruangan sudah terpakai pada jadwal tersebut.'
            ], 422);
        }

        $pendaftaran = PendaftaranSidang::findOrFail($id);
        $pendaftaran->update($validated);

        return response()->json([
            'status' => 'success',
            'message' => 'Jadwal sidang berhasil ditetapkan.'
        ]);
    }

    public function generateSk(Request $request, $id)
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

        $sidang = PendaftaranSidang::with(['mahasiswa.user', 'pengajuanJudul.pembimbings.dosen.user', 'pengujis.dosen.user'])
            ->findOrFail($id);

        $pdf = Pdf::loadView('pdf.sk_pembimbing', compact('sidang'));
        return $pdf->download('SK_Pembimbing_'.$sidang->mahasiswa->user->name.'.pdf');
    }

    public function generateBeritaAcara(Request $request, $id)
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

        $sidang = PendaftaranSidang::with(['mahasiswa.user', 'pengajuanJudul', 'pengujis.dosen.user', 'ruangan'])
            ->findOrFail($id);

        $pdf = Pdf::loadView('pdf.berita_acara', compact('sidang'));
        return $pdf->download('Berita_Acara_Sidang_'.$sidang->mahasiswa->user->name.'.pdf');
    }
}
