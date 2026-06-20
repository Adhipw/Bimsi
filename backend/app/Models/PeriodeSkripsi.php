<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PeriodeSkripsi extends Model
{
    use HasFactory;

    protected $fillable = ['nama_periode', 'tanggal_mulai', 'tanggal_selesai', 'is_active'];

    protected $casts = [
        'tanggal_mulai' => 'date',
        'tanggal_selesai' => 'date',
        'is_active' => 'boolean',
    ];

    public function pengajuanJuduls()
    {
        return $this->hasMany(PengajuanJudul::class, 'periode_skripsi_id');
    }
}
