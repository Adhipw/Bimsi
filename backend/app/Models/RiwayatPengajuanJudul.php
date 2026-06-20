<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class RiwayatPengajuanJudul extends Model
{
    use HasFactory;

    protected $fillable = ['pengajuan_judul_id', 'status_sebelumnya', 'status_baru', 'keterangan'];

    public function pengajuanJudul()
    {
        return $this->belongsTo(PengajuanJudul::class, 'pengajuan_judul_id');
    }
}
