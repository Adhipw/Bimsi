<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Models\ReferensiMahasiswa;

class ReferensiMahasiswaController extends Controller
{
    public function index(Request $request)
    {
        $mahasiswa_id = $request->query('mahasiswa_id');
        
        $query = ReferensiMahasiswa::query();
        if ($mahasiswa_id) {
            $query->where('mahasiswa_id', $mahasiswa_id);
        }
        
        return response()->json($query->get());
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'mahasiswa_id' => 'required|exists:mahasiswas,id',
            'pengajuan_judul_id' => 'required|exists:pengajuan_juduls,id',
            'judul_artikel' => 'required|string',
            'penulis' => 'nullable|string',
            'tahun_terbit' => 'nullable|string',
            'url_tautan' => 'nullable|url',
            'tipe_referensi' => 'required|in:jurnal,buku,website',
        ]);

        $referensi = ReferensiMahasiswa::create($validated);
        return response()->json($referensi, 201);
    }

    public function destroy($id)
    {
        $referensi = ReferensiMahasiswa::findOrFail($id);
        $referensi->delete();

        return response()->json(['message' => 'Referensi deleted']);
    }
}
