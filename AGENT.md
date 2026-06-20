Bisa. Ini saya gabungkan jadi **1 paket prompt final** yang rapi. Tinggal kamu salin, lalu pakai per bagian sesuai urutan.

# PAKET PROMPT FINAL BIMSI UBSI

## MASTER RULE BIMSI UBSI

Gunakan aturan ini untuk seluruh pengerjaan aplikasi BIMSI UBSI.

Nama aplikasi:
BIMSI UBSI

Deskripsi:
Aplikasi mobile bimbingan skripsi Universitas Bina Sarana Informatika.

Role:

1. super_admin
2. admin
3. kaprodi
4. dosen
5. mahasiswa

Stack:

1. Flutter Android
2. Laravel REST API
3. PostgreSQL Aiven
4. pgAdmin 4
5. Laravel Sanctum
6. Pusher Channels
7. Firebase Cloud Messaging
8. Cloudinary
9. Koyeb
10. APK Android

Aturan utama:

1. Flutter tidak boleh langsung konek ke database.
2. Semua data Flutter harus lewat Laravel REST API.
3. Database utama menggunakan PostgreSQL Aiven.
4. pgAdmin 4 hanya untuk mengelola PostgreSQL.
5. Realtime hanya menggunakan Pusher Channels.
6. Push notification hanya menggunakan Firebase Cloud Messaging.
7. Upload dokumen harus lewat Laravel API lalu Cloudinary.
8. URL file Cloudinary disimpan di PostgreSQL.
9. Backend dideploy ke Koyeb.
10. Output aplikasi adalah APK Android.
11. Jangan menghapus role.
12. Jangan mengubah stack.
13. Jangan membuat fitur di luar dokumen.
14. Jangan menyederhanakan alur.
15. Kerjakan hanya sesuai step yang diminta.

Setiap step wajib mengikuti dokumen:

1. docs/BRD_BIMSI_UBSI.md
2. docs/PRD_BIMSI_UBSI.md
3. docs/SRS_BIMSI_UBSI.md
4. docs/ARS_BIMSI_UBSI.md
5. docs/API_SPECIFICATION_BIMSI_UBSI.md
6. docs/UI_UX_DESIGN_SYSTEM_BIMSI_UBSI.md
7. docs/DEVELOPMENT_RULES_BIMSI_UBSI.md
8. docs/ROLE_PERMISSION_MATRIX_BIMSI_UBSI.md
9. docs/ERROR_HANDLING_STANDARD_BIMSI_UBSI.md
10. docs/VALIDATION_RULES_BIMSI_UBSI.md
11. docs/PROJECT_CONVENTION_BIMSI_UBSI.md

# BAGIAN A — DOKUMEN AWAL

## PROMPT A1 — BRD, PRD, SRS, ARS

Kerjakan:

1. Buat BRD aplikasi BIMSI UBSI.
2. Buat PRD aplikasi BIMSI UBSI.
3. Buat SRS aplikasi BIMSI UBSI.
4. Buat ARS aplikasi BIMSI UBSI.
5. Simpan semua dokumen ke folder docs.
6. Jadikan dokumen sebagai acuan utama project.

Output wajib:

1. docs/BRD_BIMSI_UBSI.md
2. docs/PRD_BIMSI_UBSI.md
3. docs/SRS_BIMSI_UBSI.md
4. docs/ARS_BIMSI_UBSI.md

BRD wajib memuat:

1. Latar belakang bisnis
2. Masalah bisnis
3. Tujuan bisnis
4. Stakeholder
5. Proses bisnis utama
6. Role pengguna
7. Manfaat sistem
8. Batasan bisnis
9. Risiko bisnis
10. Kriteria keberhasilan

PRD wajib memuat:

1. Nama produk
2. Visi produk
3. Target pengguna
4. Scope produk
5. Fitur per role
6. User flow utama
7. Prioritas fitur
8. Batasan produk
9. Acceptance criteria
10. Roadmap pengembangan

SRS wajib memuat:

1. Kebutuhan fungsional
2. Kebutuhan non-fungsional
3. Kebutuhan autentikasi
4. Kebutuhan role dan permission
5. Kebutuhan API
6. Kebutuhan database
7. Kebutuhan realtime
8. Kebutuhan notification
9. Kebutuhan upload dokumen
10. Kebutuhan laporan
11. Kebutuhan audit log
12. Error handling

ARS wajib memuat:

1. Arsitektur sistem
2. Arsitektur Flutter
3. Arsitektur Laravel
4. Arsitektur database
5. Arsitektur realtime
6. Arsitektur push notification
7. Arsitektur file storage
8. Arsitektur deployment
9. Struktur folder Flutter
10. Struktur folder Laravel
11. Alur data
12. Keamanan sistem

Batasan:

1. Jangan buat kode.
2. Jangan buat backend.
3. Jangan buat database.
4. Fokus dokumen rancangan.

## PROMPT A2 — API SPEC, UI/UX, DEVELOPMENT RULES

Kerjakan:

1. Buat API Specification.
2. Buat UI/UX Design System.
3. Buat Development Rules.
4. Simpan semua dokumen ke folder docs.

Output wajib:

1. docs/API_SPECIFICATION_BIMSI_UBSI.md
2. docs/UI_UX_DESIGN_SYSTEM_BIMSI_UBSI.md
3. docs/DEVELOPMENT_RULES_BIMSI_UBSI.md

API Specification wajib memuat:

1. Endpoint semua role
2. Method endpoint
3. Role access endpoint
4. Request field
5. Response field
6. Status code
7. Error response
8. Format JSON
9. Pagination
10. Search dan filter

UI/UX Design System wajib memuat:

1. Warna utama
2. Warna status
3. Tipografi
4. Spacing
5. Button style
6. Text field style
7. Card style
8. App bar style
9. Empty state
10. Loading state
11. Error message
12. Dashboard per role
13. Form style
14. List style

Development Rules wajib memuat:

1. Struktur folder Flutter
2. Penamaan file
3. Penamaan class
4. Penggunaan service
5. Penggunaan model
6. Penggunaan API client
7. Error handling
8. Validasi form
9. State management
10. Komentar kode
11. Clean code
12. Keamanan token
13. Upload file
14. Realtime
15. Testing

Batasan:

1. Jangan buat kode.
2. Jangan ubah stack.
3. Fokus aturan teknis.

## PROMPT A3 — ERD, USE CASE, FLOW

Kerjakan:

1. Buat ERD BIMSI UBSI.
2. Buat relasi antar tabel.
3. Buat use case per role.
4. Buat activity flow proses utama.
5. Buat sequence flow Flutter ke Laravel.
6. Buat flow realtime Pusher.
7. Buat flow upload Cloudinary.
8. Buat flow push notification Firebase.

Output wajib:

1. docs/ERD_BIMSI_UBSI.md
2. docs/USE_CASE_BIMSI_UBSI.md
3. docs/ACTIVITY_FLOW_BIMSI_UBSI.md
4. docs/SEQUENCE_FLOW_BIMSI_UBSI.md

Batasan:

1. Jangan buat kode.
2. Jangan ubah stack.
3. Fokus diagram dan alur.

## PROMPT A4 — ROLE PERMISSION MATRIX

Kerjakan:

1. Buat matrix hak akses 5 role.
2. Tentukan fitur per role.
3. Tentukan endpoint per role.
4. Tentukan halaman Flutter per role.
5. Tentukan aksi CRUD per role.
6. Tentukan batasan akses data per role.

Output wajib:

1. docs/ROLE_PERMISSION_MATRIX_BIMSI_UBSI.md

Batasan:

1. Jangan buat kode.
2. Jangan ubah role.
3. Fokus hak akses.

## PROMPT A5 — ERROR, VALIDATION, EMPTY STATE

Kerjakan:

1. Buat standar error code API.
2. Buat standar pesan error Flutter.
3. Buat aturan validasi form.
4. Buat aturan empty state.
5. Buat aturan loading state.
6. Buat aturan unauthorized.
7. Buat aturan forbidden.
8. Buat aturan expired token.
9. Buat aturan offline connection.
10. Buat aturan retry request.

Output wajib:

1. docs/ERROR_HANDLING_STANDARD_BIMSI_UBSI.md
2. docs/VALIDATION_RULES_BIMSI_UBSI.md
3. docs/EMPTY_LOADING_STATE_BIMSI_UBSI.md

Batasan:

1. Jangan buat kode.
2. Fokus error, validasi, dan state UI.

## PROMPT A6 — GIT, CONVENTION, DEMO DATA, SECURITY

Kerjakan:

1. Buat Git workflow.
2. Buat project convention.
3. Buat rancangan data dummy.
4. Buat aturan seeding.
5. Buat security checklist.
6. Buat privacy rules.
7. Buat backup dan restore rules.
8. Buat performance rules.
9. Buat monitoring rules.
10. Buat maintenance rules.

Output wajib:

1. docs/GIT_WORKFLOW_BIMSI_UBSI.md
2. docs/PROJECT_CONVENTION_BIMSI_UBSI.md
3. docs/DEMO_DATA_BIMSI_UBSI.md
4. docs/SEEDING_RULES_BIMSI_UBSI.md
5. docs/SECURITY_CHECKLIST_BIMSI_UBSI.md
6. docs/PRIVACY_RULES_BIMSI_UBSI.md
7. docs/BACKUP_RESTORE_RULES_BIMSI_UBSI.md
8. docs/PERFORMANCE_RULES_BIMSI_UBSI.md
9. docs/MONITORING_RULES_BIMSI_UBSI.md
10. docs/MAINTENANCE_RULES_BIMSI_UBSI.md

Batasan:

1. Jangan buat kode.
2. Jangan ubah stack.
3. Fokus aturan kerja project.

# BAGIAN B — CODING STEP-BY-STEP

## PROMPT B1 — SETUP STRUKTUR FLUTTER

Kerjakan:

1. Buat struktur folder Flutter feature-first.
2. Buat main.dart.
3. Buat app.dart.
4. Buat folder core.
5. Buat folder features.
6. Buat konfigurasi theme.
7. Buat konfigurasi routes.
8. Buat widget reusable dasar.
9. Pastikan aplikasi bisa run tanpa error.

Output wajib:

1. main.dart
2. app.dart
3. core/theme/app_theme.dart
4. core/routes/app_routes.dart
5. core/config/api_config.dart
6. core/widgets/custom_button.dart
7. core/widgets/custom_text_field.dart
8. core/widgets/menu_card.dart
9. core/widgets/loading_widget.dart
10. core/widgets/empty_state_widget.dart

Batasan:

1. Jangan buat backend.
2. Jangan buat fitur bimbingan.
3. Fokus struktur Flutter.

## PROMPT B2 — AUTH, LOGIN, DASHBOARD ROLE

Kerjakan:

1. Buat fitur login.
2. Buat simulasi login 5 role.
3. Buat UserModel.
4. Buat AuthService.
5. Buat StorageHelper.
6. Simpan token dummy.
7. Simpan role.
8. Buat DashboardRouterPage.
9. Arahkan user ke dashboard sesuai role.
10. Buat logout.

Output wajib:

1. features/auth/models/user_model.dart
2. features/auth/services/auth_service.dart
3. features/auth/pages/login_page.dart
4. features/dashboard/pages/dashboard_router_page.dart
5. features/super_admin/pages/super_admin_dashboard_page.dart
6. features/admin/pages/admin_dashboard_page.dart
7. features/kaprodi/pages/kaprodi_dashboard_page.dart
8. features/dosen/pages/dosen_dashboard_page.dart
9. features/mahasiswa/pages/mahasiswa_dashboard_page.dart
10. core/helpers/storage_helper.dart

Batasan:

1. Jangan hubungkan ke API.
2. Jangan buat CRUD.
3. Fokus auth simulasi.

## PROMPT B3 — SETUP BACKEND LARAVEL

Kerjakan:

1. Setup Laravel REST API.
2. Install Laravel Sanctum.
3. Konfigurasi PostgreSQL.
4. Buat AuthController.
5. Buat RoleMiddleware.
6. Buat route auth.
7. Buat seeder role.
8. Buat seeder user demo.
9. Buat response JSON konsisten.
10. Pastikan login bisa dites di Postman.

Endpoint wajib:

1. POST /api/login
2. POST /api/logout
3. GET /api/profile

Output wajib:

1. AuthController
2. RoleMiddleware
3. routes/api.php
4. UserSeeder
5. RoleSeeder
6. Konfigurasi Sanctum

Batasan:

1. Jangan buat semua fitur.
2. Jangan buat realtime.
3. Fokus auth backend.

## PROMPT B4 — DATABASE MIGRATION

Kerjakan:

1. Buat migration PostgreSQL.
2. Buat semua tabel utama.
3. Buat foreign key.
4. Buat relasi model.
5. Buat seeder data awal.
6. Pastikan migration berjalan tanpa error.

Tabel wajib:

1. users
2. roles
3. permissions
4. role_permissions
5. program_studi
6. tahun_akademik
7. semester
8. kelas
9. mahasiswa
10. dosen
11. bidang_keahlian
12. dosen_bidang_keahlian
13. periode_skripsi
14. pengajuan_judul
15. riwayat_pengajuan_judul
16. pembimbing
17. perubahan_judul
18. pergantian_pembimbing
19. slot_bimbingan
20. jadwal_bimbingan
21. riwayat_bimbingan
22. dokumen_skripsi
23. versi_dokumen
24. review_dokumen
25. progress_skripsi
26. notifikasi
27. fcm_tokens
28. audit_logs
29. laporan_export

Output wajib:

1. Migration semua tabel
2. Model semua tabel
3. Relasi model dasar
4. Seeder data awal

Batasan:

1. Jangan buat controller fitur.
2. Fokus database.

## PROMPT B5 — HUBUNGKAN FLUTTER KE API LOGIN

Kerjakan:

1. Ubah login simulasi menjadi login API.
2. Buat ApiClient.
3. Buat base URL config.
4. Kirim email dan password ke API.
5. Simpan token API.
6. Simpan data user API.
7. Arahkan dashboard sesuai role.
8. Buat logout API.
9. Buat profile API.
10. Tambahkan error handling.

Output wajib:

1. core/services/api_client.dart
2. core/config/api_config.dart
3. Update AuthService
4. Update LoginPage
5. Update DashboardRouterPage

Batasan:

1. Jangan buat fitur lain.
2. Fokus koneksi login.

## PROMPT B6 — MASTER DATA SUPER ADMIN DAN ADMIN

Kerjakan:

1. Buat CRUD program studi.
2. Buat CRUD tahun akademik.
3. Buat CRUD semester.
4. Buat CRUD user.
5. Buat CRUD mahasiswa.
6. Buat CRUD dosen.
7. Buat CRUD kelas.
8. Batasi akses berdasarkan role.
9. Buat halaman Flutter.
10. Buat endpoint Laravel.

Output wajib:

1. Controller Laravel
2. Route API
3. Model Flutter
4. Service Flutter
5. List page
6. Create page
7. Edit page
8. Detail page

Batasan:

1. Jangan buat pengajuan judul.
2. Fokus master data.

## PROMPT B7 — PENGAJUAN JUDUL MAHASISWA

Kerjakan:

1. Buat fitur pengajuan judul.
2. Buat form pengajuan judul.
3. Buat halaman status judul.
4. Buat fitur revisi judul.
5. Simpan data ke backend.
6. Ambil data dari backend.
7. Tambahkan validasi input.
8. Gunakan status pending, disetujui, ditolak, revisi.

Output wajib:

1. PengajuanJudulModel
2. PengajuanJudulService
3. MahasiswaPengajuanJudulPage
4. MahasiswaStatusJudulPage
5. Controller Laravel
6. Route API
7. Validasi request Laravel

Batasan:

1. Jangan buat validasi Kaprodi.
2. Fokus pengajuan judul mahasiswa.

## PROMPT B8 — VALIDASI JUDUL KAPRODI

Kerjakan:

1. Buat list pengajuan judul Kaprodi.
2. Buat detail pengajuan judul.
3. Buat approve judul.
4. Buat reject judul.
5. Buat catatan Kaprodi.
6. Buat cek kemiripan judul sederhana.
7. Update status pengajuan.
8. Kirim notifikasi internal ke mahasiswa.

Output wajib:

1. KaprodiListPengajuanJudulPage
2. KaprodiDetailPengajuanJudulPage
3. Endpoint approve
4. Endpoint reject
5. Endpoint cek kemiripan
6. Update service Flutter
7. Update notifikasi

Batasan:

1. Jangan buat pembimbing.
2. Fokus validasi judul.

## PROMPT B9 — PENENTUAN PEMBIMBING

Kerjakan:

1. Buat fitur penentuan pembimbing.
2. Tampilkan mahasiswa dengan judul disetujui.
3. Tampilkan daftar dosen.
4. Tampilkan kuota dosen.
5. Tampilkan bidang keahlian dosen.
6. Simpan data pembimbing.
7. Tampilkan pembimbing di mahasiswa.
8. Tampilkan mahasiswa bimbingan di dosen.

Output wajib:

1. KaprodiTentukanPembimbingPage
2. MahasiswaPembimbingPage
3. DosenMahasiswaBimbinganPage
4. PembimbingModel
5. PembimbingService
6. Controller Laravel
7. Route API

Batasan:

1. Jangan buat jadwal.
2. Fokus pembimbing.

## PROMPT B10 — SLOT DAN JADWAL BIMBINGAN

Kerjakan:

1. Buat slot bimbingan dosen.
2. Buat pengajuan jadwal mahasiswa.
3. Buat approve jadwal dosen.
4. Buat reject jadwal dosen.
5. Buat batal jadwal mahasiswa.
6. Buat anti bentrok jadwal.
7. Buat validasi kuota slot.
8. Tampilkan status jadwal.

Output wajib:

1. SlotBimbinganModel
2. JadwalBimbinganModel
3. SlotBimbinganService
4. JadwalBimbinganService
5. DosenSlotBimbinganPage
6. MahasiswaAjukanJadwalPage
7. DosenJadwalBimbinganPage
8. MahasiswaJadwalBimbinganPage
9. Controller Laravel
10. Route API

Batasan:

1. Jangan buat dokumen.
2. Fokus jadwal.

## PROMPT B11 — RIWAYAT BIMBINGAN DAN REVISI

Kerjakan:

1. Buat input riwayat bimbingan oleh dosen.
2. Buat catatan revisi.
3. Buat status revisi.
4. Tampilkan riwayat di mahasiswa.
5. Tampilkan riwayat di dosen.
6. Hubungkan riwayat dengan jadwal.
7. Validasi jadwal sebelum input riwayat.

Output wajib:

1. RiwayatBimbinganModel
2. RiwayatBimbinganService
3. DosenInputRiwayatBimbinganPage
4. MahasiswaRiwayatBimbinganPage
5. DosenRiwayatBimbinganPage
6. Controller Laravel
7. Route API

Batasan:

1. Jangan buat upload dokumen.
2. Fokus riwayat dan revisi.

## PROMPT B12 — UPLOAD DAN REVIEW DOKUMEN

Kerjakan:

1. Buat upload dokumen mahasiswa.
2. Gunakan file_picker.
3. Gunakan multipart request.
4. Upload file ke Laravel.
5. Laravel upload ke Cloudinary.
6. Simpan URL file ke PostgreSQL.
7. Buat versi dokumen.
8. Buat review dokumen dosen.
9. Buat status dokumen.
10. Tampilkan dokumen di mahasiswa dan dosen.

Output wajib:

1. DokumenSkripsiModel
2. VersiDokumenModel
3. ReviewDokumenModel
4. DokumenService
5. MahasiswaUploadDokumenPage
6. MahasiswaListDokumenPage
7. DosenReviewDokumenPage
8. UploadController Laravel
9. CloudinaryService Laravel
10. Route API

Batasan:

1. Jangan simpan file di database.
2. Flutter jangan langsung ke Cloudinary.
3. Semua upload lewat Laravel API.

## PROMPT B13 — PROGRESS SKRIPSI

Kerjakan:

1. Buat progress skripsi per BAB.
2. Buat status progress BAB.
3. Hitung persentase progress.
4. Update progress setelah review dosen.
5. Tampilkan progress di mahasiswa.
6. Tampilkan progress di dosen.
7. Tampilkan monitoring progress di Kaprodi.

Output wajib:

1. ProgressSkripsiModel
2. ProgressSkripsiService
3. MahasiswaProgressPage
4. DosenProgressMahasiswaPage
5. KaprodiMonitoringProgressPage
6. Controller Laravel
7. Route API

Batasan:

1. Jangan buat laporan.
2. Fokus progress.

## PROMPT B14 — REALTIME PUSHER

Kerjakan:

1. Setup Pusher Laravel.
2. Setup Pusher Flutter.
3. Buat RealtimeService Flutter.
4. Buat event Laravel.
5. Buat private channel.
6. Broadcast event saat data penting berubah.
7. Flutter listen event.
8. Saat event diterima, refresh data dari API.
9. Jangan jadikan Pusher sumber data utama.

Event wajib:

1. JudulDiajukanEvent
2. JudulDisetujuiEvent
3. JudulDitolakEvent
4. PembimbingDitentukanEvent
5. JadwalDiajukanEvent
6. JadwalDisetujuiEvent
7. JadwalDitolakEvent
8. BimbinganDicatatEvent
9. DokumenDiuploadEvent
10. DokumenDireviewEvent
11. ProgressBabDiubahEvent
12. NotifikasiBaruEvent

Output wajib:

1. Laravel event classes
2. Laravel channel config
3. RealtimeService Flutter
4. Subscribe user channel
5. Subscribe role channel
6. Event listener Flutter

Batasan:

1. Pusher hanya trigger update.
2. Data tetap dari API.

## PROMPT B15 — FIREBASE PUSH NOTIFICATION

Kerjakan:

1. Setup Firebase Flutter.
2. Setup Firebase Cloud Messaging.
3. Ambil FCM token device.
4. Kirim FCM token ke Laravel.
5. Simpan token ke tabel fcm_tokens.
6. Buat service Laravel untuk kirim push notification.
7. Kirim push notification untuk perubahan penting.
8. Tangani foreground notification.
9. Tangani background notification.

Output wajib:

1. NotificationService Flutter
2. Endpoint simpan FCM token
3. FcmToken model Laravel
4. FirebaseNotificationService Laravel
5. Handler foreground
6. Handler background

Batasan:

1. Jangan buat chat.
2. Firebase hanya untuk push notification.

## PROMPT B16 — LAPORAN DAN AUDIT LOG

Kerjakan:

1. Buat laporan Admin.
2. Buat laporan Kaprodi.
3. Buat filter laporan.
4. Buat export PDF.
5. Buat export Excel.
6. Buat audit log otomatis.
7. Catat aktivitas penting.
8. Tampilkan audit log untuk Super Admin.

Laporan wajib:

1. Mahasiswa skripsi
2. Dosen pembimbing
3. Pengajuan judul
4. Jadwal bimbingan
5. Riwayat bimbingan
6. Progress skripsi

Output wajib:

1. LaporanService Flutter
2. Laporan pages Flutter
3. AuditLogService Laravel
4. LaporanController Laravel
5. AuditLogController Laravel
6. Route API

Batasan:

1. Jangan tambah fitur lain.
2. Fokus laporan dan audit.

# BAGIAN C — TESTING, DEPLOYMENT, DEBUGGING, FINAL REVIEW

## PROMPT C1 — TESTING DAN QUALITY CHECK

Kerjakan:

1. Buat testing checklist Flutter.
2. Buat testing checklist Laravel API.
3. Buat testing checklist PostgreSQL.
4. Buat testing checklist Pusher.
5. Buat testing checklist Firebase.
6. Buat testing checklist Cloudinary.
7. Buat testing checklist Koyeb.
8. Buat skenario testing semua role.
9. Buat skenario testing semua fitur utama.
10. Buat daftar bug umum.

Output wajib:

1. docs/TESTING_CHECKLIST_BIMSI_UBSI.md
2. docs/BUG_CHECKLIST_BIMSI_UBSI.md

Batasan:

1. Jangan ubah fitur.
2. Fokus testing.

## PROMPT C2 — API TESTING COLLECTION

Kerjakan:

1. Buat daftar test endpoint API.
2. Buat urutan testing endpoint.
3. Buat test case auth.
4. Buat test case master data.
5. Buat test case pengajuan judul.
6. Buat test case validasi Kaprodi.
7. Buat test case pembimbing.
8. Buat test case jadwal bimbingan.
9. Buat test case dokumen.
10. Buat test case progress.
11. Buat test case notifikasi.
12. Buat test case laporan.
13. Buat test case audit log.

Output wajib:

1. docs/API_TESTING_COLLECTION_BIMSI_UBSI.md
2. docs/API_TESTING_ORDER_BIMSI_UBSI.md

Batasan:

1. Jangan ubah endpoint.
2. Fokus testing API.

## PROMPT C3 — USER ACCEPTANCE TESTING

Kerjakan:

1. Buat skenario UAT Super Admin.
2. Buat skenario UAT Admin.
3. Buat skenario UAT Kaprodi.
4. Buat skenario UAT Dosen.
5. Buat skenario UAT Mahasiswa.
6. Buat kriteria berhasil.
7. Buat tabel pass/fail.
8. Buat catatan perbaikan.

Output wajib:

1. docs/UAT_BIMSI_UBSI.md

Batasan:

1. Jangan ubah fitur.
2. Fokus UAT.

## PROMPT C4 — SECURITY TESTING

Kerjakan:

1. Buat skenario testing login.
2. Buat skenario testing role permission.
3. Buat skenario testing unauthorized access.
4. Buat skenario testing forbidden access.
5. Buat skenario testing expired token.
6. Buat skenario testing upload file berbahaya.
7. Buat skenario testing file terlalu besar.
8. Buat skenario testing akses data antar role.
9. Buat skenario testing endpoint tanpa token.
10. Buat skenario testing input tidak valid.

Output wajib:

1. docs/SECURITY_TESTING_BIMSI_UBSI.md

Batasan:

1. Jangan buat kode.
2. Fokus security testing.

## PROMPT C5 — PERFORMANCE TESTING

Kerjakan:

1. Buat skenario performance testing Flutter.
2. Buat skenario performance testing API.
3. Buat skenario performance testing query database.
4. Buat skenario testing pagination.
5. Buat skenario testing upload dokumen.
6. Buat skenario testing realtime event.
7. Buat skenario testing push notification.
8. Buat target response API.
9. Buat target loading halaman.
10. Buat daftar optimasi jika performa buruk.

Output wajib:

1. docs/PERFORMANCE_TESTING_BIMSI_UBSI.md

Batasan:

1. Jangan ubah stack.
2. Fokus performance testing.

## PROMPT C6 — DEPLOYMENT BACKEND KOYEB

Kerjakan:

1. Siapkan Laravel untuk deployment Koyeb.
2. Pastikan env variable siap.
3. Push backend ke GitHub.
4. Deploy backend ke Koyeb.
5. Hubungkan backend ke PostgreSQL Aiven.
6. Hubungkan backend ke Pusher.
7. Hubungkan backend ke Cloudinary.
8. Hubungkan backend ke Firebase.
9. Jalankan migration production.
10. Test endpoint login production.

Output wajib:

1. File konfigurasi deployment
2. Daftar env variable
3. Command deployment
4. Cara run migration production
5. Checklist endpoint production

Batasan:

1. Jangan deploy Flutter.
2. Backend harus menghasilkan URL API online.

## PROMPT C7 — BUILD APK FLUTTER

Kerjakan:

1. Ganti baseUrl Flutter ke URL API Koyeb.
2. Tambahkan permission INTERNET.
3. Pastikan konfigurasi Firebase Android benar.
4. Jalankan flutter clean.
5. Jalankan flutter pub get.
6. Jalankan flutter build apk --release.
7. Pastikan APK berhasil dibuat.
8. Pastikan APK bisa login dari HP lain.
9. Test semua role.

Output wajib:

1. APK release
2. Base URL production
3. Checklist testing HP
4. Catatan error jika ada

Batasan:

1. Jangan pakai localhost.
2. Jangan pakai IP laptop untuk production.
3. APK harus konek ke backend online.

## PROMPT C8 — DEMO FLOW DAN PRESENTASI

Kerjakan:

1. Buat alur demo aplikasi.
2. Buat urutan login setiap role.
3. Buat data demo setiap role.
4. Buat skenario demo utama.
5. Buat skenario demo realtime.
6. Buat skenario demo upload dokumen.
7. Buat skenario demo push notification.
8. Buat checklist sebelum presentasi.
9. Buat risiko saat demo.
10. Buat solusi cepat jika demo error.

Output wajib:

1. docs/DEMO_FLOW_BIMSI_UBSI.md
2. docs/PRESENTATION_CHECKLIST_BIMSI_UBSI.md

Batasan:

1. Jangan tambah fitur.
2. Fokus demo dan presentasi.

## PROMPT C9 — ROLLBACK DAN RECOVERY PLAN

Kerjakan:

1. Buat rollback backend jika deploy gagal.
2. Buat rollback Flutter jika APK error.
3. Buat restore database jika migration gagal.
4. Buat recovery Cloudinary jika upload gagal.
5. Buat recovery Pusher jika realtime gagal.
6. Buat recovery Firebase jika notification gagal.
7. Buat checklist sebelum deploy.
8. Buat checklist setelah deploy.
9. Buat command pengecekan deploy gagal.
10. Buat tindakan cepat saat demo gagal.

Output wajib:

1. docs/ROLLBACK_PLAN_BIMSI_UBSI.md
2. docs/RECOVERY_PLAN_BIMSI_UBSI.md

Batasan:

1. Jangan tambah fitur.
2. Fokus rollback dan recovery.

## PROMPT C10 — DEBUGGING

Kerjakan debugging aplikasi BIMSI UBSI.

Langkah kerja:

1. Identifikasi error ada di Flutter, Laravel, PostgreSQL, Pusher, Firebase, Cloudinary, Koyeb, atau jaringan.
2. Baca pesan error.
3. Cek file terkait.
4. Cek log terkait.
5. Berikan penyebab paling mungkin.
6. Berikan solusi utama.
7. Berikan solusi cadangan.
8. Berikan cara memastikan error selesai.

Data error:

1. Bagian error:
2. Endpoint:
3. Method:
4. Status code:
5. Request body:
6. Response:
7. Log Laravel:
8. Debug console Flutter:
9. Screenshot error:

## PROMPT C11 — FINAL REVIEW PROJECT

Kerjakan:

1. Review struktur Flutter.
2. Review struktur Laravel.
3. Review migration database.
4. Review semua endpoint API.
5. Review role dan permission.
6. Review koneksi Flutter ke API.
7. Review realtime Pusher.
8. Review Firebase notification.
9. Review Cloudinary upload.
10. Review deployment Koyeb.
11. Review build APK.
12. Cari file tidak terpakai.
13. Cari kode duplikat.
14. Cari error handling belum lengkap.
15. Cari fitur yang belum sesuai dokumen.
16. Buat daftar perbaikan terakhir.

Output wajib:

1. Daftar file yang perlu diperbaiki
2. Daftar fitur yang belum selesai
3. Daftar bug potensial
4. Daftar endpoint yang belum dites
5. Daftar halaman Flutter yang belum lengkap
6. Rekomendasi final sebelum presentasi

Batasan:

1. Jangan tambah fitur baru.
2. Jangan ubah stack.
3. Fokus review akhir.

Urutan pakainya:

```text
1. Pakai MASTER RULE dulu sebagai aturan tetap.
2. Jalankan A1 sampai A6 untuk dokumen.
3. Jalankan B1 sampai B16 untuk coding.
4. Jalankan C1 sampai C11 untuk testing, deployment, debugging, dan final review.
```

Ini sudah versi gabungan yang paling rapi dan enak dipakai.

