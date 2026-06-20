# Rollback Plan BIMSI UBSI

Panduan membatalkan perubahan sistem secara aman jika rilis atau pembaruan mendadak menimbulkan masalah *(crash)* serius.

## 1. Rollback Flutter (Mobile APK)
**Kondisi:** Mahasiswa atau Dosen melaporkan "Aplikasi tidak bisa dibuka / putih saat menekan menu Bimbingan".
1. Jika ini karena *update APK*, kirim ulang atau perintahkan *tester* untuk men-*downgrade* menggunakan file `BIMSI_UBSI_v1.0.apk` lama yang diketahui stabil.
2. Secara teknis di Git:
   ```bash
   git log --oneline # Cari commit sebelum update bermasalah
   git checkout <id-commit-stabil>
   flutter clean
   flutter build apk --release
   ```

## 2. Rollback Backend Laravel (Koyeb)
**Kondisi:** API mengembalikan pesan *Error 500* setelah di-_deploy_ ke Koyeb akibat kesalahan _syntax_.
1. Masuk ke dashboard Koyeb.
2. Di halaman **Deployments**, cari daftar _deploy_ yang pernah berhasil sebelumnya (berwarna hijau).
3. Klik titik tiga di sebelah *deployment* lama tersebut dan pilih **Rollback**. Koyeb akan seketika mengganti kontainer ke versi stabil lama.

## 3. Rollback Database (Aiven PostgreSQL)
**Kondisi:** Ada migrasi yang tak sengaja menghapus tabel, atau salah memasukkan tipe relasi di dalam *production*.
1. Jika baru 1 *step* migrasi ke belakang, jalankan dari konsol Koyeb:
   `php artisan migrate:rollback --force`
2. Jika terlanjur rusak parah (skema berantakan):
   Anda harus mengembalikan DB dari file backup Aiven secara utuh. Masuk ke *Aiven Console* -> Pilih layanan PostgreSQL -> Masuk tab *Backups* -> Klik **Restore Backup**.

## Aturan Rollback Emas
> *Jangan memaksakan penulisan ulang kode (hotfix-coding) pada saat demo atau saat user mengamuk. Selalu kembalikan ke versi stabil (Rollback), tenangkan situasi, lalu perbaiki bug tersebut di lingkungan pengembangan (Lokal) dengan tenang!*
