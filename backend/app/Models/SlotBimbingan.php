<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SlotBimbingan extends Model
{
    use HasFactory;

    protected $fillable = ['dosen_id', 'hari', 'jam_mulai', 'jam_selesai', 'kuota'];

    public function dosen()
    {
        return $this->belongsTo(Dosen::class, 'dosen_id');
    }

    public function jadwalBimbingans()
    {
        return $this->hasMany(JadwalBimbingan::class, 'slot_bimbingan_id');
    }
}
