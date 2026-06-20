# Bug Checklist BIMSI UBSI

Daftar _bugs_ umum yang sering terjadi pada integrasi Flutter-Laravel dan cara memitigasinya di aplikasi BIMSI UBSI.

## 1. Authentication & State
- [ ] **Token Mismatch / Expired:** Flutter gagal mendeteksi token _expired_ (401), berakibat *infinite loading*.
  - _Mitigasi:_ `ApiClient` interceptor mem-parsing status 401 dan memanggil logout lokal secara otomatis.
- [ ] **Role Confusion:** User mengubah data lokal lewat _shared_preferences_ seolah role-nya beda.
  - _Mitigasi:_ Validasi akhir tetap ada di _Backend_ (`RoleMiddleware`).
  
## 2. Realtime Pusher
- [ ] **Multiple Listeners:** *Event* ter-_trigger_ berkali-kali karena _listener_ diregistrasi di dalam metode `build()` tanpa dibersihkan (`dispose()`).
  - _Mitigasi:_ Pindahkan registrasi `RealtimeService.eventStream.listen` ke dalam blok `initState` atau *Riverpod Provider*.
- [ ] **Socket Disconnect:** Pusher gagal reconnect otomatis saat sinyal berpindah dari Wi-Fi ke Seluler.
  - _Mitigasi:_ Flutter mendengarkan `onConnectionStateChange` dan me-restart *subscribe*.

## 3. Upload & File Storage
- [ ] **Multipart Request Limit:** API menolak file >2MB.
  - _Mitigasi:_ Cek `upload_max_filesize` di `php.ini` atau tambahkan validasi *Max File Size* di Laravel FormRequest.
- [ ] **Cloudinary Timeout:** Proses *upload* sangat lama hingga *time-out*.
  - _Mitigasi:_ Ubah *timeout* durasi di `ApiClient` khusus endpoint upload menjadi 60 detik.

## 4. UI / State Rendering
- [ ] **Null Check Operator:** Data _pengajuan judul_ masih `null` saat UI mencoba merender `_pengajuan!.judul`.
  - _Mitigasi:_ Terapkan _Empty State_ widget jika variabel bernilai `null` dan jangan gunakan operator _bang_ (`!`) membabi-buta.
- [ ] **SetState After Dispose:** Memanggil `setState()` saat UI sudah ditutup (misal saat menunggu HTTP respons).
  - _Mitigasi:_ Cek `if (mounted)` sebelum memanggil `setState()`.
