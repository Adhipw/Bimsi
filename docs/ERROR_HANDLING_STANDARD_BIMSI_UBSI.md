# Error Handling Standard - BIMSI UBSI

## 1. Standar Error Code API (Laravel)
- **400 Bad Request**: Request tidak sesuai format atau parameter wajib tidak ada.
- **401 Unauthorized**: Token tidak disertakan atau token sudah tidak valid.
- **403 Forbidden**: Token valid, tetapi role user tidak berhak mengakses endpoint tersebut.
- **404 Not Found**: Endpoint atau data (resource) yang dicari tidak ada.
- **422 Unprocessable Entity**: Validasi form gagal (menampilkan array field yang error).
- **429 Too Many Requests**: Rate limiting tercapai.
- **500 Internal Server Error**: Kesalahan logika pada server atau koneksi database terputus.

## 2. Standar Pesan Error di Flutter
- **HTTP 400**: "Permintaan tidak dapat diproses. Pastikan data yang dikirim benar."
- **HTTP 404**: "Data yang Anda cari tidak ditemukan."
- **HTTP 500**: "Terjadi kesalahan pada server. Silakan coba beberapa saat lagi."
- **Timeout**: "Waktu permintaan habis. Periksa koneksi internet Anda."
- **Unknown Error**: "Terjadi kesalahan yang tidak diketahui (Kode: XXX)."

## 3. Aturan Unauthorized & Expired Token (401)
- **Definisi**: Terjadi ketika Sanctum token kedaluwarsa atau ditarik (revoked) oleh server.
- **Tindakan API**: Mengembalikan status `401` dengan pesan `{"message": "Unauthenticated."}`.
- **Tindakan Flutter**: 
  1. Interceptor menangkap error 401.
  2. Flutter langsung menghapus token dari `flutter_secure_storage`.
  3. Memunculkan dialog atau snackbar: "Sesi Anda telah habis. Silakan login kembali."
  4. Force redirect user ke `LoginScreen`.

## 4. Aturan Forbidden (403)
- **Definisi**: User mencoba mengakses data atau endpoint yang bukan haknya (misal Mahasiswa mencoba mengakses endpoint plotting Kaprodi).
- **Tindakan API**: Mengembalikan status `403` dengan pesan `{"message": "This action is unauthorized."}`.
- **Tindakan Flutter**: Tampilkan snackbar merah "Anda tidak memiliki akses ke halaman ini" dan tutup layar (pop) jika berbentuk dialog/halaman khusus.

## 5. Aturan Offline Connection (No Internet)
- **Deteksi**: Pengecekan sebelum request (menggunakan package `connectivity_plus`) atau dari tipe error koneksi pada HTTP Client (`DioExceptionType.connectionError`).
- **Tindakan Flutter**: 
  - Tampilkan halaman spesifik "Tidak Ada Koneksi Internet" jika sedang memuat halaman utama.
  - Tampilkan Snackbar "Koneksi terputus, pastikan internet Anda stabil" jika pengguna menekan tombol aksi (submit form).

## 6. Aturan Retry Request
- **Metode**: Menerapkan *Retry Interceptor* pada HTTP Client.
- **Kondisi**: Hanya melakukan retry pada error *Timeout* atau *5xx* (Server Error) dan HANYA untuk method `GET`.
- **Batas Retry**: Maksimal 3 kali percobaan ulang dengan *exponential backoff* (jeda waktu makin lama antar percobaan).
- **Pengecualian**: Jangan pernah melakukan otomatis retry pada request `POST`, `PUT`, `DELETE` untuk menghindari masalah duplikasi data.
