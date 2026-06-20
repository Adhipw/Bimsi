# Use Case Diagram - BIMSI UBSI

## 1. Diagram Use Case (Mermaid)

```mermaid
usecaseDiagram
    actor Mahasiswa
    actor Dosen
    actor Kaprodi
    actor Admin
    actor SuperAdmin

    usecase "Login & Logout" as UC1
    usecase "Mengajukan Judul Bimbingan" as UC2
    usecase "Upload Dokumen Skripsi" as UC3
    usecase "Chat dengan Dosen" as UC4
    usecase "Review Dokumen & Beri Feedback" as UC5
    usecase "Setujui Bab Skripsi" as UC6
    usecase "Monitoring Progress" as UC7
    usecase "Plotting Dosen Pembimbing" as UC8
    usecase "Kelola Data User (CRUD)" as UC9
    usecase "Konfigurasi Sistem" as UC10

    Mahasiswa --> UC1
    Mahasiswa --> UC2
    Mahasiswa --> UC3
    Mahasiswa --> UC4

    Dosen --> UC1
    Dosen --> UC4
    Dosen --> UC5
    Dosen --> UC6

    Kaprodi --> UC1
    Kaprodi --> UC7
    Kaprodi --> UC8

    Admin --> UC1
    Admin --> UC8
    Admin --> UC9

    SuperAdmin --> UC1
    SuperAdmin --> UC9
    SuperAdmin --> UC10
```

## 2. Deskripsi per Role
- **Mahasiswa**: Dapat melakukan pendaftaran topik skripsi, mengajukan jadwal bimbingan, mengunggah dokumen bab (ke Cloudinary via API), dan melakukan diskusi real-time dengan dosen pembimbing.
- **Dosen Pembimbing**: Dapat melihat antrean mahasiswa bimbingannya, mereview dokumen yang diunggah, membalas chat (Pusher), dan menyetujui progress bimbingan.
- **Kaprodi**: Memiliki hak untuk memantau progress seluruh mahasiswa di prodinya, serta menyetujui plotting dosen pembimbing.
- **Admin**: Bertugas memasukkan master data mahasiswa dan dosen, serta melakukan plotting awal dosen pembimbing.
- **Super Admin**: Berhak mengelola seluruh aspek sistem, memodifikasi peran (role matrix), dan melakukan konfigurasi sistem tingkat tinggi.
