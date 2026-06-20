<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PengujiSidang extends Model
{
    protected $guarded = [];

    public function pendaftaranSidang()
    {
        return $this->belongsTo(PendaftaranSidang::class);
    }

    public function dosen()
    {
        return $this->belongsTo(Dosen::class);
    }
}
