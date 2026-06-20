<?php

namespace App\Console\Commands;

use Illuminate\Console\Attributes\Description;
use Illuminate\Console\Attributes\Signature;
use Illuminate\Console\Command;

class SendBimbinganReminder extends Command
{
    protected $signature = 'bimbingan:reminder';
    protected $description = 'Kirim reminder ke dosen jika mahasiswa pasif 14 hari';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $limitDate = now()->subDays(14);
        
        // Logika sederhana: Cari jadwal bimbingan terakhir yang di-approve
        // Jika jadwal terakhir lebih lama dari 14 hari, kirim notif.
        // Di sistem nyata, query ini lebih kompleks (join dengan pengajuan_judul)
        
        $this->info('Reminder bimbingan berjalan...');
    }
}
