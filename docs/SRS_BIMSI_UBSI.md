# Software Requirements Specification (SRS) - BIMSI UBSI

## 1. Kebutuhan Fungsional
- Sistem harus memungkinkan 5 role berbeda untuk login dan mengakses dashboard masing-masing.
- Sistem harus memungkinkan admin/kaprodi menetapkan dosen pembimbing.
- Sistem harus memungkinkan mahasiswa mengunggah file revisi skripsi.
- Sistem harus menyediakan fitur chat untuk diskusi antara dosen dan mahasiswa.

## 2. Kebutuhan Non-Fungsional
- **Performance**: Waktu respon API maksimal 500ms.
- **Ketersediaan**: Sistem aktif 99.9% uptime (hosted di Koyeb & Aiven).
- **Usability**: Interface mudah dipahami (berdasarkan desain UI/UX).

## 3. Kebutuhan Autentikasi
- Menggunakan Laravel Sanctum untuk issue & verifikasi API Token.
- Password dienkripsi menggunakan Bcrypt.
- Session timeout dan token revocation saat logout.

## 4. Kebutuhan Role dan Permission
- Menggunakan Spatie Permission (atau sejenisnya) di backend.
- **super_admin**: All access.
- **admin**: CRUD user operasional, plot dosen.
- **kaprodi**: Read-only progress, approve plot.
- **dosen**: Manage bimbingan mahasiswa asuhannya.
- **mahasiswa**: Manage bimbingan miliknya sendiri.

## 5. Kebutuhan API
- Arsitektur RESTful API.
- Format request/response: JSON.
- Endpoint terproteksi middleware auth:sanctum & role checks.

## 6. Kebutuhan Database
- Relational Database Management System (RDBMS).
- Engine: PostgreSQL (Hosted di Aiven).
- Di-manage menggunakan pgAdmin 4.
- Migrasi dan Seeder dikelola melalui Laravel.

## 7. Kebutuhan Realtime
- Menggunakan Pusher Channels.
- Event broadcasting untuk: Pesan chat bimbingan baru, status persetujuan dokumen berubah.

## 8. Kebutuhan Notification
- Menggunakan Firebase Cloud Messaging (FCM).
- Trigger: Jadwal bimbingan dibuat/diubah, pengingat jadwal, chat masuk (saat app background).

## 9. Kebutuhan Upload Dokumen
- Provider: Cloudinary.
- Backend menerima file multipart/form-data via REST API, mengunggah ke Cloudinary via SDK, lalu URL Cloudinary disimpan ke PostgreSQL.
- Flutter tidak boleh upload langsung ke Cloudinary.

## 10. Kebutuhan Laporan
- Generate rekapan bimbingan dalam format PDF/Excel.
- Statistik jumlah mahasiswa bimbingan per dosen.

## 11. Kebutuhan Audit Log
- Mencatat seluruh aktivitas krusial (siapa yang login, siapa yang menyetujui dokumen, jam berapa).
- Disimpan di tabel `audit_logs`.

## 12. Error Handling
- Standar format response error (JSON) dengan `message`, `errors` (detail validasi), dan `status_code` (400, 401, 403, 404, 500).
- Penanganan global exception di Laravel (`app/Exceptions/Handler.php`).
