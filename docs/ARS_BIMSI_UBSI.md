# Architecture Requirements Specification (ARS) - BIMSI UBSI

## 1. Arsitektur Sistem
Sistem menggunakan arsitektur Client-Server. 
- **Client**: Aplikasi Mobile (Flutter Android).
- **Server**: RESTful API (Laravel).
- Seluruh komunikasi data dari Flutter ke Database harus melalui Laravel API. Flutter dilarang keras melakukan koneksi langsung ke PostgreSQL.

## 2. Arsitektur Flutter
- Pattern: MVVM (Model-View-ViewModel) atau BLoC / Riverpod untuk State Management.
- Routing: GoRouter atau AutoRoute.
- Network Request: Dio dengan Interceptor untuk inject Bearer Token (Sanctum).

## 3. Arsitektur Laravel
- Framework: Laravel 11 (atau versi LTS terbaru yang stabil).
- Pattern: MVC (Model-View-Controller) / Repository-Service pattern untuk logic kompleks.
- API Response: API Resource / Fractal untuk konsistensi struktur JSON.

## 4. Arsitektur Database
- RDBMS: PostgreSQL hosted on Aiven.
- Schema: Strict relational schema dengan Foreign Key constraints.
- Tool Management: pgAdmin 4 (untuk developer/admin).

## 5. Arsitektur Realtime
- WebSocket Provider: Pusher Channels.
- Laravel men-trigger event melalui trait `ShouldBroadcast`.
- Flutter mendengarkan channel Pusher (menggunakan library `pusher_channels_flutter`).

## 6. Arsitektur Push Notification
- Provider: Firebase Cloud Messaging (FCM).
- Laravel mengirim payload push notification ke API FCM.
- Flutter (melalui package `firebase_messaging`) menerima push notification di background/foreground.

## 7. Arsitektur File Storage
- Provider: Cloudinary.
- Alur Upload: Flutter (Multipart) -> Laravel (Validasi Mime/Size) -> Cloudinary (Upload) -> Return URL -> Laravel (Simpan URL ke PostgreSQL) -> Return Response ke Flutter.

## 8. Arsitektur Deployment
- **Backend (API)**: Koyeb (menggunakan Docker container atau buildpack PHP/Laravel).
- **Database**: Aiven (PaaS PostgreSQL).
- **Frontend (Mobile)**: Build menjadi APK Android (.apk), didistribusikan secara manual atau melalui Play Store internal.

## 9. Struktur Folder Flutter
```text
lib/
├── core/         # Constants, themes, utils, error handlers
├── data/         # Models, data sources (API services), repositories
├── domain/       # Entities, repository interfaces (opsional jika clean arch)
├── presentation/ # UI Screens, widgets, state management (Riverpod/BLoC providers)
└── main.dart     # Entry point
```

## 10. Struktur Folder Laravel
```text
app/
├── Http/
│   ├── Controllers/Api/ # Endpoint controllers
│   ├── Requests/        # Form Request Validation
│   └── Resources/       # API Resources (JSON transformers)
├── Models/              # Eloquent Models
├── Services/            # Business Logic
└── Events/              # Pusher Broadcast Events
routes/
└── api.php              # Definisi route API
```

## 11. Alur Data
1. Flutter (Client) mengirim HTTP Request (via Dio) ke Laravel API (Koyeb).
2. Laravel memvalidasi request dan memproses business logic (menyimpan file ke Cloudinary, mengirim notif via FCM).
3. Laravel melakukan query ke PostgreSQL (Aiven) menggunakan Eloquent ORM.
4. Jika ada event realtime, Laravel broadcast ke Pusher.
5. Laravel merespon dengan format JSON.
6. Flutter me-render state berdasarkan response JSON atau update realtime dari Pusher.

## 12. Keamanan Sistem
- **CORS Policy**: Hanya mengizinkan request dari aplikasi yang diotorisasi.
- **Authentication**: Laravel Sanctum Token. Token disimpan aman di Flutter (menggunakan `flutter_secure_storage`).
- **Authorization**: Pengecekan Role & Permission di setiap endpoint API.
- **Data Protection**: Enkripsi password (Bcrypt), proteksi SQL Injection (via ORM), dan XSS protection (Laravel defaults).
