<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Mahasiswa;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class MahasiswaController extends Controller
{
    public function index()
    {
        return response()->json([
            'status' => 'success',
            'data' => Mahasiswa::with('user', 'programStudi', 'kelas')->get()
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|string|min:8',
            'nim' => 'required|string|unique:mahasiswas,nim',
            'program_studi_id' => 'required|exists:program_studis,id',
            'kelas_id' => 'required|exists:kelas,id',
            'tahun_masuk' => 'required|string',
        ]);

        $mahasiswa = DB::transaction(function () use ($validated) {
            $user = User::create([
                'name' => $validated['name'],
                'email' => $validated['email'],
                'password' => Hash::make($validated['password']),
                'role' => 'mahasiswa',
            ]);

            return Mahasiswa::create([
                'user_id' => $user->id,
                'nim' => $validated['nim'],
                'program_studi_id' => $validated['program_studi_id'],
                'kelas_id' => $validated['kelas_id'],
                'tahun_masuk' => $validated['tahun_masuk'],
            ]);
        });

        $mahasiswa->load('user', 'programStudi', 'kelas');

        return response()->json([
            'status' => 'success',
            'message' => 'Mahasiswa berhasil dibuat.',
            'data' => $mahasiswa
        ], 201);
    }

    public function show(Mahasiswa $mahasiswa)
    {
        return response()->json([
            'status' => 'success',
            'data' => $mahasiswa->load('user', 'programStudi', 'kelas')
        ]);
    }

    public function update(Request $request, Mahasiswa $mahasiswa)
    {
        $validated = $request->validate([
            'name' => 'required|string',
            'email' => 'required|email|unique:users,email,' . $mahasiswa->user_id,
            'password' => 'nullable|string|min:8',
            'nim' => 'required|string|unique:mahasiswas,nim,' . $mahasiswa->id,
            'program_studi_id' => 'required|exists:program_studis,id',
            'kelas_id' => 'required|exists:kelas,id',
            'tahun_masuk' => 'required|string',
        ]);

        DB::transaction(function () use ($mahasiswa, $validated) {
            $userUpdate = [
                'name' => $validated['name'],
                'email' => $validated['email'],
            ];

            if (!empty($validated['password'])) {
                $userUpdate['password'] = Hash::make($validated['password']);
            }

            $mahasiswa->user()->update($userUpdate);

            $mahasiswa->update([
                'nim' => $validated['nim'],
                'program_studi_id' => $validated['program_studi_id'],
                'kelas_id' => $validated['kelas_id'],
                'tahun_masuk' => $validated['tahun_masuk'],
            ]);
        });

        $mahasiswa->load('user', 'programStudi', 'kelas');

        return response()->json([
            'status' => 'success',
            'message' => 'Mahasiswa berhasil diperbarui.',
            'data' => $mahasiswa
        ]);
    }

    public function destroy(Mahasiswa $mahasiswa)
    {
        DB::transaction(function () use ($mahasiswa) {
            $mahasiswa->user()->delete();
            $mahasiswa->delete();
        });

        return response()->json([
            'status' => 'success',
            'message' => 'Mahasiswa berhasil dihapus.'
        ]);
    }
}
