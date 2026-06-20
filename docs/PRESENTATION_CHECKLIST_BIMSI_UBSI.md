# Presentation Checklist BIMSI UBSI

Daftar periksa (checklist) yang harus dipastikan aman di H-1 dan Hari-H sebelum Anda mendemokan aplikasi BIMSI UBSI di depan penguji/dosen/klien.

## 1. Persiapan Infrastruktur (H-1)
- [ ] **Koyeb Server:** Pastikan server backend sedang aktif (Healthy). Tidak di-*pause* atau _suspended_.
- [ ] **Aiven Database:** Cek apakah storage limit DB belum penuh dan koneksi dari aplikasi ke DB cepat.
- [ ] **Pusher & FCM:** Pastikan kuota gratis (messages/day) belum habis akibat terlalu sering di-test saat development.
- [ ] **Cloudinary:** Pastikan file masih dapat diunggah dengan kuota storage yang memadai.
- [ ] **Dummy Data Sempurna:** Jalankan `php artisan migrate:fresh --seed`. Pastikan *password* dummy untuk kelima role dihapal di luar kepala atau dicatat.
- [ ] **APK Final:** APK yang sudah di-compile diinstal ulang pada *device tester*, dites dari tahap instalasi hingga login tanpa masalah.

## 2. Persiapan Hardward & Aksesori (Hari-H)
- [ ] **Koneksi Internet Pribadi (Tethering):** Jangan mengandalkan Wi-Fi kampus yang mungkin lambat atau memblokir port Websocket (Pusher). Siapkan _Personal Hotspot_.
- [ ] **Kabel Data / Casting App:** Siapkan kabel atau aplikasi (seperti scrcpy, Vysor, Windows Phone Link) untuk me-*mirror* layar HP Mahasiswa ke Layar Proyektor/Laptop.
- [ ] **Kapasitas Baterai:** Pastikan Laptop dan Smartphone dalam kondisi baterai 100%.

## 3. Checklist Menit-Menit Terakhir (Sebelum Tampil)
- [ ] Bersihkan notifikasi pribadi (WhatsApp/Instagram) di HP Demo agar tidak muncul notifikasi *pop-up* yang tidak profesional saat demo. Jangan aktifkan mode DND (*Do Not Disturb*) penuh jika itu mencegah notifikasi *Push Firebase* aplikasi kita muncul.
- [ ] *Clear App Data* BIMSI UBSI di HP tester agar simulasi benar-benar mulai dari awal (tidak nyangkut di *cache* token lama).
- [ ] Siapkan *Slide* Presentasi di *desktop*. Buka tab Browser dengan posisi *Login Kaprodi* dan *Login Dosen* yang sudah *stand-by*.

## 4. Antisipasi Bencana
- [ ] **Local Backup (Plan B):** Bawa versi *localhost* (XAMPP/Docker) dan aplikasi Flutter yang mengarah ke `10.0.2.2`. Gunakan ini HANYA jika server Koyeb mati total saat hari-H.
- [ ] **Video Rekaman:** Siapkan rekaman video (Screencast) demo aplikasi sempurna berdurasi 3-5 menit sebagai cadangan jika semua perangkat gagal menyala.
