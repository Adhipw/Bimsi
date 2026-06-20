<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Models\CatatanPrivatDosen;

class CatatanPrivatDosenController extends Controller
{
    public function show($mahasiswa_id, Request $request)
    {
        $dosen_id = $request->user()->dosen->id ?? null; // Asumsi relasi user->dosen
        
        $catatan = CatatanPrivatDosen::where('mahasiswa_id', $mahasiswa_id)
            ->where('dosen_id', $dosen_id)
            ->first();

        return response()->json($catatan);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'mahasiswa_id' => 'required|exists:mahasiswas,id',
            'catatan' => 'required|string',
        ]);

        $dosen_id = $request->user()->dosen->id ?? null;
        $validated['dosen_id'] = $dosen_id;

        $catatan = CatatanPrivatDosen::updateOrCreate(
            ['dosen_id' => $dosen_id, 'mahasiswa_id' => $validated['mahasiswa_id']],
            ['catatan' => $validated['catatan']]
        );

        return response()->json($catatan, 201);
    }

    public function destroy($id)
    {
        $catatan = CatatanPrivatDosen::findOrFail($id);
        $catatan->delete();

        return response()->json(['message' => 'Deleted']);
    }
}
