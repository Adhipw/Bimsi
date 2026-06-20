<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PergantianPembimbing extends Model
{
    use HasFactory;

    protected $fillable = ['pengajuan_judul_id', 'dosen_lama_id', 'dosen_baru_id', 'alasan', 'status'];

    public function pengajuanJudul()
    {
        return $this->belongsTo(PengajuanJudul::class, 'pengajuan_judul_id');
    }

    public function dosenLama()
    {
        return $this->belongsTo(Dosen::class, 'dosen_lama_id');
    }

    public function dosenBaru()
    {
        return $this->belongsTo(Dosen::class, 'dosen_baru_id');
    }
}
