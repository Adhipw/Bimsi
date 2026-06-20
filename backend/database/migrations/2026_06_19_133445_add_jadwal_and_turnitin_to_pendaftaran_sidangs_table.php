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
        Schema::table('pendaftaran_sidangs', function (Blueprint $table) {
            // Jadwal Sidang
            $table->date('tanggal_sidang')->nullable()->after('ttd_digital_hash');
            $table->time('waktu_mulai')->nullable()->after('tanggal_sidang');
            $table->time('waktu_selesai')->nullable()->after('waktu_mulai');
            $table->foreignId('ruangan_id')->nullable()->constrained('ruangans')->nullOnDelete()->after('waktu_selesai');

            // Turnitin
            $table->integer('turnitin_score')->nullable()->after('ruangan_id');
            $table->enum('turnitin_status', ['pending', 'approved', 'rejected'])->default('pending')->after('turnitin_score');
            $table->string('turnitin_file_url')->nullable()->after('turnitin_status');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('pendaftaran_sidangs', function (Blueprint $table) {
            $table->dropForeign(['ruangan_id']);
            $table->dropColumn([
                'tanggal_sidang', 'waktu_mulai', 'waktu_selesai', 'ruangan_id',
                'turnitin_score', 'turnitin_status', 'turnitin_file_url'
            ]);
        });
    }
};
