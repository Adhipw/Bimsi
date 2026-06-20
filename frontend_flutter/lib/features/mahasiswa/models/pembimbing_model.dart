class PembimbingModel {
  final int id;
  final int pengajuanJudulId;
  final int dosenId;
  final String peran;
  final String status;
 
  // Dosen Info
  final String? namaDosen;
  final String? nidnDosen;
  final String? jabatanDosen;
  final List<String> bidangKeahlian;
 
  // Mahasiswa & Judul Info (Untuk view Dosen)
  final String? mahasiswaNama;
  final String? mahasiswaNim;
  final String? mahasiswaProdi;
  final String? mahasiswaKelas;
  final String? judulSkripsi;
  final String? periodeNama;
 
  PembimbingModel({
    required this.id,
    required this.pengajuanJudulId,
    required this.dosenId,
    required this.peran,
    required this.status,
    this.namaDosen,
    this.nidnDosen,
    this.jabatanDosen,
    this.bidangKeahlian = const [],
    this.mahasiswaNama,
    this.mahasiswaNim,
    this.mahasiswaProdi,
    this.mahasiswaKelas,
    this.judulSkripsi,
    this.periodeNama,
  });
 
  factory PembimbingModel.fromJson(Map<String, dynamic> json) {
    // Parse Dosen Info
    String? nama;
    String? nidn;
    String? jabatan;
    List<String> keahlianList = [];
 
    if (json['dosen'] != null) {
      final dosen = json['dosen'];
      nidn = dosen['nidn']?.toString();
      jabatan = dosen['jabatan_fungsional']?.toString();
 
      if (dosen['user'] != null) {
        nama = dosen['user']['name']?.toString();
      }
 
      if (dosen['bidang_keahlians'] != null && dosen['bidang_keahlians'] is List) {
        keahlianList = (dosen['bidang_keahlians'] as List)
            .map((bk) => bk['nama_bidang']?.toString() ?? '')
            .where((val) => val.isNotEmpty)
            .toList();
      }
    }
 
    // Parse Mahasiswa & Judul Info
    String? mhsNama;
    String? mhsNim;
    String? mhsProdi;
    String? mhsKelas;
    String? judul;
    String? periode;
 
    if (json['pengajuan_judul'] != null) {
      final pj = json['pengajuan_judul'];
      judul = pj['judul']?.toString();
 
      if (pj['periode_skripsi'] != null) {
        periode = pj['periode_skripsi']['nama_periode']?.toString();
      }
 
      if (pj['mahasiswa'] != null) {
        final mhs = pj['mahasiswa'];
        mhsNim = mhs['nim']?.toString();
 
        if (mhs['user'] != null) {
          mhsNama = mhs['user']['name']?.toString();
        }
 
        if (mhs['program_studi'] != null) {
          mhsProdi = mhs['program_studi']['nama_prodi']?.toString();
        }
 
        if (mhs['kelas'] != null) {
          mhsKelas = mhs['kelas']['nama_kelas']?.toString();
        }
      }
    }
 
    return PembimbingModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      pengajuanJudulId: json['pengajuan_judul_id'] is int ? json['pengajuan_judul_id'] : int.parse(json['pengajuan_judul_id'].toString()),
      dosenId: json['dosen_id'] is int ? json['dosen_id'] : int.parse(json['dosen_id'].toString()),
      peran: json['peran'] ?? '',
      status: json['status'] ?? 'aktif',
      namaDosen: nama,
      nidnDosen: nidn,
      jabatanDosen: jabatan,
      bidangKeahlian: keahlianList,
      mahasiswaNama: mhsNama,
      mahasiswaNim: mhsNim,
      mahasiswaProdi: mhsProdi,
      mahasiswaKelas: mhsKelas,
      judulSkripsi: judul,
      periodeNama: periode,
    );
  }
}
