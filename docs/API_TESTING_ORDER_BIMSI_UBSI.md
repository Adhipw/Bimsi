# Alur & Urutan Testing API BIMSI UBSI

Langkah demi langkah mengeksekusi testing API di Postman agar data saling berkesinambungan tanpa error _Foreign Key_.

1. **Persiapan Database**: Jalankan `php artisan migrate:fresh --seed`
2. **Login Super Admin**: Hit `POST /api/login` dengan kredensial super admin. Simpan tokennya.
3. **Master Data**: (Menggunakan token super admin)
   - Hit `POST /api/admin/program-studi` -> Simpan *ID Prodi*.
   - Hit `POST /api/admin/tahun-akademik` -> Simpan *ID Tahun Akademik*.
   - Hit `POST /api/admin/mahasiswa` -> Masukkan _ID Prodi_. Simpan kredensial login Mahasiswa.
   - Hit `POST /api/admin/dosen` -> Simpan kredensial login Dosen.
   - Hit `POST /api/admin/kaprodi` -> Simpan kredensial Kaprodi.
4. **Login Kaprodi**: Hit `POST /api/login`.
   - Hit endpoint periode skripsi untuk mengaktifkan periode.
5. **Login Mahasiswa**: Hit `POST /api/login`.
   - Hit `POST /api/mahasiswa/pengajuan-judul` -> _Success 201_.
6. **Login Kaprodi (lagi)**:
   - Hit `GET /api/kaprodi/pengajuan-judul` -> Catat `id` pengajuan.
   - Hit `POST /api/kaprodi/pengajuan-judul/{id}/approve` -> Status menjadi _disetujui_.
   - Hit `POST /api/kaprodi/tentukan-pembimbing` -> Assign _Dosen_ yang dibuat di langkah 3 ke _Mahasiswa_.
7. **Login Dosen**: Hit `POST /api/login`.
   - Hit `POST /api/dosen/slot-bimbingan` -> Buat slot ketersediaan waktu.
8. **Login Mahasiswa (lagi)**:
   - Hit `POST /api/mahasiswa/jadwal-bimbingan` -> Booking slot yang dibuat dosen.
9. **Login Dosen**:
   - Approve jadwal bimbingan.
   - Hit `POST /api/dosen/progress` -> Update bab mahasiswa menjadi 20%.
10. **Laporan & Audit**:
    - Login Kaprodi -> Hit endpoint Export PDF.
    - Login Super Admin -> Hit `GET /api/super-admin/audit-logs` untuk melihat rekam jejak testing di atas.
