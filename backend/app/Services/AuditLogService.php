<?php

namespace App\Services;

use App\Models\AuditLog;
use Illuminate\Support\Facades\Auth;

class AuditLogService
{
    public static function log($action, $entity, $entityId, $oldData = null, $newData = null)
    {
        $userId = Auth::id() ?? 1; // Fallback to 1 (System/Admin) if no user logged in

        AuditLog::create([
            'user_id' => $userId,
            'action' => $action,
            'entity' => $entity,
            'entity_id' => $entityId,
            'old_data' => $oldData ? json_encode($oldData) : null,
            'new_data' => $newData ? json_encode($newData) : null,
        ]);
    }
}
