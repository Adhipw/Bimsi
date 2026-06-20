# Demo Flow Aplikasi BIMSI UBSI

Panduan alur presentasi (*Live Demo*) yang terstruktur agar fitur-fitur aplikasi dapat ditunjukkan secara komprehensif tanpa tersendat. Disarankan membuka 2 atau 3 emulator/device secara bersamaan untuk menunjukkan interaksi *Realtime Pusher*.

## 1. Setup & Pra-Demo
- Buka Device A (HP Sesungguhnya): Login sebagai **Mahasiswa**.
- Buka Device B (Emulator/Web): Login sebagai **Kaprodi**.
- Buka Device C (Emulator/Web): Login sebagai **Dosen Pembimbing**.

## 2. Alur Eksekusi Presentasi (Skrip)

### Babak 1: Pengajuan Judul (Mahasiswa & Kaprodi)
1. **[Mahasiswa]** Di HP A, masuk ke halaman **Pengajuan Judul**. Ketik judul "Sistem Prediksi Penjualan". Klik **Submit**. Tunjukkan bahwa statusnya *Pending*.
2. **[Realtime]** Pindah fokus ke Device B. Jelaskan bahwa Dasbor Kaprodi langsung ter-refresh otomatis tanpa me-*reload* aplikasi (Pusher event *JudulDiajukan*).
3. **[Kaprodi]** Kaprodi klik pengajuan tersebut. Gunakan fitur *Cek Plagiasi* (jika ada simulasi) lalu tekan tombol **Approve**.
4. **[Push Notification]** Fokus kembali ke HP A. Tunjukkan bahwa *Push Notification FCM* "Judul Anda telah disetujui" muncul di status bar Mahasiswa.

### Babak 2: Plotting Pembimbing & Slot Waktu (Kaprodi, Dosen, Mahasiswa)
1. **[Kaprodi]** Buka menu Plotting. Assign *Dosen X* ke Mahasiswa tersebut.
2. **[Dosen]** Di Device C (Dosen X), buka menu **Jadwal**. Buat slot baru untuk Hari Senin, Jam 10:00 - 12:00.
3. **[Mahasiswa]** Di HP A, masuk ke tab **Jadwal Bimbingan**. Lihat ketersediaan slot dosen, dan klik **Booking/Ajukan**.
4. **[Dosen]** Kembali ke Device C, Dosen melihat notifikasi pengajuan jadwal lalu menekan **Terima**.

### Babak 3: Bimbingan & Upload Dokumen (Mahasiswa & Dosen)
1. **[Mahasiswa]** HP A -> Menu **Dokumen Skripsi**. Upload file contoh "Bab1.pdf". Tekan unggah. 
2. **[Cloudinary]** Jelaskan ke penguji bahwa file tidak disimpan di server aplikasi, melainkan masuk ke _Cloudinary_ lalu URL-nya disimpan di database.
3. **[Dosen]** Dosen membuka file dokumen yang diunggah mahasiswa. Dosen memberikan komentar revisi.
4. **[Mahasiswa]** Mahasiswa melihat komentar revisi dan dapat mengunggah versi ke-2.

### Babak 4: Progress & Laporan Akhir (Dosen, Kaprodi, Super Admin)
1. **[Dosen]** Dosen masuk ke halaman **Progress Bimbingan**. Mengubah status Mahasiswa tersebut dari 0% menjadi 20% (Bab 1 Selesai).
2. **[Kaprodi]** Kaprodi (Device B) melihat rekapitulasi 20% di Dasbor Monitornya. Kaprodi menekan tombol **Export Laporan (PDF)**. Tunjukkan file PDF yang berhasil di-download.
3. **[Super Admin]** Jika waktu tersisa, login sebagai *Super Admin* dan buka halaman **Audit Log** untuk menunjukkan semua rentetan cerita di atas terekam lengkap sebagai jejak audit.

## Solusi Cepat Saat Error Demo
- Jika Pusher delay: Cukup tarik layar (Pull to Refresh).
- Jika token error 401: Logout semua akun dan Login ulang.
- Tunjukkan tab Network Inspection jika penguji ingin melihat koneksi asli ke server production.
