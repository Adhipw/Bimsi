# User Manual

## Tentang Aplikasi
Bimsi UBSI adalah aplikasi bimbingan skripsi online. Aplikasi ini menggunakan alur web service: Flutter Web mengakses backend REST API `/api/v1`.

## Alur Awal Semua User
1. Buka landing page.
2. Pilih kampus.
3. Pilih jurusan/program studi.
4. Pilih periode skripsi.
5. Pilih portal.
6. Login sesuai role.

User tidak boleh langsung login tanpa melewati alur awal.

## Portal Mahasiswa
Mahasiswa dapat:
- Register dengan NIM, data diri, kampus, jurusan, kelas, semester, angkatan, judul sementara, dan bidang penelitian.
- Menunggu verifikasi admin jika status `pending_verification`.
- Login setelah akun aktif.
- Melengkapi profil.
- Melihat dosen pembimbing dan status dosen live.
- Mengajukan judul skripsi.
- Booking slot bimbingan setelah verified.
- Upload dokumen skripsi.
- Melihat review, revisi, checklist, progress, kartu bimbingan, notifikasi, pesan, pengumuman, dan template.
- Download kartu bimbingan PDF.
- Mengatur dark mode dan bahasa.

## Portal Dosen
Dosen dapat:
- Request account dengan NIP/NIDN dan data akademik.
- Login setelah approved oleh admin atau super admin.
- Melengkapi profil dan status live.
- Melihat mahasiswa bimbingan.
- Review judul dan dokumen.
- Membuat jadwal dan slot bimbingan.
- Approve/reject booking.
- Mengelola guidance room, antrean, attendance, revisi, checklist, pesan, dan laporan.

Reject booking wajib berisi alasan dan jadwal pengganti.

## Portal Koordinator
Koordinator dapat:
- Monitoring mahasiswa dan dosen.
- Menentukan/mengganti pembimbing.
- Melihat progress per prodi.
- Melihat mahasiswa terlambat bimbingan.
- Melihat eligibility seminar/sidang.
- Melihat SLA violation dan workload dosen.
- Export laporan CSV/PDF.

Koordinator tidak boleh mengelola super admin.

## Portal Admin Kampus
Admin dapat:
- Mengelola mahasiswa, dosen, koordinator, kampus, prodi, periode, layanan, dan aturan.
- Verifikasi mahasiswa.
- Approve/reject request akun dosen.
- Import data CSV/Excel dengan preview dan error report.
- Mengatur pembimbing, SLA, pengumuman, template, FAQ, help center, logs, dan laporan.

Admin tidak boleh mengakses `/dashboard/super-admin` atau `/api/v1/super-admin/*`.

## Portal Super Admin
Super admin dapat:
- Mengelola seluruh user, kampus, prodi, periode, API keys, settings, maintenance mode, logs, security, report global, backup/export, dan archive periode.
- Mengakses `/dashboard/super-admin`.
- Mengakses `/api/v1/super-admin/*`.

## Web Service Demo
Demo screen digunakan untuk menunjukkan:
- Flutter mengirim request ke backend API.
- Status code HTTP.
- JSON response success/error.
- Contoh GET, POST, PATCH/PUT, DELETE.
- Error auth/authorization jika token atau role salah.

## Catatan Keamanan Pengguna
- Jangan membagikan password.
- Jangan upload dokumen di luar format yang diizinkan.
- Jika muncul unauthorized, gunakan portal yang sesuai.
- Jika akun pending, tunggu verifikasi admin.
