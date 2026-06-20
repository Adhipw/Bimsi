# Activity Flow - BIMSI UBSI

## 1. Activity Flow Proses Utama (Bimbingan Skripsi)

```mermaid
stateDiagram-v2
    [*] --> Login
    Login --> DashboardMahasiswa : Role Mahasiswa
    DashboardMahasiswa --> PengajuanJudul
    PengajuanJudul --> MenungguPlotting : Submit
    MenungguPlotting --> PlottingDosen : Admin/Kaprodi
    PlottingDosen --> BimbinganAktif : Status Disetujui
    BimbinganAktif --> UploadDokumen
    BimbinganAktif --> AjukanJadwal
    BimbinganAktif --> ChatDosen
    UploadDokumen --> ReviewDosen : Dosen mereview
    ReviewDosen --> Revisi : Perlu Perbaikan
    Revisi --> UploadDokumen
    ReviewDosen --> AccBab : Sesuai Kriteria
    AccBab --> CekSemuaBab
    CekSemuaBab --> SiapSidang : Semua ACC
    CekSemuaBab --> UploadDokumen : Lanjut bab berikutnya
    SiapSidang --> [*]
```

## 2. Penjelasan Flow
1. **Pengajuan**: Mahasiswa mengajukan judul skripsi melalui aplikasi.
2. **Plotting**: Admin atau Kaprodi menerima pengajuan dan menentukan siapa dosen pembimbingnya.
3. **Bimbingan Berjalan**: Mahasiswa dapat mengunggah file revisi dan dosen dapat memberikan feedback. Komunikasi dibantu dengan fitur Chat.
4. **Approval**: Setiap bab yang selesai akan di-ACC oleh Dosen.
5. **Selesai**: Jika seluruh komponen di-ACC, mahasiswa berstatus "Siap Sidang".
