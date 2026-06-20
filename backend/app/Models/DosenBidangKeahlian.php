<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class DosenBidangKeahlian extends Model
{
    use HasFactory;

    protected $fillable = ['dosen_id', 'bidang_keahlian_id'];

    public function dosen()
    {
        return $this->belongsTo(Dosen::class, 'dosen_id');
    }

    public function bidangKeahlian()
    {
        return $this->belongsTo(BidangKeahlian::class, 'bidang_keahlian_id');
    }
}
