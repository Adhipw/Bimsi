<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Role;
use App\Models\Permission;
use App\Models\RolePermission;

class RoleSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $roles = ['super_admin', 'admin', 'kaprodi', 'dosen', 'mahasiswa'];

        foreach ($roles as $roleName) {
            Role::firstOrCreate(['name' => $roleName]);
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
            Permission::firstOrCreate(['name' => $permName]);
        }

        // Assign all permissions to super_admin
        $superAdmin = Role::where('name', 'super_admin')->first();
        $allPermissions = Permission::all();
        foreach ($allPermissions as $perm) {
            RolePermission::firstOrCreate([
                'role_id' => $superAdmin->id,
                'permission_id' => $perm->id,
            ]);
        }

        // Assign some permissions to admin
        $admin = Role::where('name', 'admin')->first();
        $adminPerms = ['manage_users', 'manage_master_data', 'view_reports'];
        foreach ($adminPerms as $permName) {
            $perm = Permission::where('name', $permName)->first();
            if ($perm) {
                RolePermission::firstOrCreate([
                    'role_id' => $admin->id,
                    'permission_id' => $perm->id,
                ]);
            }
        }

        // Assign permissions to kaprodi
        $kaprodi = Role::where('name', 'kaprodi')->first();
        $kaprodiPerms = ['approve_judul', 'assign_pembimbing', 'view_reports'];
        foreach ($kaprodiPerms as $permName) {
            $perm = Permission::where('name', $permName)->first();
            if ($perm) {
                RolePermission::firstOrCreate([
                    'role_id' => $kaprodi->id,
                    'permission_id' => $perm->id,
                ]);
            }
        }

        // Assign permissions to dosen
        $dosen = Role::where('name', 'dosen')->first();
        $dosenPerms = ['manage_slot_bimbingan', 'approve_jadwal_bimbingan', 'input_riwayat_bimbingan', 'review_dokumen'];
        foreach ($dosenPerms as $permName) {
            $perm = Permission::where('name', $permName)->first();
            if ($perm) {
                RolePermission::firstOrCreate([
                    'role_id' => $dosen->id,
                    'permission_id' => $perm->id,
                ]);
            }
        }

        // Assign permissions to mahasiswa
        $mahasiswa = Role::where('name', 'mahasiswa')->first();
        $mahasiswaPerms = ['upload_dokumen'];
        foreach ($mahasiswaPerms as $permName) {
            $perm = Permission::where('name', $permName)->first();
            if ($perm) {
                RolePermission::firstOrCreate([
                    'role_id' => $mahasiswa->id,
                    'permission_id' => $perm->id,
                ]);
            }
        }
    }
}
