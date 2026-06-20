# Role Permission Matrix - BIMSI UBSI

## 1. Matrix Hak Akses (5 Role)
Tabel matriks ini menggambarkan akses tingkat tinggi terhadap modul-modul di dalam sistem.

| Modul/Fitur             | Mahasiswa | Dosen | Kaprodi | Admin | Super Admin |
|-------------------------|-----------|-------|---------|-------|-------------|
| **Login/Logout**        | ✅        | ✅    | ✅      | ✅    | ✅          |
| **Pengajuan Judul**     | ✅        | ❌    | ❌      | ❌    | ❌          |
| **Approve Judul**       | ❌        | ❌    | ✅      | ✅    | ✅          |
| **Plotting Pembimbing** | ❌        | ❌    | ✅      | ✅    | ✅          |
| **Upload Draft/Revisi** | ✅        | ❌    | ❌      | ❌    | ❌          |
| **Review & Beri Nilai** | ❌        | ✅    | ❌      | ❌    | ❌          |
| **Chat Bimbingan**      | ✅        | ✅    | ❌      | ❌    | ❌          |
| **Monitoring Prodi**    | ❌        | ❌    | ✅      | ✅    | ✅          |
| **Manajemen Master Data**| ❌       | ❌    | ❌      | ✅    | ✅          |
| **Konfigurasi Sistem**  | ❌        | ❌    | ❌      | ❌    | ✅          |
| **Audit Logs**          | ❌        | ❌    | ❌      | ❌    | ✅          |

## 2. Fitur per Role
- **Mahasiswa**: Pendaftaran skripsi, lihat status pengajuan, buat jadwal bimbingan, upload dokumen (bab per bab), diskusi via chat, notifikasi progress.
- **Dosen**: Menerima plot bimbingan mahasiswa, lihat daftar asuhan, review dokumen, setujui dokumen (ACC), balas chat mahasiswa, atur jadwal.
- **Kaprodi**: Lihat daftar mahasiswa aktif di prodi, lihat rasio mahasiswa vs dosen, setujui plot dosen, pantau grafik kelulusan.
- **Admin**: Input data mahasiswa, input data dosen, set up semester aktif, plot dosen pembimbing awal.
- **Super Admin**: CRUD semua role, backup & restore, monitoring audit logs, hapus akun.

## 3. Endpoint per Role
| Role | Endpoint API (Contoh Prefix) | Method |
|---|---|---|
| **Mahasiswa** | `/api/v1/mhs/pengajuan` <br> `/api/v1/mhs/dokumen` <br> `/api/v1/mhs/jadwal` | GET, POST, PUT, DELETE (miliknya saja) |
| **Dosen** | `/api/v1/dosen/bimbingan` <br> `/api/v1/dosen/review` <br> `/api/v1/dosen/jadwal` | GET, PUT (mahasiswa asuhannya) |
| **Kaprodi** | `/api/v1/kaprodi/statistik` <br> `/api/v1/kaprodi/plot` | GET, PUT |
| **Admin** | `/api/v1/admin/users` <br> `/api/v1/admin/plot` | GET, POST, PUT, DELETE |
| **Super Admin** | `/api/v1/superadmin/*` | GET, POST, PUT, DELETE (All access) |

## 4. Halaman Flutter per Role
- **Mahasiswa**: `HomeScreen`, `PengajuanScreen`, `JadwalBimbinganScreen`, `DetailBimbinganScreen`, `ChatScreen`.
- **Dosen**: `DosenDashboardScreen`, `ListMahasiswaAsuhanScreen`, `ReviewDokumenScreen`, `ChatScreen`.
- **Kaprodi**: `KaprodiDashboardScreen`, `PersetujuanPlotScreen`, `ReportProdiScreen`.
- **Admin**: `AdminDashboardScreen`, `ManageUserScreen`, `ManagePlottingScreen`.
- **Super Admin**: `SystemDashboardScreen`, `RoleManagementScreen`, `AuditLogScreen`.

## 5. Aksi CRUD per Role
- **Mahasiswa**: 
  - CREATE: Pengajuan, Dokumen, Pesan Chat, Jadwal.
  - READ: Bimbingannya sendiri, Data Dosen pembimbingnya.
  - UPDATE: Edit pengajuan (jika belum diproses), Update dokumen.
  - DELETE: Batalkan jadwal (jika belum disetujui).
- **Dosen**:
  - CREATE: Pesan Chat.
  - READ: Daftar mahasiswa yang dibimbing, dokumen milik mahasiswa tersebut.
  - UPDATE: Status dokumen (Approved/Rejected), Feedback jadwal.
  - DELETE: Hapus pesan chat (opsional/own message).
- **Kaprodi**:
  - READ: Data statistik, semua pengajuan mahasiswa di prodinya.
  - UPDATE: Approve/Reject plotting dosen.
- **Admin**:
  - CREATE: User, Mahasiswa, Dosen.
  - READ: Semua data operasional.
  - UPDATE: Ubah data user, ubah plotting dosen.
  - DELETE: Hapus user (soft delete).
- **Super Admin**:
  - CREATE, READ, UPDATE, DELETE untuk seluruh Resource/Tabel.

## 6. Batasan Akses Data per Role
- **Mahasiswa**: *Row-Level Security* – Mahasiswa A hanya bisa melihat data bimbingan `id_mahasiswa = A`. Dilarang keras melihat dokumen atau chat mahasiswa B.
- **Dosen**: Hanya bisa mengakses data `bimbingan` di mana `id_dosen = Dosen_Yang_Login`.
- **Kaprodi**: Hanya bisa melihat statistik dan daftar mahasiswa pada `kode_prodi` yang sama dengan Kaprodi.
- **Admin**: Bisa mengakses seluruh data operasional (Dosen dan Mahasiswa) lintas prodi (kecuali sistem di-set per prodi).
- **Super Admin**: Tidak ada batasan akses data.
