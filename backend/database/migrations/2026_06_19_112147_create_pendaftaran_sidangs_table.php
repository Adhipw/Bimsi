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
        Schema::create('pendaftaran_sidangs', function (Blueprint $table) {
            $table->id();
            $table->foreignId('mahasiswa_id')->constrained('mahasiswas')->cascadeOnDelete();
            $table->foreignId('pengajuan_judul_id')->constrained('pengajuan_juduls')->cascadeOnDelete();
            $table->enum('jenis_sidang', ['sempro', 'akhir']);
            $table->enum('status', ['pending', 'approved', 'rejected'])->default('pending');
            $table->string('file_syarat_url')->nullable();
            $table->text('keterangan')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('pendaftaran_sidangs');
    }
};
