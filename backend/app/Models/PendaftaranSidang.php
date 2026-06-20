<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PendaftaranSidang extends Model
{
    protected $guarded = [];

    public function mahasiswa()
    {
        return $this->belongsTo(Mahasiswa::class);
    }

    public function pengajuanJudul()
    {
        return $this->belongsTo(PengajuanJudul::class);
    }

    public function pengujis()
    {
        return $this->hasMany(PengujiSidang::class);
    }

    public function ruangan()
    {
        return $this->belongsTo(Ruangan::class);
    }
}
