# API Specification - BIMSI UBSI

## 1. Base URL & Format
- Base URL: `https://api.bimsi-ubsi.koyeb.app/api/v1`
- Format: JSON
- Autentikasi: Bearer Token (Laravel Sanctum)

## 2. Pagination, Search, dan Filter
- **Pagination**: Menambahkan query `?page=1&limit=15`. Response akan mencakup meta data pagination.
- **Search**: Menambahkan query `?search=keyword` pada endpoint get list.
- **Filter**: Menambahkan query sesuai field, misal `?status=pending`.

## 3. Standard Response Format
**Success Response (2xx)**
```json
{
  "success": true,
  "message": "Data retrieved successfully",
  "data": { ... } // object atau array
}
```

**Error Response (4xx, 5xx)**
```json
{
  "success": false,
  "message": "Validation Error",
  "errors": {
    "field_name": ["The field_name is required."]
  }
}
```

## 4. Status Code
- `200 OK`: Sukses GET/PUT.
- `201 Created`: Sukses POST (data terbuat).
- `400 Bad Request`: Format salah.
- `401 Unauthorized`: Token tidak valid atau tidak ada.
- `403 Forbidden`: Role tidak diizinkan mengakses resource.
- `404 Not Found`: Endpoint atau data tidak ditemukan.
- `422 Unprocessable Entity`: Gagal validasi data.
- `500 Internal Server Error`: Kesalahan server.

## 5. Endpoints

### A. Authentication (Semua Role)
**POST /login**
- **Method**: POST
- **Role**: Guest
- **Request**:
  - `email` (string, required)
  - `password` (string, required)
- **Response**: `token` (string), `user` (object)

**POST /logout**
- **Method**: POST
- **Role**: Semua Role terautentikasi
- **Request**: None
- **Response**: Message success.

### B. Mahasiswa
**POST /bimbingan/pengajuan**
- **Method**: POST
- **Role**: Mahasiswa
- **Request**: `judul` (string), `deskripsi` (string)
- **Response**: `id_bimbingan`, `status`, dsb.

**POST /bimbingan/{id}/dokumen**
- **Method**: POST (Multipart/Form-Data)
- **Role**: Mahasiswa
- **Request**: `file_dokumen` (file PDF, max 5MB), `keterangan` (string)
- **Response**: `file_url` (Cloudinary URL).

### C. Dosen
**GET /dosen/mahasiswa-bimbingan**
- **Method**: GET
- **Role**: Dosen
- **Request**: Pagination, search, filter status.
- **Response**: Array of mahasiswa.

**PUT /bimbingan/{id}/dokumen/{doc_id}/review**
- **Method**: PUT
- **Role**: Dosen
- **Request**: `status` (approved/rejected), `catatan` (string)
- **Response**: Dokumen updated.

### D. Kaprodi
**GET /kaprodi/progress-mahasiswa**
- **Method**: GET
- **Role**: Kaprodi
- **Request**: Pagination, search.
- **Response**: Array progress.

**PUT /bimbingan/{id}/plot-dosen**
- **Method**: PUT
- **Role**: Kaprodi, Admin
- **Request**: `dosen_id` (int)
- **Response**: Updated bimbingan data.

### E. Admin & Super Admin
**GET /admin/users**
- **Method**: GET
- **Role**: Admin, Super Admin
- **Request**: `role` filter, pagination.
- **Response**: Array of users.

**POST /admin/users**
- **Method**: POST
- **Role**: Super Admin
- **Request**: Data user + role.
- **Response**: User created.
