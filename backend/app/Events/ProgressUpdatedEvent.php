<?php

namespace App\Events;

use App\Models\ProgressSkripsi;
use App\Models\PengajuanJudul;
use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class ProgressUpdatedEvent implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public $progress;
    public $pengajuan;

    public function __construct(ProgressSkripsi $progress, PengajuanJudul $pengajuan)
    {
        $this->progress = $progress;
        $this->pengajuan = $pengajuan;
    }

    public function broadcastOn()
    {
        return [
            new PrivateChannel('mahasiswa.' . $this->pengajuan->mahasiswa_id),
        ];
    }

    public function broadcastAs()
    {
        return 'progress.updated';
    }

    public function broadcastWith()
    {
        return [
            'pengajuan_judul_id' => $this->pengajuan->id,
            'bab' => $this->progress->bab,
            'status' => $this->progress->status,
            'persentase' => $this->progress->persentase,
            'message' => 'Progress ' . $this->progress->bab . ' Anda telah diupdate menjadi ' . $this->progress->status,
        ];
    }
}
