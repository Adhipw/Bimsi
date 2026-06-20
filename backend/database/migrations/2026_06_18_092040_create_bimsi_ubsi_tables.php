<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('roles', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->timestamps();
        });

        Schema::create('permissions', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->timestamps();
        });

        Schema::create('role_permissions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('role_id')->constrained('roles')->cascadeOnDelete();
            $table->foreignId('permission_id')->constrained('permissions')->cascadeOnDelete();
            $table->timestamps();
        });

        Schema::create('program_studis', function (Blueprint $table) {
            $table->id();
            $table->string('kode_prodi');
            $table->string('nama_prodi');
            $table->string('jenjang');
            $table->timestamps();
        });

        Schema::create('tahun_akademiks', function (Blueprint $table) {
            $table->id();
            $table->string('tahun');
            $table->boolean('is_active')->default(false);
            $table->timestamps();
        });

        Schema::create('semesters', function (Blueprint $table) {
            $table->id();
            $table->string('nama');
            $table->boolean('is_active')->default(false);
            $table->timestamps();
        });

        Schema::create('kelas', function (Blueprint $table) {
            $table->id();
            $table->string('nama_kelas');
            $table->foreignId('program_studi_id')->constrained('program_studis')->cascadeOnDelete();
            $table->timestamps();
        });

        Schema::create('mahasiswas', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            $table->string('nim')->unique();
            $table->foreignId('program_studi_id')->constrained('program_studis')->cascadeOnDelete();
            $table->foreignId('kelas_id')->constrained('kelas')->cascadeOnDelete();
            $table->string('tahun_masuk');
            $table->timestamps();
        });

        Schema::create('dosens', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            $table->string('nidn')->unique();
            $table->string('jabatan_fungsional');
            $table->timestamps();
        });

        Schema::create('bidang_keahlians', function (Blueprint $table) {
            $table->id();
            $table->string('nama_bidang');
            $table->timestamps();
        });

        Schema::create('dosen_bidang_keahlians', function (Blueprint $table) {
            $table->id();
            $table->foreignId('dosen_id')->constrained('dosens')->cascadeOnDelete();
            $table->foreignId('bidang_keahlian_id')->constrained('bidang_keahlians')->cascadeOnDelete();
            $table->timestamps();
        });

        Schema::create('periode_skripsis', function (Blueprint $table) {
            $table->id();
            $table->string('nama_periode');
            $table->date('tanggal_mulai');
            $table->date('tanggal_selesai');
            $table->boolean('is_active')->default(false);
            $table->timestamps();
        });

        Schema::create('pengajuan_juduls', function (Blueprint $table) {
            $table->id();
            $table->foreignId('mahasiswa_id')->constrained('mahasiswas')->cascadeOnDelete();
            $table->foreignId('periode_skripsi_id')->constrained('periode_skripsis')->cascadeOnDelete();
            $table->string('judul');
            $table->text('deskripsi')->nullable();
            $table->string('status')->default('pending');
            $table->timestamps();
        });

        Schema::create('riwayat_pengajuan_juduls', function (Blueprint $table) {
            $table->id();
            $table->foreignId('pengajuan_judul_id')->constrained('pengajuan_juduls')->cascadeOnDelete();
            $table->string('status_sebelumnya');
            $table->string('status_baru');
            $table->text('keterangan')->nullable();
            $table->timestamps();
        });

        Schema::create('pembimbings', function (Blueprint $table) {
            $table->id();
            $table->foreignId('pengajuan_judul_id')->constrained('pengajuan_juduls')->cascadeOnDelete();
            $table->foreignId('dosen_id')->constrained('dosens')->cascadeOnDelete();
            $table->string('peran');
            $table->string('status')->default('aktif');
            $table->timestamps();
        });

        Schema::create('perubahan_juduls', function (Blueprint $table) {
            $table->id();
            $table->foreignId('pengajuan_judul_id')->constrained('pengajuan_juduls')->cascadeOnDelete();
            $table->string('judul_lama');
            $table->string('judul_baru');
            $table->text('alasan');
            $table->string('status')->default('pending');
            $table->timestamps();
        });

        Schema::create('pergantian_pembimbings', function (Blueprint $table) {
            $table->id();
            $table->foreignId('pengajuan_judul_id')->constrained('pengajuan_juduls')->cascadeOnDelete();
            $table->foreignId('dosen_lama_id')->constrained('dosens')->cascadeOnDelete();
            $table->foreignId('dosen_baru_id')->constrained('dosens')->cascadeOnDelete();
            $table->text('alasan');
            $table->string('status')->default('pending');
            $table->timestamps();
        });

        Schema::create('slot_bimbingans', function (Blueprint $table) {
            $table->id();
            $table->foreignId('dosen_id')->constrained('dosens')->cascadeOnDelete();
            $table->string('hari');
            $table->time('jam_mulai');
            $table->time('jam_selesai');
            $table->integer('kuota');
            $table->timestamps();
        });

        Schema::create('jadwal_bimbingans', function (Blueprint $table) {
            $table->id();
            $table->foreignId('pembimbing_id')->constrained('pembimbings')->cascadeOnDelete();
            $table->foreignId('slot_bimbingan_id')->constrained('slot_bimbingans')->cascadeOnDelete();
            $table->date('tanggal');
            $table->string('status')->default('scheduled');
            $table->timestamps();
        });

        Schema::create('riwayat_bimbingans', function (Blueprint $table) {
            $table->id();
            $table->foreignId('jadwal_bimbingan_id')->constrained('jadwal_bimbingans')->cascadeOnDelete();
            $table->text('catatan_mahasiswa')->nullable();
            $table->text('catatan_dosen')->nullable();
            $table->string('status')->default('selesai');
            $table->timestamps();
        });

        Schema::create('dokumen_skripsis', function (Blueprint $table) {
            $table->id();
            $table->foreignId('pengajuan_judul_id')->constrained('pengajuan_juduls')->cascadeOnDelete();
            $table->string('jenis_dokumen');
            $table->string('file_url');
            $table->timestamps();
        });

        Schema::create('versi_dokumens', function (Blueprint $table) {
            $table->id();
            $table->foreignId('dokumen_skripsi_id')->constrained('dokumen_skripsis')->cascadeOnDelete();
            $table->integer('versi');
            $table->string('file_url');
            $table->text('catatan_revisi')->nullable();
            $table->timestamps();
        });

        Schema::create('review_dokumens', function (Blueprint $table) {
            $table->id();
            $table->foreignId('versi_dokumen_id')->constrained('versi_dokumens')->cascadeOnDelete();
            $table->foreignId('dosen_id')->constrained('dosens')->cascadeOnDelete();
            $table->text('komentar');
            $table->string('status');
            $table->timestamps();
        });

        Schema::create('progress_skripsis', function (Blueprint $table) {
            $table->id();
            $table->foreignId('pengajuan_judul_id')->constrained('pengajuan_juduls')->cascadeOnDelete();
            $table->integer('persentase');
            $table->text('keterangan');
            $table->timestamps();
        });

        Schema::create('notifikasis', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            $table->string('judul');
            $table->text('pesan');
            $table->boolean('is_read')->default(false);
            $table->timestamps();
        });

        Schema::create('fcm_tokens', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            $table->string('token');
            $table->string('device_info')->nullable();
            $table->timestamps();
        });

        Schema::create('audit_logs', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            $table->string('action');
            $table->string('entity');
            $table->unsignedBigInteger('entity_id');
            $table->json('old_data')->nullable();
            $table->json('new_data')->nullable();
            $table->timestamps();
        });

        Schema::create('laporan_exports', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            $table->string('jenis_laporan');
            $table->string('file_url')->nullable();
            $table->string('status')->default('processing');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('laporan_exports');
        Schema::dropIfExists('audit_logs');
        Schema::dropIfExists('fcm_tokens');
        Schema::dropIfExists('notifikasis');
        Schema::dropIfExists('progress_skripsis');
        Schema::dropIfExists('review_dokumens');
        Schema::dropIfExists('versi_dokumens');
        Schema::dropIfExists('dokumen_skripsis');
        Schema::dropIfExists('riwayat_bimbingans');
        Schema::dropIfExists('jadwal_bimbingans');
        Schema::dropIfExists('slot_bimbingans');
        Schema::dropIfExists('pergantian_pembimbings');
        Schema::dropIfExists('perubahan_juduls');
        Schema::dropIfExists('pembimbings');
        Schema::dropIfExists('riwayat_pengajuan_juduls');
        Schema::dropIfExists('pengajuan_juduls');
        Schema::dropIfExists('periode_skripsis');
        Schema::dropIfExists('dosen_bidang_keahlians');
        Schema::dropIfExists('bidang_keahlians');
        Schema::dropIfExists('dosens');
        Schema::dropIfExists('mahasiswas');
        Schema::dropIfExists('kelas');
        Schema::dropIfExists('semesters');
        Schema::dropIfExists('tahun_akademiks');
        Schema::dropIfExists('program_studis');
        Schema::dropIfExists('role_permissions');
        Schema::dropIfExists('permissions');
        Schema::dropIfExists('roles');
    }
};