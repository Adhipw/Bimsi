<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class RiwayatBimbingan extends Model
{
    use HasFactory;

    protected $fillable = ['jadwal_bimbingan_id', 'catatan_mahasiswa', 'catatan_dosen', 'status'];

    public function jadwalBimbingan()
    {
        return $this->belongsTo(JadwalBimbingan::class, 'jadwal_bimbingan_id');
    }
}
