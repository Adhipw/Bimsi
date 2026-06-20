<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class DokumenSkripsi extends Model
{
    use HasFactory;

    protected $fillable = ['pengajuan_judul_id', 'jenis_dokumen', 'file_url'];

    public function pengajuanJudul()
    {
        return $this->belongsTo(PengajuanJudul::class, 'pengajuan_judul_id');
    }

    public function versiDokumens()
    {
        return $this->hasMany(VersiDokumen::class, 'dokumen_skripsi_id');
    }
}
