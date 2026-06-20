# User Acceptance Testing (UAT) BIMSI UBSI

Panduan pelaksanaan uji coba pengguna sebelum rilis *production*. Tester adalah representasi asli dari tiap *Role*.

## 1. Skenario UAT: Super Admin & Admin
| Skenario | Langkah | Hasil yang Diharapkan | Pass/Fail | Catatan |
|---|---|---|---|---|
| Mengelola Prodi | Login -> Master Data -> Tambah Prodi -> Isi Form -> Simpan | Prodi berhasil ditambahkan dan muncul di daftar. | | |
| Mengelola User | Master Data -> User -> Tambah -> Pilih Role Dosen -> Simpan | Akun dosen berhasil dibuat dan bisa digunakan untuk login. | | |
| Pantau Audit Log | Menu Audit Log | Terlihat rekam jejak "Admin B menambahkan Prodi X". | | |

## 2. Skenario UAT: Kaprodi
| Skenario | Langkah | Hasil yang Diharapkan | Pass/Fail | Catatan |
|---|---|---|---|---|
| Review Judul | Login -> Pengajuan Judul -> Pilih Judul Mahasiswa -> Klik Cek Plagiasi -> Klik Approve | Notifikasi muncul "Judul Disetujui" dan status berubah. | | |
| Tentukan Pembimbing | Menu Plotting -> Pilih Mahasiswa -> Pilih Dosen dari daftar (cek kuota) -> Simpan | Dosen & Mahasiswa berhasil terikat. | | |
| Download Laporan | Menu Laporan -> Klik Laporan Mahasiswa -> Export PDF | File PDF terunduh dan terbuka dengan data akurat. | | |

## 3. Skenario UAT: Dosen
| Skenario | Langkah | Hasil yang Diharapkan | Pass/Fail | Catatan |
|---|---|---|---|---|
| Buka Slot Jadwal | Login -> Menu Jadwal -> Buka Slot -> Tentukan Hari, Jam, Kuota -> Simpan | Slot waktu terpublikasi ke mahasiswa. | | |
| Terima Jadwal | Notifikasi masuk -> Klik -> Setujui Jadwal dari Mahasiswa A | Jadwal berpindah ke tab "Akan Datang". | | |
| Review Bab | Mahasiswa Bimbingan -> Detail -> Tab Dokumen -> Klik File -> Tulis Catatan -> Simpan | Catatan tersimpan, versi dokumen diupdate. | | |

## 4. Skenario UAT: Mahasiswa
| Skenario | Langkah | Hasil yang Diharapkan | Pass/Fail | Catatan |
|---|---|---|---|---|
| Ajukan Judul | Login -> Menu Pengajuan -> Isi Judul & Deskripsi -> Ajukan | Status berubah menjadi "Pending", list dilarang tambah judul lain. | | |
| Cek Realtime | Buka Dasbor (tunggu) | Tiba-tiba _snackbar_ muncul dan status judul berubah "Disetujui" saat Kaprodi menekan tombol setuju. | | |
| Upload Dokumen | Progress Skripsi -> Bab 1 -> Upload File (Pilih PDF/DOCX) -> Unggah | File masuk ke Cloudinary dan riwayat upload muncul di tab dokumen. | | |

## Kriteria Keberhasilan
- Semua *Pass/Fail* bernilai **Pass**.
- Aplikasi berjalan stabil, tidak ada _crash_ putih merah (Flutter).
- Waktu _loading_ UI di bawah 3 detik.
- Skenario terselesaikan tanpa _workaround_ eksternal (seperti ubah database manual).
