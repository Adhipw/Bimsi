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
        Schema::create('pusat_bantuans', function (Blueprint $table) {
            $table->id();
            $table->enum('kategori', ['faq', 'dokumen_template'])->default('faq');
            $table->string('judul_pertanyaan_atau_dokumen');
            $table->text('isi_jawaban_atau_url_file');
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('pusat_bantuans');
    }
};
