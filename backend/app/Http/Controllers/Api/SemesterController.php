<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Semester;
use Illuminate\Http\Request;

class SemesterController extends Controller
{
    public function index()
    {
        return response()->json([
            'status' => 'success',
            'data' => Semester::all()
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'nama' => 'required|string',
            'is_active' => 'required|boolean',
        ]);

        if ($validated['is_active']) {
            Semester::query()->update(['is_active' => false]);
        }

        $semester = Semester::create($validated);

        return response()->json([
            'status' => 'success',
            'message' => 'Semester berhasil dibuat.',
            'data' => $semester
        ], 201);
    }

    public function show(Semester $semester)
    {
        return response()->json([
            'status' => 'success',
            'data' => $semester
        ]);
    }

    public function update(Request $request, Semester $semester)
    {
        $validated = $request->validate([
            'nama' => 'required|string',
            'is_active' => 'required|boolean',
        ]);

        if ($validated['is_active']) {
            Semester::query()->where('id', '!=', $semester->id)->update(['is_active' => false]);
        }

        $semester->update($validated);

        return response()->json([
            'status' => 'success',
            'message' => 'Semester berhasil diperbarui.',
            'data' => $semester
        ]);
    }

    public function destroy(Semester $semester)
    {
        $semester->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Semester berhasil dihapus.'
        ]);
    }
}
