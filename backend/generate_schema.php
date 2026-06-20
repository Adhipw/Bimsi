<?php

// Script to generate all Models and a single Migration file for BIMSI UBSI.

$models = [
    'Role' => "protected \$fillable = ['name'];",
    'Permission' => "protected \$fillable = ['name'];",
    'RolePermission' => "protected \$fillable = ['role_id', 'permission_id'];",
    'ProgramStudi' => "protected \$fillable = ['kode_prodi', 'nama_prodi', 'jenjang'];",
    'TahunAkademik' => "protected \$fillable = ['tahun', 'is_active'];",
    'Semester' => "protected \$fillable = ['nama', 'is_active'];",
    'Kelas' => "protected \$fillable = ['nama_kelas', 'program_studi_id'];",
    'Mahasiswa' => "protected \$fillable = ['user_id', 'nim', 'program_studi_id', 'kelas_id', 'tahun_masuk'];",
    'Dosen' => "protected \$fillable = ['user_id', 'nidn', 'jabatan_fungsional'];",
    'BidangKeahlian' => "protected \$fillable = ['nama_bidang'];",
    'DosenBidangKeahlian' => "protected \$fillable = ['dosen_id', 'bidang_keahlian_id'];",
    'PeriodeSkripsi' => "protected \$fillable = ['nama_periode', 'tanggal_mulai', 'tanggal_selesai', 'is_active'];",
    'PengajuanJudul' => "protected \$fillable = ['mahasiswa_id', 'periode_skripsi_id', 'judul', 'deskripsi', 'status'];",
    'RiwayatPengajuanJudul' => "protected \$fillable = ['pengajuan_judul_id', 'status_sebelumnya', 'status_baru', 'keterangan'];",
    'Pembimbing' => "protected \$fillable = ['pengajuan_judul_id', 'dosen_id', 'peran', 'status'];",
    'PerubahanJudul' => "protected \$fillable = ['pengajuan_judul_id', 'judul_lama', 'judul_baru', 'alasan', 'status'];",
    'PergantianPembimbing' => "protected \$fillable = ['pengajuan_judul_id', 'dosen_lama_id', 'dosen_baru_id', 'alasan', 'status'];",
    'SlotBimbingan' => "protected \$fillable = ['dosen_id', 'hari', 'jam_mulai', 'jam_selesai', 'kuota'];",
    'JadwalBimbingan' => "protected \$fillable = ['pembimbing_id', 'slot_bimbingan_id', 'tanggal', 'status'];",
    'RiwayatBimbingan' => "protected \$fillable = ['jadwal_bimbingan_id', 'catatan_mahasiswa', 'catatan_dosen', 'status'];",
    'DokumenSkripsi' => "protected \$fillable = ['pengajuan_judul_id', 'jenis_dokumen', 'file_url'];",
    'VersiDokumen' => "protected \$fillable = ['dokumen_skripsi_id', 'versi', 'file_url', 'catatan_revisi'];",
    'ReviewDokumen' => "protected \$fillable = ['versi_dokumen_id', 'dosen_id', 'komentar', 'status'];",
    'ProgressSkripsi' => "protected \$fillable = ['pengajuan_judul_id', 'persentase', 'keterangan'];",
    'Notifikasi' => "protected \$fillable = ['user_id', 'judul', 'pesan', 'is_read'];",
    'FcmToken' => "protected \$fillable = ['user_id', 'token', 'device_info'];",
    'AuditLog' => "protected \$fillable = ['user_id', 'action', 'entity', 'entity_id', 'old_data', 'new_data'];",
    'LaporanExport' => "protected \$fillable = ['user_id', 'jenis_laporan', 'file_url', 'status'];",
];

$modelsDir = __DIR__ . '/app/Models';
if (!is_dir($modelsDir)) mkdir($modelsDir, 0777, true);

foreach ($models as $modelName => $fillable) {
    $content = "<?php\n\nnamespace App\Models;\n\nuse Illuminate\Database\Eloquent\Factories\HasFactory;\nuse Illuminate\Database\Eloquent\Model;\n\nclass $modelName extends Model\n{\n    use HasFactory;\n\n    $fillable\n}\n";
    file_put_contents("$modelsDir/$modelName.php", $content);
}

// Generate the single combined migration
$migrationContent = <<<PHP
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('roles', function (Blueprint \$table) {
            \$table->id();
            \$table->string('name');
            \$table->timestamps();
        });

        Schema::create('permissions', function (Blueprint \$table) {
            \$table->id();
            \$table->string('name');
            \$table->timestamps();
        });

        Schema::create('role_permissions', function (Blueprint \$table) {
            \$table->id();
            \$table->foreignId('role_id')->constrained('roles')->cascadeOnDelete();
            \$table->foreignId('permission_id')->constrained('permissions')->cascadeOnDelete();
            \$table->timestamps();
        });

        Schema::create('program_studis', function (Blueprint \$table) {
            \$table->id();
            \$table->string('kode_prodi');
            \$table->string('nama_prodi');
            \$table->string('jenjang');
            \$table->timestamps();
        });

        Schema::create('tahun_akademiks', function (Blueprint \$table) {
            \$table->id();
            \$table->string('tahun');
            \$table->boolean('is_active')->default(false);
            \$table->timestamps();
        });

        Schema::create('semesters', function (Blueprint \$table) {
            \$table->id();
            \$table->string('nama');
            \$table->boolean('is_active')->default(false);
            \$table->timestamps();
        });

        Schema::create('kelas', function (Blueprint \$table) {
            \$table->id();
            \$table->string('nama_kelas');
            \$table->foreignId('program_studi_id')->constrained('program_studis')->cascadeOnDelete();
            \$table->timestamps();
        });

        Schema::create('mahasiswas', function (Blueprint \$table) {
            \$table->id();
            \$table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            \$table->string('nim')->unique();
            \$table->foreignId('program_studi_id')->constrained('program_studis')->cascadeOnDelete();
            \$table->foreignId('kelas_id')->constrained('kelas')->cascadeOnDelete();
            \$table->string('tahun_masuk');
            \$table->timestamps();
        });

        Schema::create('dosens', function (Blueprint \$table) {
            \$table->id();
            \$table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            \$table->string('nidn')->unique();
            \$table->string('jabatan_fungsional');
            \$table->timestamps();
        });

        Schema::create('bidang_keahlians', function (Blueprint \$table) {
            \$table->id();
            \$table->string('nama_bidang');
            \$table->timestamps();
        });

        Schema::create('dosen_bidang_keahlians', function (Blueprint \$table) {
            \$table->id();
            \$table->foreignId('dosen_id')->constrained('dosens')->cascadeOnDelete();
            \$table->foreignId('bidang_keahlian_id')->constrained('bidang_keahlians')->cascadeOnDelete();
            \$table->timestamps();
        });

        Schema::create('periode_skripsis', function (Blueprint \$table) {
            \$table->id();
            \$table->string('nama_periode');
            \$table->date('tanggal_mulai');
            \$table->date('tanggal_selesai');
            \$table->boolean('is_active')->default(false);
            \$table->timestamps();
        });

        Schema::create('pengajuan_juduls', function (Blueprint \$table) {
            \$table->id();
            \$table->foreignId('mahasiswa_id')->constrained('mahasiswas')->cascadeOnDelete();
            \$table->foreignId('periode_skripsi_id')->constrained('periode_skripsis')->cascadeOnDelete();
            \$table->string('judul');
            \$table->text('deskripsi')->nullable();
            \$table->string('status')->default('pending');
            \$table->timestamps();
        });

        Schema::create('riwayat_pengajuan_juduls', function (Blueprint \$table) {
            \$table->id();
            \$table->foreignId('pengajuan_judul_id')->constrained('pengajuan_juduls')->cascadeOnDelete();
            \$table->string('status_sebelumnya');
            \$table->string('status_baru');
            \$table->text('keterangan')->nullable();
            \$table->timestamps();
        });

        Schema::create('pembimbings', function (Blueprint \$table) {
            \$table->id();
            \$table->foreignId('pengajuan_judul_id')->constrained('pengajuan_juduls')->cascadeOnDelete();
            \$table->foreignId('dosen_id')->constrained('dosens')->cascadeOnDelete();
            \$table->string('peran');
            \$table->string('status')->default('aktif');
            \$table->timestamps();
        });

        Schema::create('perubahan_juduls', function (Blueprint \$table) {
            \$table->id();
            \$table->foreignId('pengajuan_judul_id')->constrained('pengajuan_juduls')->cascadeOnDelete();
            \$table->string('judul_lama');
            \$table->string('judul_baru');
            \$table->text('alasan');
            \$table->string('status')->default('pending');
            \$table->timestamps();
        });

        Schema::create('pergantian_pembimbings', function (Blueprint \$table) {
            \$table->id();
            \$table->foreignId('pengajuan_judul_id')->constrained('pengajuan_juduls')->cascadeOnDelete();
            \$table->foreignId('dosen_lama_id')->constrained('dosens')->cascadeOnDelete();
            \$table->foreignId('dosen_baru_id')->constrained('dosens')->cascadeOnDelete();
            \$table->text('alasan');
            \$table->string('status')->default('pending');
            \$table->timestamps();
        });

        Schema::create('slot_bimbingans', function (Blueprint \$table) {
            \$table->id();
            \$table->foreignId('dosen_id')->constrained('dosens')->cascadeOnDelete();
            \$table->string('hari');
            \$table->time('jam_mulai');
            \$table->time('jam_selesai');
            \$table->integer('kuota');
            \$table->timestamps();
        });

        Schema::create('jadwal_bimbingans', function (Blueprint \$table) {
            \$table->id();
            \$table->foreignId('pembimbing_id')->constrained('pembimbings')->cascadeOnDelete();
            \$table->foreignId('slot_bimbingan_id')->constrained('slot_bimbingans')->cascadeOnDelete();
            \$table->date('tanggal');
            \$table->string('status')->default('scheduled');
            \$table->timestamps();
        });

        Schema::create('riwayat_bimbingans', function (Blueprint \$table) {
            \$table->id();
            \$table->foreignId('jadwal_bimbingan_id')->constrained('jadwal_bimbingans')->cascadeOnDelete();
            \$table->text('catatan_mahasiswa')->nullable();
            \$table->text('catatan_dosen')->nullable();
            \$table->string('status')->default('selesai');
            \$table->timestamps();
        });

        Schema::create('dokumen_skripsis', function (Blueprint \$table) {
            \$table->id();
            \$table->foreignId('pengajuan_judul_id')->constrained('pengajuan_juduls')->cascadeOnDelete();
            \$table->string('jenis_dokumen');
            \$table->string('file_url');
            \$table->timestamps();
        });

        Schema::create('versi_dokumens', function (Blueprint \$table) {
            \$table->id();
            \$table->foreignId('dokumen_skripsi_id')->constrained('dokumen_skripsis')->cascadeOnDelete();
            \$table->integer('versi');
            \$table->string('file_url');
            \$table->text('catatan_revisi')->nullable();
            \$table->timestamps();
        });

        Schema::create('review_dokumens', function (Blueprint \$table) {
            \$table->id();
            \$table->foreignId('versi_dokumen_id')->constrained('versi_dokumens')->cascadeOnDelete();
            \$table->foreignId('dosen_id')->constrained('dosens')->cascadeOnDelete();
            \$table->text('komentar');
            \$table->string('status');
            \$table->timestamps();
        });

        Schema::create('progress_skripsis', function (Blueprint \$table) {
            \$table->id();
            \$table->foreignId('pengajuan_judul_id')->constrained('pengajuan_juduls')->cascadeOnDelete();
            \$table->integer('persentase');
            \$table->text('keterangan');
            \$table->timestamps();
        });

        Schema::create('notifikasis', function (Blueprint \$table) {
            \$table->id();
            \$table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            \$table->string('judul');
            \$table->text('pesan');
            \$table->boolean('is_read')->default(false);
            \$table->timestamps();
        });

        Schema::create('fcm_tokens', function (Blueprint \$table) {
            \$table->id();
            \$table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            \$table->string('token');
            \$table->string('device_info')->nullable();
            \$table->timestamps();
        });

        Schema::create('audit_logs', function (Blueprint \$table) {
            \$table->id();
            \$table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            \$table->string('action');
            \$table->string('entity');
            \$table->unsignedBigInteger('entity_id');
            \$table->json('old_data')->nullable();
            \$table->json('new_data')->nullable();
            \$table->timestamps();
        });

        Schema::create('laporan_exports', function (Blueprint \$table) {
            \$table->id();
            \$table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            \$table->string('jenis_laporan');
            \$table->string('file_url')->nullable();
            \$table->string('status')->default('processing');
            \$table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('laporan_exports');
        Schema::dropIfExists('audit_logs');
        Schema::dropIfExists('fcm_tokens');
        Schema::dropIfExists('notifikasis');
        Schema::dropIfExists('progress_skripsis');
        Schema::dropIfExists('review_dokumens');
        Schema::dropIfExists('versi_dokumens');
        Schema::dropIfExists('dokumen_skripsis');
        Schema::dropIfExists('riwayat_bimbingans');
        Schema::dropIfExists('jadwal_bimbingans');
        Schema::dropIfExists('slot_bimbingans');
        Schema::dropIfExists('pergantian_pembimbings');
        Schema::dropIfExists('perubahan_juduls');
        Schema::dropIfExists('pembimbings');
        Schema::dropIfExists('riwayat_pengajuan_juduls');
        Schema::dropIfExists('pengajuan_juduls');
        Schema::dropIfExists('periode_skripsis');
        Schema::dropIfExists('dosen_bidang_keahlians');
        Schema::dropIfExists('bidang_keahlians');
        Schema::dropIfExists('dosens');
        Schema::dropIfExists('mahasiswas');
        Schema::dropIfExists('kelas');
        Schema::dropIfExists('semesters');
        Schema::dropIfExists('tahun_akademiks');
        Schema::dropIfExists('program_studis');
        Schema::dropIfExists('role_permissions');
        Schema::dropIfExists('permissions');
        Schema::dropIfExists('roles');
    }
};
PHP;

$timestamp = date('Y_m_d_His');
$migrationFile = __DIR__ . "/database/migrations/{$timestamp}_create_bimsi_ubsi_tables.php";
file_put_contents($migrationFile, $migrationContent);

echo "Successfully generated 28 models and combined migration file!\n";

