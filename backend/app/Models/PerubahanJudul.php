<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PerubahanJudul extends Model
{
    use HasFactory;

    protected $fillable = ['pengajuan_judul_id', 'judul_lama', 'judul_baru', 'alasan', 'status'];

    public function pengajuanJudul()
    {
        return $this->belongsTo(PengajuanJudul::class, 'pengajuan_judul_id');
    }
}
