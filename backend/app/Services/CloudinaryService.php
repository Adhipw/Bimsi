<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Storage;
use Illuminate\Http\UploadedFile;

class CloudinaryService
{
    /**
     * Upload file to Cloudinary. Fallbacks to local storage if Cloudinary is not configured.
     *
     * @param UploadedFile $file
     * @param string $folder
     * @return string File URL
     */
    public function upload(UploadedFile $file, string $folder = 'bimsi_ubsi')
    {
        $cloudName = env('CLOUDINARY_CLOUD_NAME');
        $apiKey = env('CLOUDINARY_API_KEY');
        $apiSecret = env('CLOUDINARY_API_SECRET');

        // Check if Cloudinary is fully configured
        if (!empty($cloudName) && !empty($apiKey) && !empty($apiSecret)) {
            try {
                $timestamp = time();
                
                // Cloudinary signs parameters in alphabetical order
                $paramsToSign = [
                    'folder' => $folder,
                    'timestamp' => $timestamp,
                ];
                ksort($paramsToSign);

                // Build parameter query string
                $signString = '';
                foreach ($paramsToSign as $key => $value) {
                    $signString .= $key . '=' . $value . '&';
                }
                
                // Trim trailing '&' and append API Secret
                $signString = rtrim($signString, '&') . $apiSecret;
                $signature = sha1($signString);

                // Send multipart POST request to Cloudinary upload API
                $response = Http::attach(
                    'file',
                    file_get_contents($file->getRealPath()),
                    $file->getClientOriginalName()
                )->post("https://api.cloudinary.com/v1_1/{$cloudName}/auto/upload", [
                    'api_key' => $apiKey,
                    'timestamp' => $timestamp,
                    'signature' => $signature,
                    'folder' => $folder,
                ]);

                if ($response->successful() && $response->json('secure_url')) {
                    return $response->json('secure_url');
                }
                
                logger()->warning('Cloudinary response failed: ' . $response->body());
            } catch (\Exception $e) {
                // If Cloudinary fails, log error and fall back to local disk
                logger()->error('Cloudinary Upload exception: ' . $e->getMessage());
            }
        }

        // Fallback: Store locally on public disk
        // Stores in storage/app/public/uploads/...
        // Accessible publicly at http://yourdomain/storage/uploads/...
        $path = $file->store('uploads', 'public');
        return asset('storage/' . $path);
    }
}
