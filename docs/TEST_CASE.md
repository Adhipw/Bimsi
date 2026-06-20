# Test Case

## Format Status
- `Not Run`: belum diuji.
- `Pass`: berhasil.
- `Fail`: gagal.
- `Need Fix`: ada error dan perlu perbaikan.

## Documentation Test
| ID | Test | Expected | Status |
| --- | --- | --- | --- |
| DOC-001 | Semua dokumen Step 1 dibuat | File ada di `docs/` | Not Run |
| DOC-002 | Dokumen membahas arsitektur Flutter ke API | Ada penjelasan Dio -> REST API | Not Run |
| DOC-003 | Dokumen membahas Supabase dan Drizzle | Ada PostgreSQL/Auth/Storage/Realtime/RLS/ORM | Not Run |

## Public Portal Test
| ID | Test | Expected | Status |
| --- | --- | --- | --- |
| PUB-001 | Buka `/` | Landing page tampil | Not Run |
| PUB-002 | Pilih kampus | Kampus tersimpan sementara | Not Run |
| PUB-003 | Pilih jurusan/prodi | Jurusan sesuai kampus tampil | Not Run |
| PUB-004 | Pilih periode | Periode aktif tampil | Not Run |
| PUB-005 | Pilih portal | User diarahkan ke login role | Not Run |
| PUB-006 | Akses login langsung tanpa pilihan awal | Ditolak/redirect sesuai aturan | Not Run |

## Auth Test
| ID | Test | Expected | Status |
| --- | --- | --- | --- |
| AUTH-001 | Register mahasiswa valid | Status `pending_verification` | Not Run |
| AUTH-002 | Register mahasiswa password tidak sama | `422` validation error | Not Run |
| AUTH-003 | Mahasiswa pending booking | Ditolak | Not Run |
| AUTH-004 | Admin verifikasi mahasiswa | Mahasiswa menjadi verified | Not Run |
| AUTH-005 | Login mahasiswa NIM valid | Token/session diterima | Not Run |
| AUTH-006 | Request account dosen | Status `pending_admin_approval` | Not Run |
| AUTH-007 | Dosen belum approved login | Ditolak | Not Run |
| AUTH-008 | Admin/Super Admin approve dosen | Dosen bisa login | Not Run |
| AUTH-009 | Admin register publik | Endpoint tidak tersedia/ditolak | Not Run |

## Authorization and Ownership Test
| ID | Test | Expected | Status |
| --- | --- | --- | --- |
| SEC-001 | Mahasiswa akses data mahasiswa lain | `403 Forbidden` | Not Run |
| SEC-002 | Dosen akses mahasiswa bukan bimbingan | `403 Forbidden` | Not Run |
| SEC-003 | Admin akses `/api/v1/super-admin/*` | `403 Forbidden` | Not Run |
| SEC-004 | Super admin akses super-admin endpoint | Success | Not Run |

## Web Service Test
| ID | Test | Expected | Status |
| --- | --- | --- | --- |
| API-001 | GET demo endpoint | `200 OK` JSON standar | Not Run |
| API-002 | POST demo endpoint | `201 Created` JSON standar | Not Run |
| API-003 | PATCH demo endpoint | `200 OK` JSON standar | Not Run |
| API-004 | DELETE demo endpoint | `204` atau JSON standar sesuai kontrak | Not Run |
| API-005 | Swagger tersedia | OpenAPI dapat dibuka | Not Run |
| API-006 | Postman collection dapat dijalankan | Endpoint testable | Not Run |

## Guidance Flow Test
| ID | Test | Expected | Status |
| --- | --- | --- | --- |
| GDN-001 | Dosen membuat jadwal | Slot terbentuk | Not Run |
| GDN-002 | Mahasiswa booking slot | Booking dan tiket dibuat | Not Run |
| GDN-003 | Dosen approve booking | Guidance room dibuat | Not Run |
| GDN-004 | Dosen reject tanpa alasan | Ditolak validasi | Not Run |
| GDN-005 | Dosen reject tanpa jadwal pengganti | Ditolak validasi | Not Run |
| GDN-006 | Dosen reject valid | Status `rejected_with_alternative` | Not Run |

## Document and Realtime Test
| ID | Test | Expected | Status |
| --- | --- | --- | --- |
| DOCF-001 | Upload dokumen via backend | File masuk Storage dan metadata tersimpan | Not Run |
| DOCF-002 | Upload file terlalu besar | Ditolak | Not Run |
| DOCF-003 | Versioning dokumen | Version number naik | Not Run |
| RT-001 | Notifikasi booking realtime | User menerima update | Not Run |
| RT-002 | Status dosen live | Mahasiswa melihat update | Not Run |
| RT-003 | Guidance room message | Pesan realtime tampil | Not Run |

## Manual QA Rule
Jangan tandai `Pass` sebelum fitur benar-benar dibuat dan diuji. Jika build/test belum dijalankan, tulis `Not Run`.
