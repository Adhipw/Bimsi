<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Mahasiswa extends Model
{
    use HasFactory;

    protected $fillable = ['user_id', 'nim', 'program_studi_id', 'kelas_id', 'tahun_masuk'];

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function programStudi()
    {
        return $this->belongsTo(ProgramStudi::class, 'program_studi_id');
    }

    public function kelas()
    {
        return $this->belongsTo(Kelas::class, 'kelas_id');
    }

    public function pengajuanJuduls()
    {
        return $this->hasMany(PengajuanJudul::class, 'mahasiswa_id');
    }
}
