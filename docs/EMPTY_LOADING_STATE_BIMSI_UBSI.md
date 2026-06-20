# Empty & Loading State Rules - BIMSI UBSI

## 1. Aturan Empty State
*Empty state* muncul ketika response API mengembalikan array kosong (`[]`) atau data yang dicari tidak ada, tanpa adanya error dari server (HTTP 200 OK).

### A. Konten Empty State
- **Ilustrasi**: Gambar atau ikon SVG yang relevan (misal folder terbuka kosong, atau ikon inbox kosong).
- **Teks Utama**: Pesan singkat dan jelas (contoh: "Belum Ada Pengajuan", "Tidak ada jadwal bimbingan").
- **Teks Deskripsi**: Penjelasan opsional atau panduan langkah selanjutnya (contoh: "Anda belum mengajukan judul skripsi. Silakan buat pengajuan baru di tombol tambah.").
- **Call-to-Action (CTA)**: Tombol aksi utama jika memungkinkan (contoh: "Buat Pengajuan").

### B. Penempatan
- Ditempatkan tepat di tengah kontainer layar atau parent widget.
- Jika berupa *list*, menggantikan area *ListView* secara penuh.

## 2. Aturan Loading State
*Loading state* muncul selama Flutter sedang melakukan proses asinkronus dan menunggu respons balik dari REST API Laravel.

### A. Initial Fetch (Memuat Halaman Pertama Kali)
- **Tampilan Utama**: Sangat disarankan menggunakan **Skeleton Shimmer** (bentuk kotak/lingkaran placeholder berwarna abu-abu yang memiliki animasi berkedip/menyapu).
- **Alasan**: Memberikan perkiraan letak konten kepada pengguna, membuat aplikasi terasa lebih cepat.
- **Alternatif**: Jika komponen terlalu kompleks, cukup gunakan indikator *spinner* biasa (misal `CircularProgressIndicator` milik material design) di tengah layar.

### B. Pagination Fetch (Memuat Data Tambahan/Scroll ke Bawah)
- **Tampilan**: Munculkan indikator putar *spinner* ukuran kecil di bagian paling bawah antrean *ListView*.
- **Tindakan**: Cegah *multiple request* secara bersamaan untuk halaman yang sama ketika pengguna men-scroll dengan cepat berulang kali.

### C. Aksi Submit Data (Menyimpan Form/Upload File)
- **Tampilan**: Teks dalam tombol aksi berubah menjadi animasi *loading* atau muncul persentase pada kasus upload dokumen besar.
- **Penguncian**: Tombol submit *wajib di-disable* segera setelah ditekan pertama kali untuk mencegah *double request* atau data ganda.
- **Overlay (Opsional)**: Untuk proses krusial atau lambat, pasang lapisan overlay sedikit gelap yang menutupi seluruh layar dan menonaktifkan interaksi sentuhan untuk sementara waktu.
