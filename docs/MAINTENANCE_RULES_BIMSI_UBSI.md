# Maintenance Rules - BIMSI UBSI

## 1. Aturan Pemeliharaan Rutin (Server & Database)
- **Pembersihan Cache**: Jalankan perintah `php artisan optimize:clear` setiap kali usai proses *deployment* pembaruan ke Koyeb.
- **Pembersihan Data Lama**: Fitur penjadwalan (*Laravel Task Scheduling*) diatur untuk membersihkan notifikasi sistem yang umurnya sudah lebih dari 30 hari.

## 2. Upgrading Dependency
- **Flutter**: Setiap 3-6 bulan lakukan evaluasi pembaruan dependensi *pubspec.yaml*. Gunakan perintah `flutter pub outdated` untuk melihat package yang usang. Update secara bertahap dan tes di *development environment* terlebih dahulu.
- **Laravel**: Perbarui patch versi keamanan secara rutin menggunakan perintah `composer update`. Hindari *major upgrade* (contoh: dari Laravel 11 ke 12) di pertengahan semester akademik berjalan. Lakukan saat jeda liburan semester.

## 3. Manajemen API Deprecation
- Jika ada perubahan format *Request* atau *Response* yang bersifat mematahkan kompatibilitas versi mobile yang lama (*Breaking Change*), versi API harus dinaikkan (dari `/api/v1/` menjadi `/api/v2/`).
- Endpoint `/v1/` harus tetap menyala hingga semua perangkat mahasiswa dipastikan telah menginstal aplikasi Flutter versi terbaru.

## 4. SOP "Maintenance Mode"
- Jika admin harus memperbaiki database langsung atau memperbarui versi besar, aktifkan fitur *Maintenance Mode* di Laravel dengan perintah `php artisan down`.
- Pastikan Flutter memiliki interseptor global yang mengenali respons HTTP status `503 Service Unavailable`, dan mengubah tampilan aplikasi menjadi halaman informatif "Sedang Dalam Perbaikan".
