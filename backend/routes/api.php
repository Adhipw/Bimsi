<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\Api\ProgramStudiController;
use App\Http\Controllers\Api\TahunAkademikController;
use App\Http\Controllers\Api\SemesterController;
use App\Http\Controllers\Api\KelasController;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\DosenController;
use App\Http\Controllers\Api\MahasiswaController;
use App\Http\Controllers\Api\PengajuanJudulController;
use App\Http\Controllers\Api\KaprodiPengajuanJudulController;
use App\Http\Controllers\Api\KaprodiPembimbingController;
use App\Http\Controllers\Api\PembimbingController;
use App\Http\Controllers\Api\SlotBimbinganController;
use App\Http\Controllers\Api\JadwalBimbinganController;
use App\Http\Controllers\Api\RiwayatBimbinganController;
use App\Http\Controllers\Api\UploadController;
use App\Http\Controllers\Api\ProgressSkripsiController;
use App\Http\Controllers\Api\FcmTokenController;
use App\Http\Controllers\PendaftaranSidangController;
use App\Http\Controllers\LogbookBimbinganController;
use App\Http\Controllers\PesanChatController;
use App\Http\Controllers\ReferensiMahasiswaController;
use App\Http\Controllers\PusatBantuanController;
use App\Http\Controllers\CatatanPrivatDosenController;

Route::post('/login', [AuthController::class, 'login']);
Route::post('/verify-otp', [AuthController::class, 'verifyOtp']);

Route::get('/public/pusat-bantuan', [PusatBantuanController::class, 'indexPublic']);
Route::get('/public/verifikasi-ttd/{hash}', [PendaftaranSidangController::class, 'verifyTtd']);
Route::get('/public/repository', [\App\Http\Controllers\Api\RepositoryController::class, 'indexPublic']);
Route::get('/public/repository/{id}', [\App\Http\Controllers\Api\RepositoryController::class, 'showPublic']);
Route::get('/kaprodi/laporan/mahasiswa-skripsi/download', [\App\Http\Controllers\Api\LaporanController::class, 'download']);
Route::get('/admin/sidang/{id}/generate-sk-pembimbing', [\App\Http\Controllers\Api\AdminAkademikController::class, 'generateSk']);
Route::get('/admin/sidang/{id}/generate-berita-acara', [\App\Http\Controllers\Api\AdminAkademikController::class, 'generateBeritaAcara']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/profile', [AuthController::class, 'profile']);
    Route::post('/profile/avatar', [\App\Http\Controllers\Api\ProfileController::class, 'uploadAvatar']);
    Route::post('/fcm-token', [FcmTokenController::class, 'updateToken']);

    // Chat
    Route::get('/chat/{pengajuan_judul_id}', [PesanChatController::class, 'getMessages']);
    Route::post('/chat/send', [PesanChatController::class, 'sendMessage']);
    Route::put('/chat/{id}/read', [PesanChatController::class, 'markAsRead']);

    // Rute Pengajuan, Pembimbing, Jadwal, & Dokumen Mahasiswa
    // PENTING: Group ini harus sebelum apiResource('mahasiswa') agar route /mahasiswa/dokumen
    // tidak ditangkap oleh /mahasiswa/{mahasiswa} dari apiResource.
    Route::middleware('role:mahasiswa')->group(function () {
        Route::get('/mahasiswa/pengajuan-judul/status', [PengajuanJudulController::class, 'status']);
        Route::post('/mahasiswa/pengajuan-judul', [PengajuanJudulController::class, 'store']);
        Route::put('/mahasiswa/pengajuan-judul/{id}', [PengajuanJudulController::class, 'update']);
        Route::get('/mahasiswa/pembimbing', [PembimbingController::class, 'mahasiswaPembimbing']);

        // Jadwal Bimbingan Mahasiswa
        Route::get('/mahasiswa/jadwal', [JadwalBimbinganController::class, 'mahasiswaJadwal']);
        Route::get('/mahasiswa/pembimbing/{pembimbingId}/slots', [JadwalBimbinganController::class, 'pembimbingSlots']);
        Route::post('/mahasiswa/jadwal', [JadwalBimbinganController::class, 'ajukan']);
        Route::post('/mahasiswa/jadwal/{id}/cancel', [JadwalBimbinganController::class, 'cancel']);

        // Riwayat Bimbingan Mahasiswa
        Route::get('/mahasiswa/riwayat-bimbingan', [RiwayatBimbinganController::class, 'mahasiswaIndex']);

        // Upload Dokumen Mahasiswa
        Route::get('/mahasiswa/dokumen', [UploadController::class, 'mahasiswaIndex']);
        Route::post('/mahasiswa/dokumen', [UploadController::class, 'store']);

        // Progress Skripsi Mahasiswa
        Route::get('/mahasiswa/progress', [ProgressSkripsiController::class, 'mahasiswaIndex']);

        // Pendaftaran Sidang
        Route::get('/mahasiswa/pendaftaran-sidang/status', [PendaftaranSidangController::class, 'index']);
        Route::post('/mahasiswa/pendaftaran-sidang', [PendaftaranSidangController::class, 'store']);
        Route::post('/mahasiswa/pendaftaran-sidang/{id}/turnitin', [PendaftaranSidangController::class, 'uploadTurnitin']);
        
        // Logbook Bimbingan
        Route::get('/mahasiswa/logbook', [LogbookBimbinganController::class, 'index']);
        Route::post('/mahasiswa/logbook', [LogbookBimbinganController::class, 'store']);

        // Referensi Mahasiswa
        Route::get('/mahasiswa/referensi', [ReferensiMahasiswaController::class, 'index']);
        Route::post('/mahasiswa/referensi', [ReferensiMahasiswaController::class, 'store']);
        Route::delete('/mahasiswa/referensi/{id}', [ReferensiMahasiswaController::class, 'destroy']);
    });

    // Rute CRUD Master Data (hanya untuk Super Admin dan Admin)
    Route::middleware('role:super_admin,admin')->group(function () {
        Route::apiResource('program-studi', ProgramStudiController::class);
        Route::apiResource('tahun-akademik', TahunAkademikController::class);
        Route::apiResource('semester', SemesterController::class);
        Route::apiResource('kelas', KelasController::class);
        Route::apiResource('user', UserController::class);
        Route::apiResource('dosen', DosenController::class);
        Route::apiResource('mahasiswa', MahasiswaController::class);
        Route::apiResource('pusat-bantuan', PusatBantuanController::class);

        // Admin Akademik - Jadwal & PDF
        Route::get('/admin/sidang/ruangans', [\App\Http\Controllers\Api\AdminAkademikController::class, 'getRuangans']);
        Route::get('/admin/sidang/menunggu-jadwal', [\App\Http\Controllers\Api\AdminAkademikController::class, 'menungguJadwal']);
        Route::post('/admin/sidang/{id}/plot-jadwal', [\App\Http\Controllers\Api\AdminAkademikController::class, 'plotJadwal']);

        // Admin Akademik - Turnitin
        Route::get('/admin/turnitin/menunggu', [\App\Http\Controllers\Api\AdminTurnitinController::class, 'menungguVerifikasi']);
        Route::post('/admin/turnitin/{id}/verifikasi', [\App\Http\Controllers\Api\AdminTurnitinController::class, 'verifikasi']);

        // Repository
        Route::post('/admin/repository/publish', [\App\Http\Controllers\Api\RepositoryController::class, 'publish']);
    });

    // Rute Validasi Judul & Pembimbing Kaprodi
    Route::middleware('role:kaprodi')->group(function () {
        Route::get('/kaprodi/pengajuan-judul', [KaprodiPengajuanJudulController::class, 'index']);
        Route::get('/kaprodi/pengajuan-judul/cek-kemiripan', [KaprodiPengajuanJudulController::class, 'cekKemiripan']);
        Route::get('/kaprodi/pengajuan-judul/{id}', [KaprodiPengajuanJudulController::class, 'show']);
        Route::post('/kaprodi/pengajuan-judul/{id}/approve', [KaprodiPengajuanJudulController::class, 'approve']);
        Route::post('/kaprodi/pengajuan-judul/{id}/reject', [KaprodiPengajuanJudulController::class, 'reject']);

        // Pembimbing Kaprodi
        Route::get('/kaprodi/pembimbing/mahasiswa-disetujui', [KaprodiPembimbingController::class, 'mahasiswaDisetujui']);
        Route::get('/kaprodi/pembimbing/dosen-list', [KaprodiPembimbingController::class, 'dosenList']);
        Route::post('/kaprodi/pembimbing/assign', [KaprodiPembimbingController::class, 'assign']);

        // Progress Skripsi Kaprodi
        Route::get('/kaprodi/progress-mahasiswa', [ProgressSkripsiController::class, 'kaprodiIndex']);
        
        // B16: Laporan
        Route::get('/kaprodi/laporan/mahasiswa-skripsi', [\App\Http\Controllers\Api\LaporanController::class, 'mahasiswaSkripsi']);

        // Dashboard Analytics
        Route::get('/kaprodi/dashboard-analytics', [\App\Http\Controllers\Api\KaprodiDashboardController::class, 'analytics']);

        // Penguji
        Route::get('/kaprodi/penguji/sidang', [\App\Http\Controllers\Api\KaprodiPengujiController::class, 'listSidang']);
        Route::post('/kaprodi/penguji/sidang/{id}/assign', [\App\Http\Controllers\Api\KaprodiPengujiController::class, 'assign']);
    });

    Route::middleware('role:super_admin')->group(function () {
        Route::get('/super-admin/audit-logs', [\App\Http\Controllers\Api\AuditLogController::class, 'index']);
        
        // Settings
        Route::get('/settings', [\App\Http\Controllers\Api\SettingController::class, 'index']);
        Route::put('/settings', [\App\Http\Controllers\Api\SettingController::class, 'update']);
        
        // RBAC (Roles & Permissions)
        Route::get('/roles', [\App\Http\Controllers\Api\RoleController::class, 'getRoles']);
        Route::post('/roles', [\App\Http\Controllers\Api\RoleController::class, 'createRole']);
        Route::put('/roles/{id}', [\App\Http\Controllers\Api\RoleController::class, 'updateRole']);
        Route::delete('/roles/{id}', [\App\Http\Controllers\Api\RoleController::class, 'deleteRole']);
        Route::get('/permissions', [\App\Http\Controllers\Api\RoleController::class, 'getPermissions']);
        Route::post('/roles/assign', [\App\Http\Controllers\Api\RoleController::class, 'assignRoleToUser']);
        
        // Backup
        Route::get('/backups', [\App\Http\Controllers\Api\BackupController::class, 'index']);
        Route::post('/backups/run', [\App\Http\Controllers\Api\BackupController::class, 'runBackup']);
        Route::get('/backups/download/{file_name}', [\App\Http\Controllers\Api\BackupController::class, 'download']);
    });

    // Rute Dosen (Slots & Jadwal)
    Route::middleware('role:dosen')->group(function () {
        Route::get('/dosen/mahasiswa-bimbingan', [PembimbingController::class, 'dosenMahasiswaBimbingan']);

        // Slots
        Route::get('/dosen/slots', [SlotBimbinganController::class, 'index']);
        Route::post('/dosen/slots', [SlotBimbinganController::class, 'store']);
        Route::delete('/dosen/slots/{id}', [SlotBimbinganController::class, 'destroy']);

        // Jadwal Bimbingan
        Route::get('/dosen/jadwal', [JadwalBimbinganController::class, 'dosenJadwal']);
        Route::post('/dosen/jadwal/{id}/approve', [JadwalBimbinganController::class, 'approve']);
        Route::post('/dosen/jadwal/{id}/reject', [JadwalBimbinganController::class, 'reject']);

        // Riwayat Bimbingan
        Route::get('/dosen/riwayat-bimbingan', [RiwayatBimbinganController::class, 'dosenIndex']);
        Route::get('/dosen/jadwal-approved', [RiwayatBimbinganController::class, 'approvedJadwalList']);
        Route::post('/dosen/riwayat-bimbingan', [RiwayatBimbinganController::class, 'store']);

        // Review Dokumen Dosen
        Route::get('/dosen/dokumen-bimbingan', [UploadController::class, 'dosenIndex']);
        Route::post('/dosen/dokumen/review', [UploadController::class, 'review']);

        // Logbook Bimbingan Dosen
        Route::put('/dosen/logbook/{id}/approve', [LogbookBimbinganController::class, 'updateApproval']);

        // Catatan Privat Mahasiswa
        Route::get('/dosen/catatan-privat/{mahasiswa_id}', [CatatanPrivatDosenController::class, 'show']);
        Route::post('/dosen/catatan-privat', [CatatanPrivatDosenController::class, 'store']);
        Route::delete('/dosen/catatan-privat/{id}', [CatatanPrivatDosenController::class, 'destroy']);

        // ACC Sidang & TTD Digital
        Route::get('/dosen/pendaftaran-sidang', [PendaftaranSidangController::class, 'indexDosen']);
        Route::post('/dosen/pendaftaran-sidang/{id}/approve', [PendaftaranSidangController::class, 'approveSidang']);

        // Progress Skripsi Dosen
        Route::put('/dosen/progress/{pengajuan_judul_id}', [ProgressSkripsiController::class, 'dosenUpdate']);
    });

    // Contoh rute yang dilindungi RoleMiddleware
    Route::middleware('role:super_admin')->get('/super-admin', function () {
        return response()->json(['message' => 'Ini area Super Admin']);
    });
});
