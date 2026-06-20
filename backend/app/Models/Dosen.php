<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Dosen extends Model
{
    use HasFactory;

    protected $fillable = ['user_id', 'nidn', 'jabatan_fungsional', 'kuota_bimbingan'];

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function bidangKeahlians()
    {
        return $this->belongsToMany(BidangKeahlian::class, 'dosen_bidang_keahlians', 'dosen_id', 'bidang_keahlian_id');
    }

    public function reviewDokumens()
    {
        return $this->hasMany(ReviewDokumen::class);
    }

    public function pengujiSidangs()
    {
        return $this->hasMany(PengujiSidang::class);
    }

    public function pembimbings()
    {
        return $this->hasMany(Pembimbing::class, 'dosen_id');
    }

    public function slotBimbingans()
    {
        return $this->hasMany(SlotBimbingan::class, 'dosen_id');
    }
}
