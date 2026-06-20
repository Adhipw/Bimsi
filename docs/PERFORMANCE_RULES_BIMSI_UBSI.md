# Performance Rules - BIMSI UBSI

## 1. Aturan Efisiensi Database (Laravel)
- **Eager Loading**: Cegah permasalahan **N+1 Query Problem**. Selalu gunakan method `with()` di Eloquent ketika menarik data relasi secara massal.
  - *Contoh Benar*: `Bimbingan::with(['mahasiswa', 'dosen'])->get();`
  - *Contoh Salah*: Me-looping daftar bimbingan dan memanggil `$bimbingan->mahasiswa->nama` di setiap putaran.
- **Database Indexing**: Tambahkan indeks (`index()`) pada kolom *Foreign Key* (seperti `user_id`, `bimbingan_id`) dan kolom pencarian (seperti `NIM`, `NIDN`) pada tahapan migrasi untuk mempercepat proses pencarian di PostgreSQL.

## 2. Aturan Fetching API (Flutter)
- **Pagination**: Endpoint list (Daftar mahasiswa, riwayat chat panjang) wajib menggunakan fitur *Pagination* dari Laravel. Flutter tidak boleh menerima ratusan data sekaligus karena dapat mengakibatkan kehabisan memori. Batasi *limit* 15-20 item per request.
- **State Caching**: Di Flutter (menggunakan Riverpod/BLoC), simpan *state* data yang jarang berubah (seperti daftar nama Dosen pembimbing). Jangan me-request ulang data tersebut jika pengguna hanya bolak-balik halaman.

## 3. Optimasi Aset
- File dokumen PDF dibatasi maksimal 5MB untuk mempercepat upload dan hemat kuota Cloudinary.
- Terapkan standar *compression* jika ke depan menambahkan fitur *upload avatar profile* sebelum dikirim ke server.

## 4. Kecepatan Render (Flutter)
- Hindari penggunaan Widget `Opacity` berlebihan dan nested loop dalam method `build()`.
- Gunakan keyword `const` pada widget Flutter sebisa mungkin untuk mengurangi *rebuild* memori yang tidak perlu.
