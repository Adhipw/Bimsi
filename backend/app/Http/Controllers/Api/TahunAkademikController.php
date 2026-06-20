<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\TahunAkademik;
use Illuminate\Http\Request;

class TahunAkademikController extends Controller
{
    public function index()
    {
        return response()->json([
            'status' => 'success',
            'data' => TahunAkademik::all()
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'tahun' => 'required|string',
            'is_active' => 'required|boolean',
        ]);

        if ($validated['is_active']) {
            TahunAkademik::query()->update(['is_active' => false]);
        }

        $tahunAkademik = TahunAkademik::create($validated);

        return response()->json([
            'status' => 'success',
            'message' => 'Tahun Akademik berhasil dibuat.',
            'data' => $tahunAkademik
        ], 201);
    }

    public function show(TahunAkademik $tahunAkademik)
    {
        return response()->json([
            'status' => 'success',
            'data' => $tahunAkademik
        ]);
    }

    public function update(Request $request, TahunAkademik $tahunAkademik)
    {
        $validated = $request->validate([
            'tahun' => 'required|string',
            'is_active' => 'required|boolean',
        ]);

        if ($validated['is_active']) {
            TahunAkademik::query()->where('id', '!=', $tahunAkademik->id)->update(['is_active' => false]);
        }

        $tahunAkademik->update($validated);

        return response()->json([
            'status' => 'success',
            'message' => 'Tahun Akademik berhasil diperbarui.',
            'data' => $tahunAkademik
        ]);
    }

    public function destroy(TahunAkademik $tahunAkademik)
    {
        $tahunAkademik->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Tahun Akademik berhasil dihapus.'
        ]);
    }
}
