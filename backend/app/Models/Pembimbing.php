<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Pembimbing extends Model
{
    use HasFactory;

    protected $fillable = ['pengajuan_judul_id', 'dosen_id', 'peran', 'status'];

    public function pengajuanJudul()
    {
        return $this->belongsTo(PengajuanJudul::class, 'pengajuan_judul_id');
    }

    public function dosen()
    {
        return $this->belongsTo(Dosen::class, 'dosen_id');
    }

    public function jadwalBimbingans()
    {
        return $this->hasMany(JadwalBimbingan::class, 'pembimbing_id');
    }
}
