<?php

namespace App\Events;

use App\Models\PengajuanJudul;
use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class StatusJudulUpdatedEvent implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public $pengajuan;

    public function __construct(PengajuanJudul $pengajuan)
    {
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
        return 'status.judul.updated';
    }

    public function broadcastWith()
    {
        return [
            'id' => $this->pengajuan->id,
            'judul' => $this->pengajuan->judul,
            'status' => $this->pengajuan->status,
            'message' => 'Status usulan judul Anda telah diperbarui menjadi ' . strtoupper($this->pengajuan->status),
        ];
    }
}
