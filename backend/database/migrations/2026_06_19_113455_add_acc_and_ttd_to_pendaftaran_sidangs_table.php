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
            $table->boolean('acc_pembimbing')->default(false)->after('status');
            $table->date('tanggal_acc')->nullable()->after('acc_pembimbing');
            $table->string('ttd_digital_hash')->nullable()->unique()->after('tanggal_acc');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('pendaftaran_sidangs', function (Blueprint $table) {
            $table->dropColumn(['acc_pembimbing', 'tanggal_acc', 'ttd_digital_hash']);
        });
    }
};
