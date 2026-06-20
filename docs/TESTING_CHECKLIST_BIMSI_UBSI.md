# Testing Checklist BIMSI UBSI

Panduan komprehensif untuk pengujian aplikasi BIMSI UBSI (Mobile & API).

## 1. Flutter Testing Checklist
- [ ] **UI/UX & Responsiveness**
  - Aplikasi tidak _overflow_ di berbagai ukuran layar (smartphone & tablet).
  - Skema warna, _typography_, dan _spacing_ sesuai Design System.
  - _Empty State_ dan _Loading State_ muncul dengan benar di semua _page_ yang mengambil data.
- [ ] **State Management (Riverpod)**
  - Transisi state asinkron (loading -> data/error) berjalan halus.
  - State tersinkronisasi antar-halaman tanpa memori bocor (menggunakan `autoDispose` saat diperlukan).
- [ ] **Navigation (GoRouter)**
  - Navigasi antar-dashboard berjalan sesuai otorisasi *role*.
  - Menekan tombol "Back" tidak mengembalikan pengguna ke halaman yang dilarang (misal: kembali ke Login saat sudah terautentikasi).
- [ ] **Offline Handling**
  - Muncul pesan _error_ / _snackbar_ saat gagal terhubung ke server/internet.

## 2. Laravel API Testing Checklist
- [ ] **Authentication & Authorization**
  - Token Sanctum di-*generate* dan di-*revoke* dengan benar saat login/logout.
  - Endpoint terlindungi (*protected*) tidak bisa diakses tanpa token.
  - RoleMiddleware berfungsi; mahasiswa tidak bisa mengakses endpoint dosen/kaprodi.
- [ ] **Data Validation**
  - Semua _Form Request_ mereturn error 422 JSON yang terstruktur.
  - SQL Injection dan XSS attack ditangkal oleh Laravel secara *default*.
- [ ] **Business Logic**
  - Pengajuan judul tidak duplikat untuk periode yang sama jika masih *pending/revisi*.
  - Penjadwalan dosen mendeteksi konflik/bentrok jadwal.

## 3. Database (PostgreSQL) Testing Checklist
- [ ] **Schema & Constraints**
  - Semua _foreign key_ (`cascadeOnDelete`) berfungsi benar (hapus *user* akan hapus data *mahasiswa*, dsb).
  - Tipe data UUID/Integer untuk _primary keys_ tersinkronisasi baik.
- [ ] **Seeding & Migrations**
  - Menjalankan `php artisan migrate:fresh --seed` sukses membuat struktur dan _dummy data_ lengkap tanpa *error*.

## 4. Realtime Pusher Testing Checklist
- [ ] **Private Channels**
  - Klien tidak bisa me-_listen_ ke _private channel_ pengguna lain (otentikasi di `routes/channels.php` bekerja).
- [ ] **Event Dispatching**
  - Perubahan di backend (_approve_ judul) seketika mentrigger *event* melalui Pusher tanpa penundaan.
- [ ] **Flutter Receiver**
  - Aplikasi langsung merender ulang / memanggil API _refresh_ saat notifikasi Pusher masuk.

## 5. Firebase Cloud Messaging Testing Checklist
- [ ] **FCM Token**
  - Token *device* berhasil didapatkan di Flutter saat inisialisasi.
  - Token berhasil dikirim ke endpoint `/api/fcm-token`.
- [ ] **Push Notification Delivery**
  - Notifikasi masuk saat aplikasi berjalan di *Background* maupun *Terminated*.
  - Notifikasi *Foreground* dimunculkan sebagai _Snackbar_ lokal di aplikasi.

## 6. Cloudinary Testing Checklist
- [ ] **File Upload**
  - Upload file PDF / Image tidak _timeout_.
  - Format file yang salah dan ukuran berlebih ditolak oleh API.
- [ ] **File Retrieval**
  - *URL* dari Cloudinary valid dan file dapat diakses / diunduh dari aplikasi (lewat _url_launcher_).

## 7. Koyeb Deployment Testing Checklist
- [ ] **Environment**
  - Aplikasi Koyeb dapat mengakses DB Aiven (IP *whitelisting* / _connection string_ valid).
  - _Environment variables_ (`.env`) production terpasang dengan benar (Cloudinary, Pusher, FCM).
- [ ] **Cold Start / Response Time**
  - Layanan API tidak memiliki jeda tidak masuk akal saat *cold start*.

## 8. Skenario Testing Fitur Utama
1. **Flow Pengajuan**: Mahasiswa -> Ajukan Judul -> Status Pending -> Kaprodi Approve -> Status Disetujui -> Mahasiswa menerima Notifikasi (FCM) dan layar _refresh_ realtime.
2. **Flow Jadwal**: Mahasiswa -> Lihat Slot Dosen -> Pilih Slot -> Status *Scheduled* -> Dosen Terima / Tolak.
3. **Flow Revisi & Dokumen**: Mahasiswa -> Upload Bab -> Dosen Review -> Tambah Catatan -> Versi berubah.
4. **Flow Progress**: Dosen -> Update Bab 1 (Selesai) -> Progress % di Dasbor bertambah -> Kaprodi dapat memantau akumulasi di Dasbor Laporan.
