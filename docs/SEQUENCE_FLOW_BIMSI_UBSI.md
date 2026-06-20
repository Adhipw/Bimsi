# Sequence Flow - BIMSI UBSI

Dokumen ini merangkum alur spesifik antara Client (Flutter) dan Server (Laravel), serta provider eksternal.

## 1. Sequence Flow Umum (Flutter ke Laravel)

```mermaid
sequenceDiagram
    participant App as Flutter (Client)
    participant Auth as Storage (Secure)
    participant API as Laravel (API)
    participant DB as PostgreSQL

    App->>API: HTTP Request (Headers: Bearer Token)
    API->>API: Middleware (Verify Sanctum Token)
    alt Token Invalid
        API-->>App: 401 Unauthorized
        App->>Auth: Delete Token & Redirect to Login
    else Token Valid
        API->>DB: Query Data
        DB-->>API: Return Results
        API-->>App: 200 OK (JSON Data)
        App->>App: Parse JSON to Model & Update UI
    end
```

## 2. Sequence Flow Realtime (Pusher Channels)

```mermaid
sequenceDiagram
    participant M as Mahasiswa (Flutter)
    participant D as Dosen (Flutter)
    participant API as Laravel API
    participant P as Pusher Server

    M->>API: POST /chat (Send Message)
    API->>DB: Save message to DB
    API->>P: Trigger Event (bimbingan.{id}, new-message)
    API-->>M: 200 OK (Message sent)
    P-->>D: Broadcast 'new-message' payload via WebSocket
    D->>D: Update UI (Add message to list)
```

## 3. Sequence Flow Upload Dokumen (Cloudinary)

```mermaid
sequenceDiagram
    participant App as Flutter
    participant API as Laravel
    participant Cld as Cloudinary
    participant DB as PostgreSQL

    App->>API: POST /dokumen (Multipart: file.pdf)
    Note over API: Validasi size & mime-type
    API->>Cld: Upload stream (via SDK)
    Cld-->>API: Response (Secure URL: https://res.cloudinary.com/...)
    API->>DB: Insert record (file_url)
    DB-->>API: Insert success
    API-->>App: 201 Created (Return file_url & ID)
    App->>App: Tampilkan status sukses & link dokumen
```

## 4. Sequence Flow Push Notification (Firebase)

```mermaid
sequenceDiagram
    participant API as Laravel
    participant FCM as Firebase Cloud Messaging
    participant Device as Flutter (Android)

    Note over API: Event: Dosen memberikan catatan baru
    API->>DB: Get user FCM Token
    API->>FCM: POST payload to FCM API
    FCM-->>API: Notification Accepted (200 OK)
    FCM-->>Device: Send Push Notification (System Tray)
    Device->>Device: User clicks notification -> Open Chat Screen
```
