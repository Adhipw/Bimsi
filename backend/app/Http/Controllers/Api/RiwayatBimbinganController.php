<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\RiwayatBimbingan;
use App\Models\JadwalBimbingan;
use Illuminate\Http\Request;

class RiwayatBimbinganController extends Controller
{
    /**
     * Tampilkan riwayat bimbingan untuk Dosen yang login.
     */
    public function dosenIndex(Request $request)
    {
        $dosen = $request->user()->dosen;
        if (!$dosen) {
            return response()->json([
                'status' => 'error',
                'message' => 'Data dosen tidak ditemukan.'
            ], 404);
        }

        $list = RiwayatBimbingan::with(['jadwalBimbingan.pembimbing.pengajuanJudul.mahasiswa.user', 'jadwalBimbingan.slotBimbingan'])
            ->whereHas('jadwalBimbingan.pembimbing', function ($q) use ($dosen) {
                $q->where('dosen_id', $dosen->id);
            })
            ->latest()
            ->get();

        return response()->json([
            'status' => 'success',
            'data' => $list
        ]);
    }

    /**
     * Tampilkan riwayat bimbingan untuk Mahasiswa yang login.
     */
    public function mahasiswaIndex(Request $request)
    {
        $mahasiswa = $request->user()->mahasiswa;
        if (!$mahasiswa) {
            return response()->json([
                'status' => 'error',
                'message' => 'Data mahasiswa tidak ditemukan.'
            ], 404);
        }

        $list = RiwayatBimbingan::with(['jadwalBimbingan.pembimbing.dosen.user', 'jadwalBimbingan.slotBimbingan'])
            ->whereHas('jadwalBimbingan.pembimbing.pengajuanJudul', function ($q) use ($mahasiswa) {
                $q->where('mahasiswa_id', $mahasiswa->id);
            })
            ->latest()
            ->get();

        return response()->json([
            'status' => 'success',
            'data' => $list
        ]);
    }

    /**
     * Ambil daftar jadwal bimbingan yang disetujui (approved) milik dosen yang login
     * dan belum memiliki riwayat bimbingan.
     */
    public function approvedJadwalList(Request $request)
    {
        $dosen = $request->user()->dosen;
        if (!$dosen) {
            return response()->json([
                'status' => 'error',
                'message' => 'Data dosen tidak ditemukan.'
            ], 404);
        }

        // Ambil jadwal bimbingan status approved yang belum diinput riwayatnya
        $list = JadwalBimbingan::with(['pembimbing.pengajuanJudul.mahasiswa.user', 'slotBimbingan'])
            ->where('status', 'approved')
            ->whereHas('pembimbing', function ($q) use ($dosen) {
                $q->where('dosen_id', $dosen->id);
            })
            ->whereDoesntHave('riwayatBimbingans') // Menggunakan nama relasi plural sesuai JadwalBimbingan.php
            ->latest()
            ->get();

        return response()->json([
            'status' => 'success',
            'data' => $list
        ]);
    }

    /**
     * Simpan riwayat bimbingan baru oleh Dosen.
     */
    public function store(Request $request)
    {
        $dosen = $request->user()->dosen;
        if (!$dosen) {
            return response()->json([
                'status' => 'error',
                'message' => 'Data dosen tidak ditemukan.'
            ], 404);
        }

        $validated = $request->validate([
            'jadwal_bimbingan_id' => 'required|exists:jadwal_bimbingans,id',
            'catatan_dosen' => 'required|string',
            'status' => 'required|string|in:selesai,revisi', // Status revisi: selesai atau revisi
            'catatan_mahasiswa' => 'nullable|string',
        ]);

        $jadwal = JadwalBimbingan::findOrFail($validated['jadwal_bimbingan_id']);

        // 1. Validasi kepemilikan jadwal dosen
        if ($jadwal->pembimbing->dosen_id !== $dosen->id) {
            return response()->json([
                'status' => 'error',
                'message' => 'Anda tidak berwenang menginput riwayat untuk jadwal bimbingan ini.'
            ], 403);
        }

        // 2. Validasi status jadwal bimbingan (harus approved)
        if ($jadwal->status !== 'approved') {
            return response()->json([
                'status' => 'error',
                'message' => 'Riwayat bimbingan hanya dapat diinput untuk jadwal bimbingan yang telah disetujui (approved).'
            ], 422);
        }

        // 3. Validasi keunikan (satu jadwal maksimal satu riwayat)
        $existing = RiwayatBimbingan::where('jadwal_bimbingan_id', $validated['jadwal_bimbingan_id'])->first();
        if ($existing) {
            return response()->json([
                'status' => 'error',
                'message' => 'Riwayat bimbingan untuk jadwal ini sudah diinput sebelumnya.'
            ], 422);
        }

        $riwayat = RiwayatBimbingan::create([
            'jadwal_bimbingan_id' => $validated['jadwal_bimbingan_id'],
            'catatan_dosen' => $validated['catatan_dosen'],
            'status' => $validated['status'],
            'catatan_mahasiswa' => $validated['catatan_mahasiswa'] ?? null,
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Riwayat bimbingan dan catatan revisi berhasil disimpan.',
            'data' => $riwayat->load(['jadwalBimbingan.pembimbing.pengajuanJudul.mahasiswa.user', 'jadwalBimbingan.slotBimbingan'])
        ], 201);
    }
}
