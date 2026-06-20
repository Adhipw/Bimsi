<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ProgramStudi;
use Illuminate\Http\Request;

class ProgramStudiController extends Controller
{
    public function index()
    {
        return response()->json([
            'status' => 'success',
            'data' => ProgramStudi::all()
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'kode_prodi' => 'required|string|unique:program_studis,kode_prodi',
            'nama_prodi' => 'required|string',
            'jenjang' => 'required|string',
        ]);

        $programStudi = ProgramStudi::create($validated);

        return response()->json([
            'status' => 'success',
            'message' => 'Program Studi berhasil dibuat.',
            'data' => $programStudi
        ], 201);
    }

    public function show(ProgramStudi $programStudi)
    {
        return response()->json([
            'status' => 'success',
            'data' => $programStudi
        ]);
    }

    public function update(Request $request, ProgramStudi $programStudi)
    {
        $validated = $request->validate([
            'kode_prodi' => 'required|string|unique:program_studis,kode_prodi,' . $programStudi->id,
            'nama_prodi' => 'required|string',
            'jenjang' => 'required|string',
        ]);

        $programStudi->update($validated);

        return response()->json([
            'status' => 'success',
            'message' => 'Program Studi berhasil diperbarui.',
            'data' => $programStudi
        ]);
    }

    public function destroy(ProgramStudi $programStudi)
    {
        $programStudi->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Program Studi berhasil dihapus.'
        ]);
    }
}
