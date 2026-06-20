<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Models\PusatBantuan;

class PusatBantuanController extends Controller
{
    public function indexPublic(Request $request)
    {
        $kategori = $request->query('kategori');
        
        $query = PusatBantuan::where('is_active', true);
        if ($kategori) {
            $query->where('kategori', $kategori);
        }
        
        return response()->json($query->get());
    }

    public function indexAdmin()
    {
        return response()->json(PusatBantuan::all());
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'kategori' => 'required|in:faq,dokumen_template',
            'judul_pertanyaan_atau_dokumen' => 'required|string',
            'isi_jawaban_atau_url_file' => 'required|string',
            'is_active' => 'boolean',
        ]);

        $bantuan = PusatBantuan::create($validated);
        return response()->json($bantuan, 201);
    }

    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'kategori' => 'required|in:faq,dokumen_template',
            'judul_pertanyaan_atau_dokumen' => 'required|string',
            'isi_jawaban_atau_url_file' => 'required|string',
            'is_active' => 'boolean',
        ]);

        $bantuan = PusatBantuan::findOrFail($id);
        $bantuan->update($validated);

        return response()->json($bantuan);
    }

    public function destroy($id)
    {
        $bantuan = PusatBantuan::findOrFail($id);
        $bantuan->delete();

        return response()->json(['message' => 'Deleted']);
    }
}
