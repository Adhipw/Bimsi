<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use App\Models\User;
use App\Models\ProgramStudi;
use App\Models\TahunAkademik;
use App\Models\Semester;
use App\Models\Kelas;
use App\Models\Mahasiswa;
use App\Models\Dosen;
use App\Models\BidangKeahlian;
use App\Models\DosenBidangKeahlian;
use App\Models\PeriodeSkripsi;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // 1. Program Studi
        $prodi1 = ProgramStudi::create([
            'kode_prodi' => 'IF',
            'nama_prodi' => 'Informatika',
            'jenjang' => 'S1',
        ]);

        $prodi2 = ProgramStudi::create([
            'kode_prodi' => 'SI',
            'nama_prodi' => 'Sistem Informasi',
            'jenjang' => 'S1',
        ]);

        // 2. Tahun Akademik
        TahunAkademik::create([
            'tahun' => '2025/2026',
            'is_active' => true,
        ]);

        // 3. Semester
        Semester::create([
            'nama' => 'Ganjil',
            'is_active' => true,
        ]);

        // 4. Kelas
        $kelas1 = Kelas::create([
            'nama_kelas' => '12.6A.01',
            'program_studi_id' => $prodi1->id,
        ]);

        $kelas2 = Kelas::create([
            'nama_kelas' => '12.6B.01',
            'program_studi_id' => $prodi2->id,
        ]);

        // 5. Bidang Keahlian
        $bk1 = BidangKeahlian::create(['nama_bidang' => 'Web Development']);
        $bk2 = BidangKeahlian::create(['nama_bidang' => 'Mobile Development']);
        $bk3 = BidangKeahlian::create(['nama_bidang' => 'Artificial Intelligence']);
        $bk4 = BidangKeahlian::create(['nama_bidang' => 'Cyber Security']);

        // 6. Periode Skripsi
        PeriodeSkripsi::create([
            'nama_periode' => 'Periode Ganjil 2025/2026',
            'tanggal_mulai' => '2025-09-01',
            'tanggal_selesai' => '2026-02-28',
            'is_active' => true,
        ]);

        // 7. Users
        // Super Admin
        User::create([
            'name' => 'Demo Super Admin',
            'email' => 'superadmin@bimsi.ac.id',
            'password' => Hash::make('password123'),
            'role' => 'super_admin',
        ]);

        // Admin
        User::create([
            'name' => 'Demo Admin',
            'email' => 'admin@bimsi.ac.id',
            'password' => Hash::make('password123'),
            'role' => 'admin',
        ]);

        // Kaprodi
        User::create([
            'name' => 'Demo Kaprodi',
            'email' => 'kaprodi@bimsi.ac.id',
            'password' => Hash::make('password123'),
            'role' => 'kaprodi',
        ]);

        // Dosen 1 (Pembimbing 1)
        $userDosen1 = User::create([
            'name' => 'Demo Dosen 1',
            'email' => 'dosen@bimsi.ac.id',
            'password' => Hash::make('password123'),
            'role' => 'dosen',
        ]);

        $dosen1 = Dosen::create([
            'user_id' => $userDosen1->id,
            'nidn' => '0412088901',
            'jabatan_fungsional' => 'Lektor',
        ]);

        DosenBidangKeahlian::create(['dosen_id' => $dosen1->id, 'bidang_keahlian_id' => $bk1->id]);
        DosenBidangKeahlian::create(['dosen_id' => $dosen1->id, 'bidang_keahlian_id' => $bk2->id]);

        // Dosen 2 (Pembimbing 2)
        $userDosen2 = User::create([
            'name' => 'Demo Dosen 2',
            'email' => 'dosen2@bimsi.ac.id',
            'password' => Hash::make('password123'),
            'role' => 'dosen',
        ]);

        $dosen2 = Dosen::create([
            'user_id' => $userDosen2->id,
            'nidn' => '0412088902',
            'jabatan_fungsional' => 'Asisten Ahli',
        ]);

        DosenBidangKeahlian::create(['dosen_id' => $dosen2->id, 'bidang_keahlian_id' => $bk3->id]);

        // Mahasiswa
        $userMhs = User::create([
            'name' => 'Demo Mahasiswa',
            'email' => 'mahasiswa@bimsi.ac.id',
            'password' => Hash::make('password123'),
            'role' => 'mahasiswa',
        ]);

        Mahasiswa::create([
            'user_id' => $userMhs->id,
            'nim' => '12210001',
            'program_studi_id' => $prodi1->id,
            'kelas_id' => $kelas1->id,
            'tahun_masuk' => '2022',
        ]);
    }
}
