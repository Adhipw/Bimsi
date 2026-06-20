<?php

namespace App\Services;

use Google\Client as GoogleClient;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class FirebaseNotificationService
{
    protected $projectId;
    protected $credentialsFilePath;

    public function __construct()
    {
        $this->projectId = env('FIREBASE_PROJECT_ID', 'bimsi-ubsi');
        $this->credentialsFilePath = storage_path('app/firebase-credentials.json');
    }

    protected function getAccessToken()
    {
        if (!file_exists($this->credentialsFilePath)) {
            Log::warning('Firebase credentials file not found at ' . $this->credentialsFilePath);
            return null;
        }

        $client = new GoogleClient();
        $client->setAuthConfig($this->credentialsFilePath);
        $client->addScope('https://www.googleapis.com/auth/firebase.messaging');
        $client->useApplicationDefaultCredentials();

        $token = $client->fetchAccessTokenWithAssertion();
        return $token['access_token'] ?? null;
    }

    public function sendPushNotification($fcmToken, $title, $body, $data = [])
    {
        if (!$fcmToken) return false;

        $accessToken = $this->getAccessToken();
        if (!$accessToken) return false;

        $url = 'https://fcm.googleapis.com/v1/projects/' . $this->projectId . '/messages:send';

        $message = [
            'message' => [
                'token' => $fcmToken,
                'notification' => [
                    'title' => $title,
                    'body' => $body,
                ],
                'data' => empty($data) ? (object)[] : $data, // Must be string map if not empty
            ]
        ];

        try {
            $response = Http::withHeaders([
                'Authorization' => 'Bearer ' . $accessToken,
                'Content-Type' => 'application/json',
            ])->post($url, $message);

            if ($response->successful()) {
                Log::info('FCM Notification sent successfully to ' . $fcmToken);
                return true;
            } else {
                Log::error('FCM Notification failed: ' . $response->body());
                return false;
            }
        } catch (\Exception $e) {
            Log::error('FCM Notification exception: ' . $e->getMessage());
            return false;
        }
    }
}
