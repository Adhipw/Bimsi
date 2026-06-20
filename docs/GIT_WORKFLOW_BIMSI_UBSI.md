# Git Workflow - BIMSI UBSI

## 1. Branching Strategy
Proyek ini mengadopsi varian **Git-Flow** yang disederhanakan:
- `main` / `master`: Branch utama, berisi kode yang sudah stabil dan siap deploy ke *production*.
- `develop`: Branch pengembangan utama. Semua fitur baru akan digabungkan ke sini terlebih dahulu.
- `feature/*`: Branch untuk mengerjakan fitur spesifik. (Contoh: `feature/auth-login`, `feature/upload-skripsi`).
- `hotfix/*`: Branch untuk memperbaiki *bug* kritis di `main` yang butuh penanganan segera.

## 2. Alur Kerja (Workflow)
1. **Buat Branch**: Setiap developer membuat branch `feature/*` baru yang diambil (checkout) dari branch `develop`.
2. **Commit Changes**: Developer menyimpan perubahan dengan format pesan commit yang terstandarisasi.
3. **Pull Request (PR) / Merge Request**: Setelah fitur selesai, buat PR dari `feature/*` menuju `develop`.
4. **Code Review**: Anggota tim lain melakukan review kode. Jika disetujui, branch akan di-merge ke `develop`.
5. **Release**: Jika `develop` sudah stabil, akan di-merge ke `main` untuk proses deployment.

## 3. Aturan Pesan Commit (Conventional Commits)
Gunakan format berikut: `<type>: <deskripsi singkat>`
- `feat:` Untuk penambahan fitur baru (misal: `feat: add login screen`).
- `fix:` Untuk perbaikan bug (misal: `fix: handle null exception on profile`).
- `docs:` Untuk perubahan dokumentasi (misal: `docs: update API spec`).
- `style:` Untuk perubahan format kode, hapus spasi, tanpa mengubah logika.
- `refactor:` Untuk perbaikan struktur kode tanpa mengubah fungsi.
- `chore:` Untuk pembaruan dependensi, pubspec, atau composer.
