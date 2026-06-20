<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Dosen;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class DosenController extends Controller
{
    public function index()
    {
        return response()->json([
            'status' => 'success',
            'data' => Dosen::with('user', 'bidangKeahlians')->get()
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|string|min:8',
            'nidn' => 'required|string|unique:dosens,nidn',
            'jabatan_fungsional' => 'required|string',
            'bidang_keahlian_ids' => 'nullable|array',
            'bidang_keahlian_ids.*' => 'exists:bidang_keahlians,id',
        ]);

        $dosen = DB::transaction(function () use ($validated) {
            $user = User::create([
                'name' => $validated['name'],
                'email' => $validated['email'],
                'password' => Hash::make($validated['password']),
                'role' => 'dosen',
            ]);

            $dosen = Dosen::create([
                'user_id' => $user->id,
                'nidn' => $validated['nidn'],
                'jabatan_fungsional' => $validated['jabatan_fungsional'],
            ]);

            if (!empty($validated['bidang_keahlian_ids'])) {
                $dosen->bidangKeahlians()->sync($validated['bidang_keahlian_ids']);
            }

            return $dosen;
        });

        $dosen->load('user', 'bidangKeahlians');

        return response()->json([
            'status' => 'success',
            'message' => 'Dosen berhasil dibuat.',
            'data' => $dosen
        ], 201);
    }

    public function show(Dosen $dosen)
    {
        return response()->json([
            'status' => 'success',
            'data' => $dosen->load('user', 'bidangKeahlians')
        ]);
    }

    public function update(Request $request, Dosen $dosen)
    {
        $validated = $request->validate([
            'name' => 'required|string',
            'email' => 'required|email|unique:users,email,' . $dosen->user_id,
            'password' => 'nullable|string|min:8',
            'nidn' => 'required|string|unique:dosens,nidn,' . $dosen->id,
            'jabatan_fungsional' => 'required|string',
            'bidang_keahlian_ids' => 'nullable|array',
            'bidang_keahlian_ids.*' => 'exists:bidang_keahlians,id',
        ]);

        DB::transaction(function () use ($dosen, $validated) {
            $userUpdate = [
                'name' => $validated['name'],
                'email' => $validated['email'],
            ];

            if (!empty($validated['password'])) {
                $userUpdate['password'] = Hash::make($validated['password']);
            }

            $dosen->user()->update($userUpdate);

            $dosen->update([
                'nidn' => $validated['nidn'],
                'jabatan_fungsional' => $validated['jabatan_fungsional'],
            ]);

            if (isset($validated['bidang_keahlian_ids'])) {
                $dosen->bidangKeahlians()->sync($validated['bidang_keahlian_ids']);
            }
        });

        $dosen->load('user', 'bidangKeahlians');

        return response()->json([
            'status' => 'success',
            'message' => 'Dosen berhasil diperbarui.',
            'data' => $dosen
        ]);
    }

    public function destroy(Dosen $dosen)
    {
        DB::transaction(function () use ($dosen) {
            $dosen->user()->delete();
            $dosen->delete();
        });

        return response()->json([
            'status' => 'success',
            'message' => 'Dosen berhasil dihapus.'
        ]);
    }
}
