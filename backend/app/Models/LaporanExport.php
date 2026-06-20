<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class LaporanExport extends Model
{
    use HasFactory;

    protected $fillable = ['user_id', 'jenis_laporan', 'file_url', 'status'];

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
}
