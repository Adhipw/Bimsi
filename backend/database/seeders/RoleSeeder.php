<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Role;
use Spatie\Permission\Models\Permission;
use Illuminate\Support\Facades\DB;

class RoleSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $roles = ['super_admin', 'admin', 'kaprodi', 'dosen', 'mahasiswa'];

        foreach ($roles as $roleName) {
            Role::firstOrCreate(['name' => $roleName, 'guard_name' => 'web']);
        }

        $permissions = [
            'manage_users',
            'manage_master_data',
            'approve_judul',
            'assign_pembimbing',
            'manage_slot_bimbingan',
            'approve_jadwal_bimbingan',
            'input_riwayat_bimbingan',
            'upload_dokumen',
            'review_dokumen',
            'view_reports',
            'view_audit_logs',
        ];

        foreach ($permissions as $permName) {
            Permission::firstOrCreate(['name' => $permName, 'guard_name' => 'web']);
        }

        // Assign all permissions to super_admin
        $superAdmin = Role::where('name', 'super_admin')->first();
        $superAdmin->syncPermissions(Permission::all());

        // Assign some permissions to admin
        $admin = Role::where('name', 'admin')->first();
        $admin->syncPermissions(['manage_users', 'manage_master_data', 'view_reports']);

        // Assign permissions to kaprodi
        $kaprodi = Role::where('name', 'kaprodi')->first();
        $kaprodi->syncPermissions(['approve_judul', 'assign_pembimbing', 'view_reports']);

        // Assign permissions to dosen
        $dosen = Role::where('name', 'dosen')->first();
        $dosen->syncPermissions(['manage_slot_bimbingan', 'approve_jadwal_bimbingan', 'input_riwayat_bimbingan', 'review_dokumen']);

        // Assign permissions to mahasiswa
        $mahasiswa = Role::where('name', 'mahasiswa')->first();
        $mahasiswa->syncPermissions(['upload_dokumen']);
    }
}
