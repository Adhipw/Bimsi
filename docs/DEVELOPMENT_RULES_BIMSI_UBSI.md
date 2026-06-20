# Development Rules - BIMSI UBSI

## 1. Struktur Folder Flutter
Terapkan *Feature-First* atau *Clean Architecture* dasar.
```text
lib/
├── core/
│   ├── network/       # Konfigurasi Dio, interceptor
│   ├── theme/         # UI/UX design tokens
│   ├── utils/         # Helper functions
├── features/
│   ├── auth/          # Modul autentikasi
│   ├── bimbingan/     # Modul bimbingan
│   └── dashboard/     # Modul dashboard
```

## 2. Penamaan File
- Gunakan `snake_case` untuk nama file (contoh: `login_screen.dart`, `user_model.dart`).
- Tambahkan suffix sesuai jenis file: `_screen`, `_widget`, `_model`, `_controller`, `_service`.

## 3. Penamaan Class
- Gunakan `PascalCase` untuk nama class (contoh: `LoginScreen`, `UserModel`).
- Gunakan `camelCase` untuk nama variabel dan fungsi (contoh: `fetchUserData()`, `isLoading`).

## 4. Penggunaan Service
- Ekstraksi logika bisnis dan panggilan API ke dalam class `Service` atau `Repository`.
- Jangan menulis logika API langsung di dalam Widget atau Screen (Presentation layer).

## 5. Penggunaan Model
- Gunakan class `Model` untuk memetakan JSON response ke objek Dart.
- Sangat disarankan menggunakan package `json_serializable` atau `freezed` untuk mencegah kesalahan pengetikan saat mem-parsing JSON.

## 6. Penggunaan API Client
- Gunakan `Dio` sebagai HTTP client utama.
- Konfigurasi Base URL secara global (menggunakan `.env`).
- Gunakan *Interceptor* untuk otomatis menyisipkan header Authorization: Bearer Token.

## 7. Error Handling
- Tangkap semua HTTP exception secara global dengan try-catch.
- Terjemahkan status code (seperti 401, 403, 404, 500) menjadi pesan yang ramah pengguna.
- Tampilkan informasi error kepada user melalui Custom Snackbar, Toast, atau Dialog alert.

## 8. Validasi Form
- Terapkan validasi form pada sisi client sebelum submit (contoh: panjang karakter, format email yang valid).
- Proses response error HTTP 422 dari server dan pasangkan pesan error validasi ke bawah TextField yang bersangkutan secara dinamis.

## 9. State Management
- Gunakan `Riverpod` (disarankan) atau pola reaktif lainnya secara seragam.
- Bedakan antara UI/Local state dengan Application/Data state.
- Hindari penggunaan fungsi `setState` pada logika asinkronus yang rentan menyebabkan memory leak.

## 10. Komentar Kode
- Gunakan `///` (doc comments) pada metode atau fungsi kompleks, class utama, dan property.
- Gunakan bahasa yang jelas dan konsisten dalam komentar.

## 11. Clean Code
- Terapkan prinsip SOLID sebisa mungkin.
- Pecah komponen UI (Widget) yang besar dan rumit menjadi widget-widget yang lebih kecil (Custom Widgets).
- Jangan me-hardcode warna dan ukuran; gunakan referensi dari theme global aplikasi.

## 12. Keamanan Token
- Token login tidak boleh disimpan pada SharedPreferences biasa.
- Simpan bearer token menggunakan package `flutter_secure_storage` untuk menjamin token terenkripsi.
- Berikan penanganan yang membuang token dari storage jika API merespon 401 Unauthorized secara konsisten.

## 13. Upload File
- Gunakan tipe `MultipartFile` ketika berinteraksi dengan upload API.
- Proses pengunggahan gambar atau dokumen secara end-to-end harus selalu melalui REST API Laravel (backend) yang selanjutnya diteruskan ke Cloudinary. Flutter dilarang keras mengunggah secara *direct*.

## 14. Realtime
- Gunakan library standar `pusher_channels_flutter`.
- Buka koneksi realtime ketika dibutuhkan dan selalu panggil metode *unsubscribe* channel ketika widget dihancurkan (dispose).
- Berikan otorisasi backend jika subscribe ke private channel.

## 15. Testing
- Tulis *Unit Test* pada file Model, Helper, Service, dan Utils.
- Buat *Widget Test* untuk memvalidasi alur dan keberadaan elemen-elemen kritikal (seperti tombol Submit/Login).
