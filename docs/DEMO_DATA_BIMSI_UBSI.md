# Demo Data - BIMSI UBSI

Agar aplikasi dapat langsung didemonstrasikan setelah proses deployment (atau untuk pengujian tim QA), rancangan data *dummy* berikut harus tersedia.

## 1. Akun Default (Berdasarkan Role)
Semua akun demo menggunakan password standar: `password123`.

| Role | Nama Lengkap | Email | Deskripsi |
|---|---|---|---|
| **Super Admin** | Super Admin UBSI | superadmin@ubsi.ac.id | Akses penuh seluruh sistem |
| **Admin** | Admin BSI Kampus A | admin@ubsi.ac.id | Pengelola data operasional |
| **Kaprodi** | Kaprodi TI | kaproditi@ubsi.ac.id | Ketua Prodi Teknik Informatika |
| **Dosen** | Dr. Budi Santoso | budi.dosen@ubsi.ac.id | Dosen Pembimbing (Data Dummy 1) |
| **Mahasiswa** | Andi Permana | andi.mhs@ubsi.ac.id | Mahasiswa Skripsi (NIM: 12345678) |
| **Mahasiswa** | Siti Aminah | siti.mhs@ubsi.ac.id | Mahasiswa Skripsi (NIM: 87654321) |

## 2. Skenario Data Demo Aktif
Data demo harus mencakup setidaknya satu "Siklus Hidup Bimbingan":
- **Data Pengajuan**: Terdapat 1 judul pengajuan dengan status `Menunggu Plotting`.
- **Data Plotting**: Terdapat 1 mahasiswa (Andi) yang sudah di-plot ke Dosen Budi.
- **Data Dokumen**: Andi memiliki 1 dokumen (Bab 1) dengan status `Menunggu Review`.
- **Data Chat**: Terdapat riwayat chat "Halo Pak, saya izin bimbingan".
- **Data Jadwal**: Terdapat jadwal bimbingan offline besok jam 10.00.
