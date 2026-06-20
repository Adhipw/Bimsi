# Backup & Restore Rules - BIMSI UBSI

## 1. Strategi Backup Database
- Database utama PostgreSQL di-*host* pada **Aiven**. Oleh karena itu, *Daily Automated Backup* akan dikelola melalui fasilitas dasbor Aiven PaaS.
- Sistem harus dikonfigurasi untuk melakukan pencadangan harian (*Daily Snapshot*).
- **Retention Period**: Salinan cadangan wajib disimpan minimal selama 14 hari terakhir.

## 2. Strategi Backup File Pendukung
- Karena aplikasi menggunakan layanan **Cloudinary** untuk penyimpanan file, maka dokumen revisi dan tugas akhir tidak disimpan di *storage server* lokal Koyeb.
- *Backup* file gambar/dokumen menjadi tanggung jawab SLA dari Cloudinary.
- Namun, **URL/tautan** dari file tersebut harus ada dalam cadangan *Database PostgreSQL* di Aiven.

## 3. Aturan Restore (Pemulihan Data)
- **Point-in-Time Recovery**: Jika terjadi kerusakan data/kebocoran, Admin akan menggunakan fitur *restore* di dasbor Aiven untuk mengembalikan kondisi basis data ke tanggal stabil terakhir.
- Tidak disarankan melakukan restore sebagian tabel. Pemulihan harus bersifat komprehensif pada satu database utuh untuk menjaga integritas *Foreign Key*.
- Selama proses *restore*, aplikasi backend di Koyeb harus diatur ke status *Maintenance Mode* (`php artisan down`).
