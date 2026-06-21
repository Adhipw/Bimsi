<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

use Cloudinary\Cloudinary;
use Illuminate\Support\Facades\Log;

class ProfileController extends Controller
{
    public function uploadAvatar(Request $request)
    {
        $request->validate([
            'avatar' => 'required|image|mimes:jpeg,png,jpg,webp|max:5120',
        ]);

        try {
            $cloudinary = new Cloudinary([
                'cloud' => [
                    'cloud_name' => env('CLOUDINARY_CLOUD_NAME'),
                    'api_key'    => env('CLOUDINARY_API_KEY'),
                    'api_secret' => env('CLOUDINARY_API_SECRET'),
                ],
            ]);

            $uploadApi = $cloudinary->uploadApi();
            $result = $uploadApi->upload($request->file('avatar')->getRealPath(), [
                'folder' => 'bimsi_ubsi/avatars'
            ]);

            $user = $request->user();
            $user->avatar_url = $result['secure_url'];
            $user->save();

            return response()->json([
                'message' => 'Avatar berhasil diupload',
                'avatar_url' => $user->avatar_url
            ]);

        } catch (\Exception $e) {
            Log::error('Gagal upload avatar ke Cloudinary: ' . $e->getMessage());
            return response()->json([
                'message' => 'Gagal mengupload avatar',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}