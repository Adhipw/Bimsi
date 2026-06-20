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

class JudulDiajukanEvent implements ShouldBroadcast
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
            new PrivateChannel('kaprodi.notifications'),
        ];
    }

    public function broadcastAs()
    {
        return 'judul.diajukan';
    }

    public function broadcastWith()
    {
        return [
            'id' => $this->pengajuan->id,
            'judul' => $this->pengajuan->judul,
            'mahasiswa_id' => $this->pengajuan->mahasiswa_id,
            'status' => $this->pengajuan->status,
            'message' => 'Terdapat pengajuan judul skripsi baru.',
        ];
    }
}
