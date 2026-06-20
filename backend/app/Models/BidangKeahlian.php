<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class BidangKeahlian extends Model
{
    use HasFactory;

    protected $fillable = ['nama_bidang'];

    public function dosens()
    {
        return $this->belongsToMany(Dosen::class, 'dosen_bidang_keahlians', 'bidang_keahlian_id', 'dosen_id');
    }
}
