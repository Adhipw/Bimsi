# Recovery Plan BIMSI UBSI

Panduan mitigasi bencana dan cara merespon saat komponen-komponen kritis aplikasi lumpuh (Down) ketika sedang dipresentasikan atau digunakan secara *live*.

## 1. Kegagalan API / Server (Koyeb Down)
**Gejala:** Aplikasi Flutter memunculkan *Snackbar*: `SocketException: Failed host lookup` atau *loading* tanpa henti.
- **Tindakan Cepat (1 Menit):** Restart aplikasi di HP. Cek koneksi internet (apakah tethering mati?).
- **Tindakan Lanjut:** Buka Dashboard Koyeb. Jika memori habis (OOM) atau status _Suspended_, klik opsi **Restart Service**.
- **Plan B (Darurat Demo):** Langsung cabut koneksi ke API _Cloud_, hubungkan kabel HP ke Laptop, jalankan *local backend* (`php artisan serve`), lalu jalankan apk/flutter mode debug (mengarah ke `10.0.2.2`).

## 2. Kegagalan Realtime (Pusher Gagal)
**Gejala:** Kaprodi meng-_approve_ judul, namun di HP Mahasiswa statusnya tidak berubah secara _live_ tanpa ditarik (*pull to refresh*).
- **Penjelasan:** Batas limit harian Pusher gratis tercapai.
- **Tindakan:** Minta pengguna melakukan **Manual Refresh** (tarik layar ke bawah) atau pindah ke halaman lain lalu kembali. Secara bisnis, alur tetap berjalan lancar karena ini hanya delay penyajian saja.

## 3. Kegagalan Database (Aiven Maintenance/Limit)
**Gejala:** Semua API memberikan pesan `SQLSTATE[08006] [7] connection to server was lost` atau *Timeout*.
- **Tindakan:** Ini adalah _force majeure_ di level infrastruktur _cloud database_. Hubungi / lihat *status page* penyedia layanan (status.aiven.io). Satu-satunya cara adalah menunggu layanan pulih sambil memastikan aplikasi kita menangani error (tidak mati total/force close, hanya menampilkan pop-up "Server Sibuk").

## 4. Kegagalan Upload (Cloudinary Down/Penuh)
**Gejala:** Upload dokumen selalu gagal. `CloudinaryException`.
- **Tindakan:** Pastikan ukuran file PDF tidak melebihi batasan memori (misal: kurangi PDF menjadi di bawah 2MB). Jika akun penuh, buat *environment variable* akun cadangan baru dan _update variable_ `CLOUDINARY_URL` di Koyeb seketika, server akan *auto-restart* dan siap menerima upload lagi.
