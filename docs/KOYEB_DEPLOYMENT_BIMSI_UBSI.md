# Deployment Backend Laravel ke Koyeb

Panduan ini mengatur *best practice* dalam mendemokan dan meng-*host* backend BIMSI UBSI di layanan awan (Koyeb), menggunakan koneksi Database Aiven.

## 1. File Konfigurasi (Procfile)
Di *root directory* `backend/`, telah dibuat sebuah file bernama `Procfile` dengan isi:
```text
web: php artisan serve --host=0.0.0.0 --port=$PORT
```
> Atau, Koyeb merekomendasikan penggunaan Dockerfile (Apache/Nginx) atau *buildpack* Heroku standar PHP.

## 2. Persiapan Git (Repository)
1. Inisialisasi Git di dalam folder `backend/`:
   ```bash
   git init
   git add .
   git commit -m "Siap deploy ke Koyeb"
   git branch -M main
   git remote add origin https://github.com/[USERNAME]/bimsi-ubsi-backend.git
   git push -u origin main
   ```

## 3. Environment Variables (Secret Koyeb)
Pada *dashboard* Koyeb, pastikan nilai *Environment Variables* berikut diisi sama persis dengan `.env` lokal Anda:
- `APP_ENV=production`
- `APP_DEBUG=false`
- `APP_KEY=base64:...` *(Wajib diisi sesuai `php artisan key:generate`)*
- `APP_URL=https://[nama-aplikasi-koyeb].koyeb.app`
- `DB_CONNECTION=pgsql`
- `DB_HOST=[Aiven Host]`
- `DB_PORT=[Aiven Port]`
- `DB_DATABASE=[Aiven DB Name]`
- `DB_USERNAME=[Aiven User]`
- `DB_PASSWORD=[Aiven Pass]`
- `PUSHER_APP_ID`, `PUSHER_APP_KEY`, `PUSHER_APP_SECRET`, `PUSHER_HOST`, `PUSHER_PORT`
- `BROADCAST_CONNECTION=pusher`
- Firebase Service Account (JSON credential) diletakkan atau di-*encode* agar aman.

## 4. Run Migration di Production
Karena Koyeb *ephemeral* (bersifat sementara untuk komputasi), database PostgreSQL (Aiven) tetap aman karena eksternal. Anda hanya perlu me-_run_ *migration* sekali:
- Buka fitur **Console / Terminal** di Dashboard Koyeb untuk *instance* Anda.
- Jalankan: `php artisan migrate --force`
- Jalankan: `php artisan db:seed --force` (untuk data dummy master).

## 5. Checklist Endpoint Production
Setelah *Deployment Status* berlabel **Healthy**, ujilah URL berikut menggunakan Postman:
- [ ] `GET https://[nama-aplikasi-koyeb].koyeb.app/` -> Muncul *Laravel Welcome Page* / API Response standard.
- [ ] `POST https://[nama-aplikasi-koyeb].koyeb.app/api/login` -> Sukses menghasilkan Token Sanctum.

Jika gagal (Error 500), lihat Tab **Logs** pada Koyeb Dashboard.
