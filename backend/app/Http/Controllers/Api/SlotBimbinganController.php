<?php
 
namespace App\Http\Controllers\Api;
 
use App\Http\Controllers\Controller;
use App\Models\SlotBimbingan;
use Illuminate\Http\Request;
 
class SlotBimbinganController extends Controller
{
    /**
     * Tampilkan daftar slot bimbingan milik dosen yang login.
     */
    public function index(Request $request)
    {
        $dosen = $request->user()->dosen;
        if (!$dosen) {
            return response()->json([
                'status' => 'error',
                'message' => 'Data dosen tidak ditemukan.'
            ], 404);
        }
 
        $slots = SlotBimbingan::where('dosen_id', $dosen->id)
            ->orderByRaw("FIELD(hari, 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu')")
            ->orderBy('jam_mulai')
            ->get();
 
        return response()->json([
            'status' => 'success',
            'data' => $slots
        ]);
    }
 
    /**
     * Simpan slot bimbingan baru.
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
            'hari' => 'required|string|in:Senin,Selasa,Rabu,Kamis,Jumat,Sabtu,Minggu',
            'jam_mulai' => 'required|date_format:H:i',
            'jam_selesai' => 'required|date_format:H:i|after:jam_mulai',
            'kuota' => 'required|integer|min:1',
        ]);
 
        $slot = SlotBimbingan::create([
            'dosen_id' => $dosen->id,
            'hari' => $validated['hari'],
            'jam_mulai' => $validated['jam_mulai'],
            'jam_selesai' => $validated['jam_selesai'],
            'kuota' => $validated['kuota'],
        ]);
 
        return response()->json([
            'status' => 'success',
            'message' => 'Slot bimbingan berhasil dibuat.',
            'data' => $slot
        ], 201);
    }
 
    /**
     * Hapus slot bimbingan.
     */
    public function destroy($id)
    {
        $slot = SlotBimbingan::findOrFail($id);
        $slot->delete();
 
        return response()->json([
            'status' => 'success',
            'message' => 'Slot bimbingan berhasil dihapus.'
        ]);
    }
}
