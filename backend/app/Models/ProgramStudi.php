<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ProgramStudi extends Model
{
    use HasFactory;

    protected $fillable = ['kode_prodi', 'nama_prodi', 'jenjang'];

    public function kelas()
    {
        return $this->hasMany(Kelas::class, 'program_studi_id');
    }

    public function mahasiswas()
    {
        return $this->hasMany(Mahasiswa::class, 'program_studi_id');
    }
}
