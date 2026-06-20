<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ReviewDokumen extends Model
{
    use HasFactory;

    protected $fillable = ['versi_dokumen_id', 'dosen_id', 'komentar', 'status'];

    public function versiDokumen()
    {
        return $this->belongsTo(VersiDokumen::class, 'versi_dokumen_id');
    }

    public function dosen()
    {
        return $this->belongsTo(Dosen::class, 'dosen_id');
    }
}
