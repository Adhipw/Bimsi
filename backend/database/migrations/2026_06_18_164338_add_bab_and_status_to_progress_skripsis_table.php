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
        Schema::table('progress_skripsis', function (Blueprint $table) {
            $table->string('bab')->after('pengajuan_judul_id');
            $table->string('status')->after('bab')->default('pending');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('progress_skripsis', function (Blueprint $table) {
            $table->dropColumn(['bab', 'status']);
        });
    }
};
