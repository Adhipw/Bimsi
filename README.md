# Bimsi UBSI

Bimsi UBSI adalah aplikasi Bimbingan Skripsi Online Universitas Bina Sarana Informatika untuk demo mata kuliah Teknologi Web Service.

Tagline: Bimbingan skripsi lebih terarah, terdokumentasi, dan terintegrasi.

## Struktur Monorepo

```text
bimsi-ubsi-flutter/
├── frontend_flutter/
├── backend/
├── docs/
├── README.md
├── AGENT.md
└── package.json
```

## Arsitektur Wajib

```text
Flutter Web
-> Dio API Client
-> Backend REST API /api/v1
-> Backend Controller
-> Backend Service Layer
-> Backend Repository Layer
-> Drizzle ORM
-> Supabase PostgreSQL
```

Frontend Flutter tidak boleh query database langsung untuk fitur utama. Upload dokumen fitur utama juga wajib melalui backend.

## Folder

- `frontend_flutter/`: aplikasi Flutter Web.
- `backend/`: backend REST API NestJS.
- `docs/`: dokumentasi product, arsitektur, API, database, security, test, dan manual.

## Command Root

```bash
npm run dev:backend
npm run build:backend
npm run flutter:get
npm run flutter:analyze
npm run flutter:test
npm run flutter:build:web
npm run check
```

Catatan: command Flutter/backend baru bisa berjalan setelah project masing-masing dibuat pada step berikutnya.
