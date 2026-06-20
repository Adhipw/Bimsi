<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class JadwalBimbingan extends Model
{
    use HasFactory;

    protected $fillable = ['pembimbing_id', 'slot_bimbingan_id', 'tanggal', 'status'];

    protected $casts = [
        'tanggal' => 'date',
    ];

    public function pembimbing()
    {
        return $this->belongsTo(Pembimbing::class, 'pembimbing_id');
    }

    public function slotBimbingan()
    {
        return $this->belongsTo(SlotBimbingan::class, 'slot_bimbingan_id');
    }

    public function riwayatBimbingans()
    {
        return $this->hasMany(RiwayatBimbingan::class, 'jadwal_bimbingan_id');
    }
}
