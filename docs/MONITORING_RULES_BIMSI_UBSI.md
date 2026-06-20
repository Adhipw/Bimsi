# Monitoring Rules - BIMSI UBSI

## 1. Monitoring Log Error Backend
- **Laravel Logs**: Semua kegagalan *Exception* dan *HTTP 500* harus tercatat otomatis oleh fitur logging bawaan Laravel (`storage/logs/laravel.log`).
- Karena backend berjalan di PaaS (Koyeb), pastikan pengiriman *output stderr/stdout* terhubung ke panel **Koyeb Runtime Logs**.
- Jika diperlukan, integrasikan pelacak error *Sentry* atau *Bugsnag* untuk mendapatkan notifikasi instan apabila terjadi server *crash*.

## 2. Audit Trails (Sistem Internal)
- Sistem mencatat aktivitas pengguna secara internal di tabel `audit_logs` (berdasarkan SRS).
- Perekaman meliputi: Siapa yang login, waktu login, aktivitas pengubahan status (Approve/Reject dokumen), dan siapa pelakunya.
- Log ini harus bisa dilihat oleh *Super Admin* lewat dasbor untuk proses investigasi jika ada keluhan jadwal atau nilai yang dimanipulasi.

## 3. Uptime dan Health Checks
- Sediakan satu endpoint API spesifik (misal: `/api/v1/health`) yang mengembalikan status `{"status": "ok", "db_connection": true}`.
- Gunakan layanan eksternal (contoh: *UptimeRobot*) untuk memantau endpoint `/health` setiap 5 menit. Jika Koyeb atau Aiven bermasalah, tim administrator akan menerima notifikasi email.

## 4. Firebase Analytics (Opsional Mobile)
- Aktifkan Firebase Crashlytics pada Flutter untuk memantau jika aplikasi di sisi pengguna *force close* (ANR / App Not Responding), serta melihat model *smartphone* mana yang paling rentan bermasalah.
