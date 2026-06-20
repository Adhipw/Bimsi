<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Models\LogbookBimbingan;

class LogbookBimbinganController extends Controller
{
    public function index()
    {
        $data = LogbookBimbingan::with(['mahasiswa.user', 'dosen.user'])->get();
        return response()->json($data);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'mahasiswa_id' => 'required|exists:mahasiswas,id',
            'pengajuan_judul_id' => 'required|exists:pengajuan_juduls,id',
            'dosen_id' => 'required|exists:dosens,id',
            'tanggal_kegiatan' => 'required|date',
            'deskripsi_kegiatan' => 'required|string',
            'bukti_file_url' => 'nullable|string',
        ]);

        $logbook = LogbookBimbingan::create($validated);
        return response()->json($logbook, 201);
    }

    public function show($id)
    {
        $logbook = LogbookBimbingan::with(['mahasiswa.user', 'dosen.user'])->findOrFail($id);
        return response()->json($logbook);
    }

    public function updateApproval(Request $request, $id)
    {
        $validated = $request->validate([
            'status_approval' => 'required|in:pending,approved,revised'
        ]);

        $logbook = LogbookBimbingan::findOrFail($id);
        $logbook->update($validated);

        return response()->json($logbook);
    }
}
