# Product Requirements Document (PRD) - BIMSI UBSI

## 1. Nama Produk
BIMSI UBSI (Bimbingan Skripsi Universitas Bina Sarana Informatika)

## 2. Visi Produk
Menjadi platform digital bimbingan skripsi terbaik yang menghubungkan mahasiswa dan dosen dengan mulus, transparan, dan efisien.

## 3. Target Pengguna
Mahasiswa tingkat akhir, Dosen Pembimbing, Ketua Program Studi, Administrator, dan Super Admin di lingkungan UBSI.

## 4. Scope Produk
Aplikasi mobile Android yang memfasilitasi pengajuan judul, penjadwalan bimbingan, ruang diskusi/revisi dokumen (real-time chat), notifikasi push, dan rekam jejak bimbingan hingga approval sidang.

## 5. Fitur per Role
- **super_admin**: Dashboard statistik lengkap, manajemen user & role, konfigurasi sistem, audit log.
- **admin**: CRUD Mahasiswa, Dosen, plot pembimbing, kelola jadwal sidang.
- **kaprodi**: Dashboard prodi, monitoring progress mahasiswa, approval judul.
- **dosen**: List mahasiswa bimbingan, kalender bimbingan, acc/reject dokumen (Cloudinary), fitur chat realtime.
- **mahasiswa**: Pengajuan judul, lihat dosen pembimbing, buat jadwal bimbingan, upload draft skripsi (Cloudinary), chat dengan dosen.

## 6. User Flow Utama
1. Mahasiswa login > Mengajukan judul skripsi.
2. Kaprodi login > Approve judul & plotting dosen.
3. Mahasiswa & Dosen login > Membuat jadwal bimbingan.
4. Mahasiswa upload file > Dosen review & memberi catatan via chat.
5. Dosen approve semua bab > Mahasiswa siap sidang.

## 7. Prioritas Fitur
- **P0 (Must Have)**: Autentikasi (Sanctum), Manajemen User, Plotting Dosen, Upload File (Cloudinary), Approval Skripsi.
- **P1 (Should Have)**: Realtime Chat Bimbingan (Pusher), Push Notification (FCM), Dashboard Progress.
- **P2 (Nice to Have)**: Export Laporan PDF/Excel.

## 8. Batasan Produk
- Aplikasi mobile hanya untuk Android (APK).
- Tidak ada fitur video call, hanya teks dan file sharing.

## 9. Acceptance Criteria
- Mahasiswa berhasil login, mengajukan bimbingan, dan upload file tanpa error.
- File berhasil diupload ke Cloudinary dan URL tersimpan di PostgreSQL Aiven.
- Dosen menerima notifikasi FCM saat mahasiswa mengajukan jadwal bimbingan.
- Pesan chat real-time menggunakan Pusher Channels diterima dalam < 2 detik.

## 10. Roadmap Pengembangan
- **Fase 1 (Bulan 1-2)**: Core API (Laravel), Database schema (PostgreSQL), UI/UX Flutter, Auth & Role.
- **Fase 2 (Bulan 3)**: Modul Bimbingan, Upload Document (Cloudinary), Dashboard.
- **Fase 3 (Bulan 4)**: Integrasi Pusher & FCM, Reporting, UAT.
- **Fase 4 (Bulan 5)**: Deployment API (Koyeb), Rilis APK.
