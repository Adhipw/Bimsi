# Project Convention - BIMSI UBSI

## 1. Lingkungan Kerja & Environment
- **Aplikasi**: Flutter & Laravel di-*setup* secara lokal untuk masing-masing developer.
- **Environment Variables**: Semua API Key (Cloudinary, FCM, Pusher) dan credential Database harus diletakkan di file `.env`. Dilarang keras menaruh credential di dalam *source code* (hardcoded).
- **.gitignore**: Pastikan file `.env`, folder `vendor/`, `node_modules/`, `build/`, `.dart_tool/` masuk ke `.gitignore`.

## 2. Penamaan dan Standar Kode (Code Style)
- **Flutter (Dart)**: Ikuti standar resmi `Effective Dart`. Gunakan *linter* standar Flutter (`flutter_lints`).
- **Laravel (PHP)**: Ikuti standar PSR-12 untuk formatting kode. Penamaan *Table* menggunakan jamak bahasa inggris/indonesia dengan `snake_case` (misal: `users`, `bimbingans`). Nama *Model* menggunakan tunggal `PascalCase` (misal: `User`, `Bimbingan`).
- **REST API**: Endpoint menggunakan *kebab-case* dan merepresentasikan *resource* (misal: `/api/v1/pengajuan-bimbingan`).

## 3. Komunikasi Tim & Task Management
- Semua *bug* dan fitur baru harus dicatat sebagai "Issue" atau "Card" pada platform manajemen tugas (misal: Trello/Jira/GitHub Projects).
- Setiap *commit* atau *Pull Request* disarankan menyebutkan ID Task (contoh: `feat: add chat UI (Task-12)`).

## 4. Rilis dan Versi (Versioning)
- Gunakan standar *Semantic Versioning* (SemVer) dengan format `MAJOR.MINOR.PATCH` (contoh: `v1.0.0`).
- Major (1.x.x): Perubahan besar dan tidak kompatibel (Breaking Changes).
- Minor (x.1.x): Penambahan fitur baru yang backward-compatible.
- Patch (x.x.1): Perbaikan bug minor.
