<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Kelas;
use Illuminate\Http\Request;

class KelasController extends Controller
{
    public function index()
    {
        return response()->json([
            'status' => 'success',
            'data' => Kelas::with('programStudi')->get()
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'nama_kelas' => 'required|string',
            'program_studi_id' => 'required|exists:program_studis,id',
        ]);

        $kelas = Kelas::create($validated);
        $kelas->load('programStudi');

        return response()->json([
            'status' => 'success',
            'message' => 'Kelas berhasil dibuat.',
            'data' => $kelas
        ], 201);
    }

    public function show(Kelas $kelas)
    {
        return response()->json([
            'status' => 'success',
            'data' => $kelas->load('programStudi')
        ]);
    }

    public function update(Request $request, Kelas $kelas)
    {
        $validated = $request->validate([
            'nama_kelas' => 'required|string',
            'program_studi_id' => 'required|exists:program_studis,id',
        ]);

        $kelas->update($validated);
        $kelas->load('programStudi');

        return response()->json([
            'status' => 'success',
            'message' => 'Kelas berhasil diperbarui.',
            'data' => $kelas
        ]);
    }

    public function destroy(Kelas $kelas)
    {
        $kelas->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Kelas berhasil dihapus.'
        ]);
    }
}
