<?php
 
namespace App\Http\Controllers\Api;
 
use App\Http\Controllers\Controller;
use App\Models\JadwalBimbingan;
use App\Models\SlotBimbingan;
use App\Models\Pembimbing;
use Illuminate\Http\Request;
 
class JadwalBimbinganController extends Controller
{
    /**
     * Tampilkan jadwal bimbingan untuk Mahasiswa yang login.
     */
    public function mahasiswaJadwal(Request $request)
    {
        $mahasiswa = $request->user()->mahasiswa;
        if (!$mahasiswa) {
            return response()->json([
                'status' => 'error',
                'message' => 'Data mahasiswa tidak ditemukan.'
            ], 404);
        }
 
        $list = JadwalBimbingan::with(['pembimbing.dosen.user', 'slotBimbingan'])
            ->whereHas('pembimbing.pengajuanJudul', function ($q) use ($mahasiswa) {
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
     * Ambil slot bimbingan yang tersedia dari dosen pembimbing tertentu.
     */
    public function pembimbingSlots($pembimbingId)
    {
        $pembimbing = Pembimbing::findOrFail($pembimbingId);
        $slots = SlotBimbingan::where('dosen_id', $pembimbing->dosen_id)
            ->orderByRaw("FIELD(hari, 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu')")
            ->orderBy('jam_mulai')
            ->get();
 
        return response()->json([
            'status' => 'success',
            'data' => $slots
        ]);
    }
 
    /**
     * Ajukan jadwal bimbingan baru oleh Mahasiswa.
     */
    public function ajukan(Request $request)
    {
        $mahasiswa = $request->user()->mahasiswa;
        if (!$mahasiswa) {
            return response()->json([
                'status' => 'error',
                'message' => 'Data mahasiswa tidak ditemukan.'
            ], 404);
        }
 
        $validated = $request->validate([
            'pembimbing_id' => 'required|exists:pembimbings,id',
            'slot_bimbingan_id' => 'required|exists:slot_bimbingans,id',
            'tanggal' => 'required|date|after_or_equal:today',
        ]);
 
        $slot = SlotBimbingan::findOrFail($validated['slot_bimbingan_id']);
        $pembimbing = Pembimbing::findOrFail($validated['pembimbing_id']);
 
        // 1. Validasi kecocokan hari
        $dayNames = [
            'Sunday' => 'Minggu',
            'Monday' => 'Senin',
            'Tuesday' => 'Selasa',
            'Wednesday' => 'Rabu',
            'Thursday' => 'Kamis',
            'Friday' => 'Jumat',
            'Saturday' => 'Sabtu'
        ];
        $engDay = date('l', strtotime($validated['tanggal']));
        $indoDay = $dayNames[$engDay];
 
        if ($slot->hari !== $indoDay) {
            return response()->json([
                'status' => 'error',
                'message' => "Slot bimbingan ini hanya tersedia pada hari {$slot->hari}, sedangkan tanggal yang Anda pilih adalah hari {$indoDay}."
            ], 422);
        }
 
        // 2. Validasi Kuota Slot pada tanggal tersebut
        $bookedCount = JadwalBimbingan::where('slot_bimbingan_id', $slot->id)
            ->where('tanggal', $validated['tanggal'])
            ->whereIn('status', ['scheduled', 'approved'])
            ->count();
 
        if ($bookedCount >= $slot->kuota) {
            return response()->json([
                'status' => 'error',
                'message' => 'Kuota bimbingan untuk slot ini pada tanggal tersebut sudah penuh. Silakan pilih tanggal atau slot lain.'
            ], 422);
        }
 
        // 3. Validasi Anti Bentrok Jadwal Mahasiswa
        $existing = JadwalBimbingan::where('tanggal', $validated['tanggal'])
            ->where('slot_bimbingan_id', $validated['slot_bimbingan_id'])
            ->whereIn('status', ['scheduled', 'approved'])
            ->whereHas('pembimbing.pengajuanJudul', function ($q) use ($mahasiswa) {
                $q->where('mahasiswa_id', $mahasiswa->id);
            })
            ->first();
 
        if ($existing) {
            return response()->json([
                'status' => 'error',
                'message' => 'Anda sudah memiliki pengajuan bimbingan aktif pada tanggal dan slot waktu ini.'
            ], 422);
        }
 
        $jadwal = JadwalBimbingan::create([
            'pembimbing_id' => $validated['pembimbing_id'],
            'slot_bimbingan_id' => $validated['slot_bimbingan_id'],
            'tanggal' => $validated['tanggal'],
            'status' => 'scheduled',
        ]);
 
        return response()->json([
            'status' => 'success',
            'message' => 'Jadwal bimbingan berhasil diajukan.',
            'data' => $jadwal->load(['pembimbing.dosen.user', 'slotBimbingan'])
        ], 201);
    }
 
    /**
     * Batalkan jadwal bimbingan oleh Mahasiswa.
     */
    public function cancel(Request $request, $id)
    {
        $mahasiswa = $request->user()->mahasiswa;
        if (!$mahasiswa) {
            return response()->json([
                'status' => 'error',
                'message' => 'Data mahasiswa tidak ditemukan.'
            ], 404);
        }
 
        $jadwal = JadwalBimbingan::findOrFail($id);
 
        // Verifikasi kepemilikan jadwal
        if ($jadwal->pembimbing->pengajuanJudul->mahasiswa_id !== $mahasiswa->id) {
            return response()->json([
                'status' => 'error',
                'message' => 'Anda tidak berwenang membatalkan bimbingan ini.'
            ], 403);
        }
 
        if ($jadwal->status !== 'scheduled') {
            return response()->json([
                'status' => 'error',
                'message' => 'Hanya jadwal bimbingan berstatus menunggu (scheduled) yang dapat dibatalkan.'
            ], 422);
        }
 
        $jadwal->update(['status' => 'cancelled']);
 
        return response()->json([
            'status' => 'success',
            'message' => 'Jadwal bimbingan berhasil dibatalkan.',
            'data' => $jadwal
        ]);
    }
 
    /**
     * Tampilkan jadwal bimbingan yang masuk ke Dosen yang login.
     */
    public function dosenJadwal(Request $request)
    {
        $dosen = $request->user()->dosen;
        if (!$dosen) {
            return response()->json([
                'status' => 'error',
                'message' => 'Data dosen tidak ditemukan.'
            ], 404);
        }
 
        $list = JadwalBimbingan::with(['pembimbing.pengajuanJudul.mahasiswa.user', 'slotBimbingan'])
            ->whereHas('pembimbing', function ($q) use ($dosen) {
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
     * Setujui jadwal bimbingan oleh Dosen.
     */
    public function approve(Request $request, $id)
    {
        $dosen = $request->user()->dosen;
        if (!$dosen) {
            return response()->json([
                'status' => 'error',
                'message' => 'Data dosen tidak ditemukan.'
            ], 404);
        }
 
        $jadwal = JadwalBimbingan::findOrFail($id);
 
        // Verifikasi kepemilikan dosen
        if ($jadwal->pembimbing->dosen_id !== $dosen->id) {
            return response()->json([
                'status' => 'error',
                'message' => 'Anda tidak berwenang menyetujui jadwal ini.'
            ], 403);
        }
 
        if ($jadwal->status !== 'scheduled') {
            return response()->json([
                'status' => 'error',
                'message' => 'Jadwal bimbingan ini tidak dalam status menunggu (scheduled).'
            ], 422);
        }
 
        $jadwal->update(['status' => 'approved']);
 
        return response()->json([
            'status' => 'success',
            'message' => 'Jadwal bimbingan berhasil disetujui.',
            'data' => $jadwal
        ]);
    }
 
    /**
     * Tolak jadwal bimbingan oleh Dosen.
     */
    public function reject(Request $request, $id)
    {
        $dosen = $request->user()->dosen;
        if (!$dosen) {
            return response()->json([
                'status' => 'error',
                'message' => 'Data dosen tidak ditemukan.'
            ], 404);
        }
 
        $jadwal = JadwalBimbingan::findOrFail($id);
 
        // Verifikasi kepemilikan dosen
        if ($jadwal->pembimbing->dosen_id !== $dosen->id) {
            return response()->json([
                'status' => 'error',
                'message' => 'Anda tidak berwenang menolak jadwal ini.'
            ], 403);
        }
 
        if ($jadwal->status !== 'scheduled') {
            return response()->json([
                'status' => 'error',
                'message' => 'Jadwal bimbingan ini tidak dalam status menunggu (scheduled).'
            ], 422);
        }
 
        $jadwal->update(['status' => 'rejected']);
 
        return response()->json([
            'status' => 'success',
            'message' => 'Jadwal bimbingan berhasil ditolak.',
            'data' => $jadwal
        ]);
    }
}
