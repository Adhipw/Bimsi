<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('referensi_mahasiswas', function (Blueprint $table) {
            $table->id();
            $table->foreignId('mahasiswa_id')->constrained('mahasiswas')->cascadeOnDelete();
            $table->foreignId('pengajuan_judul_id')->constrained('pengajuan_juduls')->cascadeOnDelete();
            $table->string('judul_artikel');
            $table->string('penulis')->nullable();
            $table->string('tahun_terbit')->nullable();
            $table->string('url_tautan')->nullable();
            $table->enum('tipe_referensi', ['jurnal', 'buku', 'website'])->default('jurnal');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('referensi_mahasiswas');
    }
};
