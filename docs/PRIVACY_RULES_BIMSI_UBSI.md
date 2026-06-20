# Privacy Rules - BIMSI UBSI

## 1. Perlindungan Data Pribadi (PII)
- Identitas pengguna (NIM, NIDN, Nama, Email, No. HP) harus dijaga kerahasiaannya dan tidak diumbar melalui endpoint API publik.
- Endpoint pencarian user/dosen tidak boleh menampilkan *password hash* maupun token.
- Fitur *export report* yang berisi daftar nama mahasiswa hanya boleh diakses oleh role Kaprodi, Admin, dan Super Admin.

## 2. Hak Akses Dokumen Bimbingan
- File draft skripsi/dokumen revisi (*PDF*) yang diunggah ke *Cloudinary* tidak boleh disebarluaskan secara publik melalui *search engine*.
- Hanya Mahasiswa pengunggah dan Dosen pembimbing yang ter-plot yang boleh mengakses *URL Download* dari dokumen tersebut.

## 3. Privasi Pesan (Chat)
- Sistem harus menjamin bahwa percakapan *chat realtime* (via Pusher) hanya terjadi dalam *private channel* yang spesifik untuk bimbingan tersebut (`private-bimbingan.{id}`).
- Untuk *subscribe* ke channel ini, Flutter harus mengirim permintaan otorisasi ke backend Laravel yang memverifikasi apakah user yang login memiliki hak atas bimbingan tersebut.

## 4. Retensi dan Penghapusan Data
- Terdapat aturan "Soft Deletes" di Laravel untuk data pengguna. Jika akun dihapus, riwayat bimbingannya tetap tersimpan namun status akunnya menjadi tidak aktif (tidak hilang dari log operasional kampus).
