# API Testing Collection BIMSI UBSI

Daftar endpoint API yang harus diuji di Postman atau alat testing API lainnya. Semua *request* ber-otorisasi harus menyertakan header `Authorization: Bearer {token}`.

## 1. Authentication
- `POST /api/login` - Test valid login, invalid email, invalid password.
- `POST /api/logout` - Test membatalkan token (revoke).
- `GET /api/profile` - Test mendapatkan detail pengguna.

## 2. Push Notification & Realtime
- `POST /api/fcm-token` - Menyimpan device token Firebase pengguna.
- `POST /api/broadcasting/auth` - Autentikasi Pusher Private Channel (Otomatis dipakai library).

## 3. Master Data (Admin/Super Admin)
- `GET /api/admin/program-studi` - Ambil data prodi.
- `POST /api/admin/program-studi` - Buat prodi baru.
- `PUT /api/admin/program-studi/{id}` - Update prodi.
- `DELETE /api/admin/program-studi/{id}` - Hapus prodi.
- *(Sama untuk Tahun Akademik, Semester, Dosen, Mahasiswa, Kelas).*

## 4. Pengajuan Judul (Mahasiswa & Kaprodi)
- `POST /api/mahasiswa/pengajuan-judul` - Mahasiswa mengajukan judul.
- `GET /api/mahasiswa/pengajuan-judul/status` - Cek status terkini.
- `GET /api/kaprodi/pengajuan-judul` - Kaprodi melihat list.
- `GET /api/kaprodi/pengajuan-judul/cek-kemiripan` - Cek plagiasi judul.
- `POST /api/kaprodi/pengajuan-judul/{id}/approve` - Setuju judul.
- `POST /api/kaprodi/pengajuan-judul/{id}/reject` - Tolak / revisi judul.

## 5. Penjadwalan Bimbingan (Dosen & Mahasiswa)
- `POST /api/dosen/slot-bimbingan` - Dosen atur ketersediaan waktu.
- `GET /api/mahasiswa/slot-bimbingan/{dosenId}` - Mahasiswa mencari waktu dosen.
- `POST /api/mahasiswa/jadwal-bimbingan` - Mahasiswa pilih slot & booking.
- `PUT /api/dosen/jadwal-bimbingan/{id}` - Dosen _approve/reject_ booking.

## 6. Dokumen Skripsi
- `POST /api/mahasiswa/dokumen` - Upload file laporan.
- `POST /api/dosen/dokumen/review` - Tambah review di dokumen.

## 7. Progress Skripsi
- `GET /api/mahasiswa/progress` - Melihat progress diri sendiri.
- `POST /api/dosen/progress` - Meng-update status per BAB dari mahasiswa bimbingan.
- `GET /api/kaprodi/progress-monitoring` - Pantau rekapitulasi 0-100%.

## 8. Laporan & Audit (B16)
- `GET /api/kaprodi/laporan/mahasiswa-skripsi?export=pdf` - Export data.
- `GET /api/kaprodi/laporan/mahasiswa-skripsi?export=excel` - Export excel.
- `GET /api/super-admin/audit-logs` - Melihat riwayat aksi log.

## 9. Pendaftaran Sidang & Sempro
- `POST /api/mahasiswa/pendaftaran-sidang` - Mendaftar sidang.
- `GET /api/mahasiswa/pendaftaran-sidang/status` - Cek status pendaftaran sidang.

## 10. Logbook Bimbingan
- `POST /api/mahasiswa/logbook` - Mahasiswa menambah kegiatan logbook.
- `GET /api/mahasiswa/logbook` - Melihat daftar logbook.
- `PUT /api/dosen/logbook/{id}/approve` - Dosen menyetujui logbook.

## 11. Real-time Chat
- `GET /api/chat/{pengajuan_judul_id}` - Memuat riwayat chat.
- `POST /api/chat/send` - Mengirim pesan baru.
- `PUT /api/chat/{id}/read` - Menandai pesan telah dibaca.

## 12. Manajemen Referensi (Library)
- `GET /api/mahasiswa/referensi` - List referensi.
- `POST /api/mahasiswa/referensi` - Tambah referensi.
- `DELETE /api/mahasiswa/referensi/{id}` - Hapus referensi.

## 13. Pusat Bantuan (FAQ & Unduhan)
- `GET /api/public/pusat-bantuan` - Akses publik melihat FAQ.
- `GET /api/pusat-bantuan` - Admin melihat semua data.
- `POST /api/pusat-bantuan` - Admin tambah FAQ.

## 14. Approval (ACC) Sidang & TTD Digital (Dosen)
- `GET /api/dosen/pendaftaran-sidang` - Dosen melihat daftar pendaftaran sidang.
- `POST /api/dosen/pendaftaran-sidang/{id}/approve` - Dosen menyetujui sidang (men-generate hash TTD Digital).
- `GET /api/public/verifikasi-ttd/{hash}` - Verifikasi publik TTD Digital/QR Code.

## 15. Catatan Privat Mahasiswa (Dosen)
- `GET /api/dosen/catatan-privat/{mahasiswa_id}` - Melihat catatan dosen untuk mahasiswa tertentu.
- `POST /api/dosen/catatan-privat` - Menambah atau mengubah catatan privat (body: `mahasiswa_id`, `catatan`).
- `DELETE /api/dosen/catatan-privat/{id}` - Menghapus catatan privat.
