<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class VersiDokumen extends Model
{
    use HasFactory;

    protected $fillable = ['dokumen_skripsi_id', 'versi', 'file_url', 'catatan_revisi'];

    public function dokumenSkripsi()
    {
        return $this->belongsTo(DokumenSkripsi::class, 'dokumen_skripsi_id');
    }

    public function reviewDokumens()
    {
        return $this->hasMany(ReviewDokumen::class, 'versi_dokumen_id');
    }
}
