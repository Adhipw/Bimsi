# Performance Testing BIMSI UBSI

Panduan untuk memastikan aplikasi beroperasi dengan latensi rendah dan memori efisien.

## 1. Kriteria Target Performa
- **Response Time API (Non-File Upload):** Maksimal < 300ms.
- **Waktu Unggah File (hingga 5MB):** Maksimal < 15 Detik (bergantung koneksi user).
- **Flutter UI Frame Rate:** Berjalan konstan di 60fps (atau 120fps sesuai layar) saat *scrolling* daftar panjang.
- **Pusher Realtime Latency:** Pembaruan antarmuka setelah event terpicu dari backend harus terjadi < 2 Detik.

## 2. Skenario Performance API (Backend)
- [ ] **N+1 Query Detection:** Pastikan pengambilan data relasi (seperti List Pengajuan dengan data Mahasiswa & Dosen Pembimbing) menggunakan `with()` (eager loading) dan bukan memanggil query di dalam _looping_ (lazy loading).
- [ ] **Pagination Test:** Ambil list data dalam jumlah besar (>1000 record mahasiswa). API harus diset untuk selalu mengembalikan data menggunakan `paginate(20)` dan tidak mengambil `.all()`.
- [ ] **Cold Start Database (Aiven):** Pengujian kecepatan akses query kompleks setelah koneksi DB lama tidak terpakai.

## 3. Skenario Performance UI (Flutter)
- [ ] **Image / Document Render:** Pastikan tampilan thumbnail PDF atau gambar (jika ada) menggunakan _caching_ (misal `cached_network_image`) untuk mencegah render ulang setiap _scroll_.
- [ ] **State Re-build Isolation:** Gunakan `ConsumerWidget` atau selektor *Riverpod* seefisien mungkin sehingga perubahan data progress mahasiswa A tidak me-render ulang seluruh `ListView` milik mahasiswa lainnya.
- [ ] **Memory Leaks:** Membuka dan menutup halaman _Detail Pengajuan_ puluhan kali berturut-turut tidak membuat *RAM Usage* Flutter membengkak secara eksponensial (pastikan `StreamController` dan *Pusher listener* di-_dispose_).

## 4. Solusi Optimasi Saat Penurunan Performa
- **Query Lambat:** Tambahkan *Database Index* di PostgreSQL pada kolom yang sering di-search/di-filter (contoh: `status` pada `pengajuan_juduls`, `role_id` pada `users`).
- **Pusher Overload:** Jika antrean panjang, oper event Pusher menjadi *Asynchronous Queues* (`ShouldBroadcast` diintegrasikan dengan Redis queue/database queue).
- **Export Laporan Lama (B16):** Generate PDF/Excel menggunakan Laravel Queues (`dispatch`) lalu kirimkan push notification saat file siap unduh daripada membiarkan koneksi HTTP _hang_ menunggu.
