# Business Requirements Document (BRD) - BIMSI UBSI

## 1. Latar Belakang Bisnis
Universitas Bina Sarana Informatika (UBSI) membutuhkan sistem terpadu untuk memfasilitasi proses bimbingan skripsi dan tugas akhir antara mahasiswa, dosen pembimbing, ketua program studi (kaprodi), dan admin. Proses manual saat ini memakan waktu dan sulit dilacak.

## 2. Masalah Bisnis
- Proses bimbingan skripsi yang tidak terekam secara sistematis.
- Mahasiswa kesulitan memantau progress bimbingan.
- Dosen kesulitan mengelola banyak mahasiswa bimbingan secara bersamaan.
- Kaprodi dan Admin kesulitan memonitor aktivitas bimbingan secara real-time.
- Komunikasi yang kurang efisien dan tidak terpusat.

## 3. Tujuan Bisnis
Menyediakan aplikasi mobile (Android) terintegrasi yang memudahkan penjadwalan, monitoring, dan komunikasi dalam proses bimbingan skripsi, sehingga mempercepat waktu kelulusan dan meningkatkan kualitas bimbingan.

## 4. Stakeholder
- Manajemen Universitas (Rektorat)
- Program Studi (Kaprodi)
- Dosen
- Mahasiswa
- Tim IT / Administrator

## 5. Proses Bisnis Utama
- Pendaftaran bimbingan skripsi.
- Penetapan dosen pembimbing oleh Kaprodi/Admin.
- Penjadwalan sesi bimbingan (online/offline).
- Proses bimbingan (diskusi, revisi, upload dokumen).
- Persetujuan (approval) bab skripsi dan pendaftaran sidang.
- Pelaporan aktivitas bimbingan.

## 6. Role Pengguna
1. **super_admin**: Mengelola seluruh sistem, data master, konfigurasi aplikasi, dan role management.
2. **admin**: Mengelola data operasional (mahasiswa, dosen), plotting pembimbing.
3. **kaprodi**: Memonitor progress bimbingan di program studinya, menyetujui plotting pembimbing.
4. **dosen**: Mengelola jadwal bimbingan, memberikan feedback, menyetujui progress bimbingan mahasiswa.
5. **mahasiswa**: Mengajukan bimbingan, mengunggah dokumen skripsi, melihat jadwal, dan berdiskusi dengan dosen.

## 7. Manfaat Sistem
- **Efisiensi waktu**: Proses administrasi lebih cepat.
- **Transparansi**: Seluruh riwayat bimbingan terekam.
- **Kemudahan Akses**: Dapat diakses via aplikasi mobile kapan saja.
- **Pelaporan Akurat**: Dashboard untuk memantau status kelulusan mahasiswa.

## 8. Batasan Bisnis
- Hanya berfokus pada proses bimbingan skripsi/tugas akhir (tidak termasuk KRS, keuangan).
- Platform utama untuk user adalah Mobile Android (APK).
- Pengelolaan master data dan konfigurasi kompleks dilakukan oleh admin.

## 9. Risiko Bisnis
- Rendahnya adopsi oleh dosen yang terbiasa dengan cara manual.
- Kendala teknis (server down) yang menghambat proses bimbingan.
- Kebocoran data dokumen skripsi.

## 10. Kriteria Keberhasilan
- 80% mahasiswa tingkat akhir dan dosen menggunakan aplikasi.
- Waktu proses administrasi bimbingan berkurang 50%.
- Rating aplikasi di kalangan pengguna internal > 4.0.
