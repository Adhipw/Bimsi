# Seeding Rules - BIMSI UBSI

## 1. Mekanisme Seeding Database
- Seeding data menggunakan fitur `DatabaseSeeder` bawaan Laravel.
- **Dilarang** mengisi data *dummy* secara manual melalui pgAdmin untuk lingkungan *Development*. Semuanya harus *scripted* melalui seeder dan *factory*.

## 2. Pembagian Class Seeder
Pisahkan seeder ke dalam beberapa class spesifik agar rapi:
- `RolePermissionSeeder`: Membuat *master data* role (wajib dieksekusi di *production*).
- `UserSeeder`: Membuat user admin dan kaprodi.
- `DosenSeeder`: Membuat data spesifik dosen menggunakan *factory* Laravel.
- `MahasiswaSeeder`: Membuat data spesifik mahasiswa menggunakan *factory*.
- `BimbinganSeeder`: Membuat skenario data bimbingan *dummy*.

## 3. Penggunaan Laravel Factory
Gunakan package `Faker` di dalam Laravel Factory untuk *generate* nama, judul skripsi, NIM, NIDN, dan deskripsi secara acak.

## 4. Reset & Seed (Refresh Database)
Untuk mengatur ulang dan mengisi data saat testing atau pengembangan, jalankan perintah standar:
`php artisan migrate:fresh --seed`
*(Perintah ini akan menghapus seluruh tabel dan membuatnya ulang berserta isinya. Peringatan: Jangan jalankan di database Production!)*

## 5. Pemisahan Lingkungan (Environment Check)
Pastikan seeder yang berisi data *dummy/fake* (seperti `BimbinganSeeder`, `MahasiswaSeeder` palsu) memiliki kondisional pengecekan agar **tidak tereksekusi** saat `APP_ENV=production`. Hanya `RolePermissionSeeder` dan `UserSeeder` (Admin Default) yang boleh dijalankan di Production.
