<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Storage;
use Symfony\Component\HttpFoundation\StreamedResponse;

class BackupController extends Controller
{
    public function index()
    {
        $disk = Storage::disk(config('backup.backup.destination.disks')[0] ?? 'local');
        $files = $disk->files(config('backup.backup.name'));
        
        $backups = array_map(function ($file) use ($disk) {
            return [
                'name' => basename($file),
                'size' => $disk->size($file),
                'last_modified' => $disk->lastModified($file),
            ];
        }, $files);

        // Sort backups by last modified descending
        usort($backups, function ($a, $b) {
            return $b['last_modified'] - $a['last_modified'];
        });

        return response()->json($backups);
    }

    public function runBackup(Request $request)
    {
        try {
            $type = $request->input('type', 'db'); // 'db' or 'full'

            if ($type === 'full') {
                Artisan::call('backup:run');
            } else {
                Artisan::call('backup:run', ['--only-db' => true]);
            }

            return response()->json([
                'message' => 'Backup executed successfully.',
                'output' => Artisan::output()
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Backup failed: ' . $e->getMessage()
            ], 500);
        }
    }

    public function download($fileName)
    {
        $disk = Storage::disk(config('backup.backup.destination.disks')[0] ?? 'local');
        $path = config('backup.backup.name') . '/' . $fileName;

        if (! $disk->exists($path)) {
            return response()->json(['message' => 'Backup file not found.'], 404);
        }

        return $disk->download($path);
    }
}
