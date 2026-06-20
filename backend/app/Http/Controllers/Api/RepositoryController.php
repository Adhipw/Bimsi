<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Repository;
use App\Models\PendaftaranSidang;
use Illuminate\Http\Request;

class RepositoryController extends Controller
{
    public function publish(Request $request)
    {
        $validated = $request->validate([
            'pendaftaran_sidang_id' => 'required|exists:pendaftaran_sidangs,id',
            'abstrak' => 'required|string',
            'file_dokumen_akhir_url' => 'required|string',
        ]);

        $sidang = PendaftaranSidang::findOrFail($validated['pendaftaran_sidang_id']);

        $repo = Repository::create([
            'mahasiswa_id' => $sidang->mahasiswa_id,
            'pengajuan_judul_id' => $sidang->pengajuan_judul_id,
            'abstrak' => $validated['abstrak'],
            'file_dokumen_akhir_url' => $validated['file_dokumen_akhir_url']
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Skripsi berhasil dipublish ke Repository.',
            'data' => $repo
        ]);
    }

    public function indexPublic(Request $request)
    {
        $query = Repository::with(['mahasiswa.user', 'pengajuanJudul']);

        if ($request->has('search')) {
            $search = $request->search;
            $query->whereHas('pengajuanJudul', function($q) use ($search) {
                $q->where('judul', 'ILIKE', "%$search%");
            })->orWhereHas('mahasiswa.user', function($q) use ($search) {
                $q->where('name', 'ILIKE', "%$search%");
            });
        }

        $list = $query->latest()->paginate(10);

        return response()->json([
            'status' => 'success',
            'data' => $list
        ]);
    }

    public function showPublic($id)
    {
        $repo = Repository::with(['mahasiswa.user', 'pengajuanJudul'])->findOrFail($id);
        $repo->increment('views_count');

        return response()->json([
            'status' => 'success',
            'data' => $repo
        ]);
    }
}
