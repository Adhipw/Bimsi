# Security Testing Checklist BIMSI UBSI

Panduan pengetesan keamanan (Vulnerability Assessment & Penetration Testing ringan) untuk Backend Laravel dan Flutter BIMSI UBSI.

## 1. Authentication & Session
- [ ] **SQL Injection on Login:** Memastikan input `email` dengan `admin' OR '1'='1` tidak menembus sistem.
- [ ] **Expired Token Access:** Token yang di-*revoke* / kadaluarsa mendapat respons `401 Unauthorized`.
- [ ] **No Token Access:** Mengakses endpoint privat (misal `/api/kaprodi/pengajuan-judul`) tanpa Header *Authorization* memberikan `401 Unauthorized`.
- [ ] **Rate Limiting:** Mengirimkan *request* login lebih dari batas (misal 10x per menit) akan diblokir dengan `429 Too Many Requests`.

## 2. Role Permission (Broken Access Control)
- [ ] **Unauthorized Role Access (Mahasiswa -> Dosen):** Menggunakan token Mahasiswa untuk mengakses endpoint `/api/dosen/jadwal` harus me-return `403 Forbidden`.
- [ ] **Cross-User Data Modification:** Mahasiswa A mencoba meng-update id pengajuan milik Mahasiswa B di endpoint `/api/mahasiswa/pengajuan-judul/{idB}` harus menghasilkan `403 Forbidden` atau `404 Not Found` berkat validasi kepemilikan (ownership).
- [ ] **Super Admin Access:** Pastikan hanya token dengan role `super_admin` yang dapat mengakses `/api/super-admin/audit-logs`.

## 3. Upload File Berbahaya
- [ ] **Executable File Rejection:** Upload dokumen .php, .exe, .sh ke endpoint upload dokumen harus ditolak dan menghasilkan `422 Unprocessable Entity` (Hanya terima PDF/DOCX/JPG).
- [ ] **Oversized File Rejection:** Upload file berukuran 50MB+ (jika batas 5MB) menghasilkan respons gagal yang terkontrol dan rapi, bukan 500 Internal Server Error.
- [ ] **XSS via Filename:** File dengan nama `<script>alert(1)</script>.pdf` saat diunduh atau ditampilkan UI tidak menjalankan script tersebut di browser admin.

## 4. Keamanan Transmisi
- [ ] **Enforced HTTPS:** Pastikan di production (Koyeb), semua komunikasi (termasuk *upload* Cloudinary dan koneksi Pusher) terenkripsi TLS/SSL (WSS, HTTPS).
- [ ] **Data Exposure di Respons API:** Mengeksekusi endpoint profil/daftar user tidak mereturn data sensitif seperti *hashed password* (`password`) atau token rahasia di dalam _JSON body_.

## 5. Storage Security (Cloudinary)
- [ ] **Credential Hiding:** Kredensial *Cloudinary* (Cloud Name, API Key, API Secret) tidak tersimpan mati/di-*hardcode* di *source code*, melainkan hanya dipanggil melalui `env()`.
