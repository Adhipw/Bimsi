# Security Checklist - BIMSI UBSI

## 1. Autentikasi dan Otorisasi (Authentication & Authorization)
- [ ] Penggunaan **Laravel Sanctum** untuk verifikasi Token API di semua endpoint yang diproteksi.
- [ ] Penyimpanan token di sisi Flutter menggunakan **flutter_secure_storage** (enkripsi berbasis perangkat keras/keystore).
- [ ] Password user wajib dienkripsi menggunakan algoritma *Bcrypt* sebelum masuk ke database.
- [ ] Implementasi **Role-Based Access Control (RBAC)** di setiap endpoint (contoh: Middleware pengecekan peran Mahasiswa tidak boleh membuka data Admin).

## 2. Validasi dan Input Sanitization
- [ ] Validasi *strict* untuk semua input menggunakan `FormRequest` Laravel (menghindari parameter injeksi).
- [ ] Filter file ekstensi ketat saat upload (Hanya terima `.pdf` untuk skripsi, maksimal 5MB).
- [ ] Sanitasi string untuk menghindari *Cross-Site Scripting (XSS)* saat menampilkan nama atau pesan chat.

## 3. Proteksi Database & API
- [ ] Proteksi **SQL Injection**: Selalu gunakan *Eloquent ORM* atau *Query Builder* bawaan Laravel (jangan raw query tanpa *binding* parameter).
- [ ] Konfigurasi **CORS** di Laravel agar API hanya melayani *origin* atau aplikasi yang valid (opsional jika hanya API Mobile, namun penting untuk pengujian).
- [ ] Gunakan fitur **Rate Limiting** Laravel (`throttle`) pada endpoint kritis seperti `/login` dan `/upload` untuk mencegah serangan *Brute Force* atau DDOS.

## 4. Komunikasi Eksternal
- [ ] Pastikan backend menggunakan sertifikat SSL/TLS (**HTTPS**) saat *deployment* di Koyeb.
- [ ] Sembunyikan *Credential* layanan pihak ke-3 (Cloudinary, Firebase, Pusher) di *Environment Variables*.
