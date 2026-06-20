<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PengajuanJudul extends Model
{
    use HasFactory;

    protected $fillable = ['mahasiswa_id', 'periode_skripsi_id', 'judul', 'deskripsi', 'status'];

    public function mahasiswa()
    {
        return $this->belongsTo(Mahasiswa::class, 'mahasiswa_id');
    }

    public function periodeSkripsi()
    {
        return $this->belongsTo(PeriodeSkripsi::class, 'periode_skripsi_id');
    }

    public function riwayatPengajuans()
    {
        return $this->hasMany(RiwayatPengajuanJudul::class, 'pengajuan_judul_id');
    }

    public function pembimbings()
    {
        return $this->hasMany(Pembimbing::class, 'pengajuan_judul_id');
    }

    public function perubahanJuduls()
    {
        return $this->hasMany(PerubahanJudul::class, 'pengajuan_judul_id');
    }

    public function pergantianPembimbings()
    {
        return $this->hasMany(PergantianPembimbing::class, 'pengajuan_judul_id');
    }

    public function dokumenSkripsis()
    {
        return $this->hasMany(DokumenSkripsi::class, 'pengajuan_judul_id');
    }

    public function progressSkripsi()
    {
        return $this->hasOne(ProgressSkripsi::class, 'pengajuan_judul_id');
    }
}
