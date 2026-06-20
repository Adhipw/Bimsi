# Final Review Project BIMSI UBSI

Review keselarasan hasil akhir dari *Source Code* dengan rancangan *Master Document* (BRD, PRD, SRS) guna mengevaluasi kelayakan *Release Candidate* (RC-1).

## 1. Pengecekan Kepatuhan Aturan (*Master Rule*)
| Aturan | Status | Bukti / Realisasi |
|---|---|---|
| Flutter tidak konek langsung ke DB | ✅ Lulus | Semua pemanggilan HTTP melalui `ApiClient` ke Endpoint API Laravel. |
| Database utama PostgreSQL Aiven | ✅ Lulus | `.env` sudah mengarah ke skema `pgsql` (host eksternal Aiven jika dipakai). |
| Realtime menggunakan Pusher Channels | ✅ Lulus | Penggunaan library `pusher-php-server` dan `pusher_channels_flutter`. |
| Upload Dokumen ke Cloudinary | ✅ Lulus | `UploadController` diatur untuk meneruskan file Multipart ke API Cloudinary. |
| Push notification via FCM | ✅ Lulus | Integrasi dengan package `firebase_messaging` dan HTTP v1 Service Laravel. |

## 2. Review Endpoint API (Kelengkapan REST)
- **Modul Master Data:** Selesai. Pengoperasian `apiResource` CRUD (Prodi, Mahasiswa, Dosen, Kelas) diproteksi di bawah Role Admin & Super Admin.
- **Modul Pengajuan Judul:** Selesai. Alur transisi status: `pending` -> `disetujui/ditolak` tereksekusi lewat KaprodiPengajuanJudulController.
- **Modul Jadwal & Progress:** Selesai. Bentrokan diminimalisir via entitas `SlotBimbingan` dan `JadwalBimbingan`.

## 3. Identifikasi Isu yang Perlu Diperbaiki (Technical Debt)
Berdasarkan analisis arsitektur, berikut adalah komponen minor yang perlu di-refactor pada versi selanjutnya (v1.1+):
- [ ] **Kode Duplikat di Flutter:** *Error Handling SnackBar* (`ScaffoldMessenger`) masih diketik manual di puluhan file UI. Direkomendasikan untuk membuat kelas statis pemanggil pesan global.
- [ ] **Data Hardcode:** Saat login tersimulasi/awal-awal (sebelum B5), terdapat *token manual*. Harap pastikan semua variabel token sudah diganti memanggil *Shared Preferences*.
- [ ] **Laravel Seeder Lemah:** Data Dosen (bidang_keahlian) di *Seeder* belum mencerminkan kasus yang sangat spesifik (banyak _relasi Many-to-Many_). Diperlukan Faker khusus Akademik.

## 4. Fitur Yang "Nice-to-Have" (Pengembangan Lanjutan / V2.0)
Sesuai *Business Requirements Document (BRD)*, lingkup fungsional utama telah tercapai. Namun untuk iterasi selanjutnya, Anda dapat mengajukan:
1. **Fitur Chat (In-App Messaging):** Obrolan _private_ 1-on-1 antara Mahasiswa dan Dosen via Websocket di luar lembar form.
2. **Scan QR Code:** Mahasiswa bisa memindai QR Code dari layar dosen untuk mem-verifikasi "Kehadiran Bimbingan Offline".
3. **Plagiarism Checker Otomatis (AI):** Cek kemiripan judul dihubungkan langsung via API pihak ketiga (misal *Turnitin* API atau Cosine Similarity berbasis NLP).

## Keputusan Final
> **Aplikasi dinyatakan LAIK untuk didemonstrasikan.** Arsitekturnya sudah mengikuti standar *Clean Architecture* sederhana di Laravel (Controller/Service pattern) dan *Feature-First* di Flutter.
