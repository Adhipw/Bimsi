# Debugging Guide BIMSI UBSI

Panduan buku saku pemecahan masalah mandiri. Ikuti alur penelusuran (*trace*) ini untuk mengidentifikasi darimana _bug_ berasal di lingkungan sistem yang kompleks (Flutter + API + Database + Third-Party).

## Alur Dasar Debugging (The Rule of Thumb)
Setiap mendapatkan *error*, tanyakan urutan ini:
1. **Apakah respons API-nya bermasalah?** (Cek Postman / Tab Network).
2. **Apakah kodenya bermasalah?** (Cek log Flutter / Laravel).
3. **Apakah layanannya yang bermasalah?** (Cek Cloudinary / Pusher / Koyeb Status).

---

## 1. Masalah Tampilan Flutter Putih (*White Screen / Crash*)
- **Deskripsi:** Aplikasi dibuka, lalu mendadak putih (Render Error).
- **Langkah Inspeksi:** 
  1. Sambungkan HP/Emulator ke PC.
  2. Jalankan dari terminal: `flutter logs` atau jalankan via VS Code.
  3. Cari teks **"The following NoSuchMethodError..."** atau **"A render flex overflowed..."**.
- **Solusi Utama:** Jika error `NoSuchMethodError` (Null check operator used on a null value), berarti ada variabel (misal `pengajuan!.judul`) yang dipanggil sebelum datanya di-*fetch* API. Ubah menjadi `pengajuan?.judul ?? 'Memuat...'`.

## 2. API Laravel Memberikan Respon Kode 500 (Server Error)
- **Deskripsi:** Flutter menunjukkan *snackbar*: "Gagal terhubung ke server" (Respons 500).
- **Langkah Inspeksi:**
  1. Jangan menebak-nebak di Flutter. Buka terminal server / log Koyeb.
  2. Buka `backend/storage/logs/laravel.log`.
  3. Perhatikan *Stack trace* terbaru.
- **Solusi Utama:**
  - Jika log berbunyi `SQLSTATE[23502]: Not null violation` -> Anda lupa mengirim parameter (misal: "nim") dari Flutter. Lengkapi parameter di `ApiClient.post`.
  - Jika log berbunyi `Class "App\Http\Controllers\X" not found` -> Namespace salah atau belum di-import di `api.php`.

## 3. Data Tidak Ter-Update Secara Live (Masalah Pusher)
- **Deskripsi:** Kaprodi *approve* judul, tapi dasbor mahasiswa diam saja.
- **Langkah Inspeksi:**
  1. Buka *Pusher Debug Console* di website Pusher.com.
  2. Klik "Approve" lagi di dasbor Kaprodi. Lihat apakah event masuk ke web Pusher.
  3. Jika **masuk**, masalah ada di Flutter (Pusher Channels tidak _subscribe_ ke *channel* yang tepat).
  4. Jika **tidak masuk**, masalah ada di Laravel (Pusher tidak tereksekusi, cek `QUEUE_CONNECTION` atau `.env`).
- **Solusi Utama:** Samakan penamaan _channel_ (contoh: `private-mahasiswa.{id}`) di `routes/channels.php` dengan yang didengarkan oleh `RealtimeService` di Flutter.

## 4. Gagal Upload Dokumen / PDF (Masalah Cloudinary)
- **Deskripsi:** Proses unggah bab skripsi selalu mental atau loading terus.
- **Langkah Inspeksi:**
  1. Cek Postman dengan mencoba upload file ke `/api/mahasiswa/dokumen` menggunakan form-data (Key `file` dan value *file PDF*).
  2. Cek balasan pesannya.
- **Solusi Utama:** Pastikan `CLOUDINARY_URL` di `.env` valid. Pastikan Flutter menggunakan `MultipartRequest` untuk mengirim form data file, bukan pengiriman JSON biasa.

## Format Melaporkan Error ke Developer Lain (Template)
Bila *error* tak kunjung usai, berikan data terstruktur ini:
1. **Bagian Error:** (misal: Menu Pengajuan Judul Mahasiswa)
2. **Endpoint API:** `POST /api/mahasiswa/pengajuan-judul`
3. **Response Status:** `422 Unprocessable Entity`
4. **Log Laravel / Flutter:** `Integrity constraint violation: foreign key kelas_id fails`
5. **Screenshot UI:** (Lampirkan visual posisi error)
