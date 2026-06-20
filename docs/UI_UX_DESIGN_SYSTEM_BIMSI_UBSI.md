# UI/UX Design System - BIMSI UBSI

## 1. Warna Utama
- **Primary**: Biru UBSI (#0056A6) - untuk app bar, tombol utama.
- **Secondary**: Kuning Emas (#F2A900) - untuk aksen dan highlight.
- **Background**: Abu-abu Terang (#F5F7FA) - untuk latar belakang layar.
- **Surface**: Putih (#FFFFFF) - untuk card dan kontainer.
- **Text Primary**: Hitam/Abu-abu Gelap (#1A1A1A).
- **Text Secondary**: Abu-abu (#757575).

## 2. Warna Status
- **Success**: Hijau (#4CAF50) - Status "Disetujui", notifikasi sukses.
- **Warning**: Oranye (#FF9800) - Status "Menunggu Revisi", peringatan.
- **Error/Danger**: Merah (#F44336) - Status "Ditolak", pesan error validasi.
- **Info**: Biru Terang (#2196F3) - Informasi umum.

## 3. Tipografi
- **Font Family**: Google Fonts "Inter" atau "Roboto".
- **Heading 1**: 24sp, Bold.
- **Heading 2**: 20sp, SemiBold.
- **Body Text**: 14sp, Regular.
- **Caption**: 12sp, Regular.

## 4. Spacing
Menggunakan kelipatan 4dp/8dp:
- **Small**: 8dp
- **Medium**: 16dp (Standard padding)
- **Large**: 24dp
- **Extra Large**: 32dp

## 5. Button Style
- **Primary Button**: Warna latar Primary, teks Putih, rounded (radius 8dp).
- **Secondary Button**: Outlined dengan warna Primary, background transparan.
- **Disabled Button**: Latar abu-abu (#E0E0E0), teks abu-abu tua.

## 6. Text Field Style
- **Border**: Outlined border radius 8dp, border warna abu-abu.
- **Focused State**: Border warna Primary dengan ketebalan 2dp.
- **Error State**: Border warna Merah, teks bantuan (helper text) warna merah di bawah input.
- **Icon**: Mendukung prefix dan suffix icon (misal: icon mata untuk password).

## 7. Card Style
- **Background**: Putih (#FFFFFF).
- **Border Radius**: 12dp.
- **Elevation/Shadow**: Shadow tipis untuk memberikan efek melayang (depth).
- **Padding**: 16dp.

## 8. App Bar Style
- **Background**: Primary (#0056A6) atau Surface (#FFFFFF) tergantung tema layar.
- **Title**: Center aligned, 20sp SemiBold, teks Putih (jika background primary).
- **Elevation**: 0dp flat atau 2dp bayangan halus.

## 9. Empty State
- **Ilustrasi**: Gambar SVG simpel dan relevan (misal: gambar folder kosong).
- **Teks**: Pesan informatif (misal: "Belum ada data tersedia").
- **Call to Action (CTA)**: Tombol untuk memulai aksi (opsional).

## 10. Loading State
- **Full Screen**: CircularProgressIndicator berwarna Primary di tengah layar transparan.
- **Skeleton Loading**: Animasi shimmer abu-abu (untuk daftar list dan card sebelum data dimuat).
- **Button Loading**: Circular progress kecil di dalam tombol menggantikan teks.

## 11. Error Message
- **Snackbar/Toast**: Muncul di bawah layar, berlatar belakang merah, untuk error sistem atau API.
- **Form Error**: Inline text merah di bawah isian field yang salah.

## 12. Dashboard per Role
- **Mahasiswa**: Card status judul skripsi, next jadwal bimbingan terdekat, progress bar bab.
- **Dosen**: Ringkasan mahasiswa menunggu review, jadwal hari ini.
- **Kaprodi**: Chart/grafik mahasiswa lulus vs aktif per angkatan.
- **Admin & Super Admin**: Rekap jumlah user, log aktivitas terbaru.

## 13. Form Style
- Label berada di atas text field (vertikal spacing 8dp).
- Scrollable form jika lebih dari ukuran layar.
- Floating atau sticky "Submit" button di bagian bawah layar.

## 14. List Style
- **List Item**: Card yang berisi avatar (opsional), Title (utama), Subtitle (sekunder), dan trailing widget (status chip atau panah "chevron_right").
- Mendukung "Pull to Refresh" untuk memuat data terbaru.
