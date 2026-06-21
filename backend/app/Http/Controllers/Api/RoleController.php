<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Spatie\Permission\Models\Role;
use Spatie\Permission\Models\Permission;
use App\Models\User;

class RoleController extends Controller
{
    public function getRoles()
    {
        return response()->json(Role::with('permissions')->get());
    }

    public function getPermissions()
    {
        return response()->json(Permission::all());
    }

    public function createRole(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|unique:roles,name',
            'permissions' => 'array'
        ]);

        $role = Role::create(['name' => $validated['name'], 'guard_name' => 'web']);

        if (!empty($validated['permissions'])) {
            $role->syncPermissions($validated['permissions']);
        }

        return response()->json(['message' => 'Role created successfully', 'role' => $role]);
    }

    public function updateRole(Request $request, $id)
    {
        $role = Role::findOrFail($id);

        $validated = $request->validate([
            'name' => 'required|string|unique:roles,name,' . $role->id,
            'permissions' => 'array'
        ]);

        $role->update(['name' => $validated['name']]);

        if (isset($validated['permissions'])) {
            $role->syncPermissions($validated['permissions']);
        }

        return response()->json(['message' => 'Role updated successfully', 'role' => $role]);
    }

    public function deleteRole($id)
    {
        $role = Role::findOrFail($id);
        if (in_array($role->name, ['super_admin', 'admin', 'kaprodi', 'dosen', 'mahasiswa'])) {
            return response()->json(['message' => 'Cannot delete a core system role'], 403);
        }
        $role->delete();

        return response()->json(['message' => 'Role deleted successfully']);
    }

    public function assignRoleToUser(Request $request)
    {
        $validated = $request->validate([
            'user_id' => 'required|exists:users,id',
            'roles' => 'required|array',
            'roles.*' => 'exists:roles,name'
        ]);

        $user = User::findOrFail($validated['user_id']);
        $user->syncRoles($validated['roles']);

        // Sync legacy string role for fallback compatibility
        if (count($validated['roles']) > 0) {
            $user->role = $validated['roles'][0];
            $user->save();
        }

        return response()->json(['message' => 'Roles assigned successfully', 'user' => $user->load('roles')]);
    }
}
