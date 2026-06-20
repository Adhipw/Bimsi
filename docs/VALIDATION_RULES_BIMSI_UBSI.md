# Validation Rules - BIMSI UBSI

## 1. Validasi Form Client-Side (Flutter)
Semua form harus divalidasi di aplikasi sebelum data dikirim ke server. Aturannya:
- **Email**: Harus sesuai format standar email (`user@domain.com`).
- **Password**: Minimal 8 karakter.
- **Input Teks Biasa (Judul, Nama)**: Tidak boleh kosong, dan harus di-trim (hapus spasi depan-belakang).
- **Upload File**: Harus difilter berdasarkan ekstensi yang diizinkan (misal `.pdf` saja) dan batas ukuran file maksimal 5MB sebelum diunggah.
- **Tindakan**: Jika gagal, beri pesan berwarna merah di bawah kolom isian (helper text error) dan cegah tombol "Submit" ditekan.

## 2. Validasi Form Server-Side (Laravel)
Server merupakan lapisan pertahanan utama. Meskipun client sudah memvalidasi, server harus tetap mengecek ulang seluruh input.
- Menggunakan fitur `FormRequest` di Laravel.
- **Contoh Aturan**:
  - `email`: `required|email|unique:users,email`
  - `password`: `required|min:8`
  - `dokumen`: `required|mimes:pdf|max:5120`
  - `judul`: `required|string|max:255`
- **Tindakan**: Jika gagal, batalkan proses dan kembalikan status HTTP 422 dengan pesan JSON terstruktur.

## 3. Format Response Error Validasi (422)
Setiap kali terjadi error HTTP 422, Laravel akan mengembalikan respons JSON standar berikut:
```json
{
  "message": "The given data was invalid.",
  "errors": {
    "email": ["Email format tidak valid.", "Email sudah terdaftar."],
    "judul": ["Judul skripsi wajib diisi."]
  }
}
```

## 4. Penanganan Response 422 di Flutter
- Tangkap HTTP 422 Exception secara spesifik.
- Lakukan parsing terhadap object JSON `errors` yang dikembalikan.
- Lakukan pemetaan (mapping) daftar pesan error ke variabel state masing-masing input.
- Tampilkan error tersebut secara dinamis (biasanya berupa teks merah) tepat di bawah `TextField` atau komponen form yang bermasalah.
