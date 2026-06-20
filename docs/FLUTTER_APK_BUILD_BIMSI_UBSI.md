# Panduan Build APK Flutter BIMSI UBSI

Langkah-langkah untuk mengemas *(compile)* aplikasi Flutter menjadi APK yang siap didistribusikan ke Mahasiswa, Dosen, Kaprodi, dan Admin.

## 1. Persiapan Base URL Production
Buka _file_ `frontend_flutter/lib/core/config/api_config.dart` dan arahkan URL ke backend Koyeb yang sudah ter-_deploy_.

```dart
class ApiConfig {
  // Ganti URL ini dengan Koyeb URL. Jangan gunakan localhost / 10.0.2.2.
  static const String baseUrl = 'https://[nama-aplikasi-koyeb].koyeb.app/api';
  static const String pusherKey = 'ISI_DENGAN_PUSHER_KEY_PRODUCTION';
  static const String pusherCluster = 'ap1';
}
```

## 2. Pengecekan Permission Android
Buka file `frontend_flutter/android/app/src/main/AndroidManifest.xml`.
Pastikan terdapat izin INTERNET di luar tag `<application>`:
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <!-- ... -->
```

## 3. Eksekusi Build APK
Buka terminal di dalam folder `frontend_flutter` dan jalankan perintah berikut secara berurutan:

```bash
# 1. Bersihkan cache build lama untuk menghindari error sisa file
flutter clean

# 2. Unduh ulang semua library dependencies (pubspec.yaml)
flutter pub get

# 3. Compile aplikasi Flutter menjadi APK (Mode Release = Lebih Cepat, Lebih Ringan)
flutter build apk --release
```

## 4. Output dan Distribusi
Jika build sukses, terminal akan menampilkan lokasi file APK Anda:
`✓ Built build\app\outputs\flutter-apk\app-release.apk`

- **Lokasi File:** `frontend_flutter/build/app/outputs/flutter-apk/app-release.apk`
- Ubah nama file menjadi `BIMSI_UBSI_v1.0.apk`.
- Kirimkan *file* ini ke _device_ Android tester (HP sesungguhnya) untuk UAT.

## 5. Checklist Testing Perangkat Asli (HP)
- [ ] Installasi tidak diblokir secara keras oleh Google Play Protect (walaupun mungkin muncul peringatan *Unrecognized Developer* karena belum masuk Play Store).
- [ ] _Icon App_ dan _App Name_ muncul dengan benar di App Drawer (bukan logo default Flutter).
- [ ] Login menggunakan paket data (Seluler) berhasil dilakukan.
- [ ] _Push Notification Firebase_ masuk ketika aplikasi ditutup (*Terminated*).

## Troubleshooting Umum
- **"Execution failed for task ':app:compileReleaseJavaWithJavac'"**: Pastikan versi Java / Gradle di PC *up-to-date*.
- **Aplikasi Crash Putih / Keluar Sendiri saat dibuka:** Gunakan `flutter logs` atau colok HP ke PC dan jalankan `flutter run --release` untuk membaca _error_ aslinya.
