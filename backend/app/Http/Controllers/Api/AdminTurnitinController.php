<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\PendaftaranSidang;
use Illuminate\Http\Request;

class AdminTurnitinController extends Controller
{
    public function menungguVerifikasi()
    {
        $list = PendaftaranSidang::with(['mahasiswa.user', 'pengajuanJudul'])
            ->whereNotNull('turnitin_file_url')
            ->where('turnitin_status', 'pending')
            ->latest()
            ->get();

        return response()->json([
            'status' => 'success',
            'data' => $list
        ]);
    }

    public function verifikasi(Request $request, $id)
    {
        $validated = $request->validate([
            'turnitin_status' => 'required|in:approved,rejected',
        ]);

        $pendaftaran = PendaftaranSidang::findOrFail($id);
        $pendaftaran->update([
            'turnitin_status' => $validated['turnitin_status']
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Status Turnitin berhasil diupdate.'
        ]);
    }
}
