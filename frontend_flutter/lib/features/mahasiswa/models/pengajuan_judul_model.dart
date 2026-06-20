import 'pembimbing_model.dart';
 
class RiwayatPengajuanModel {
  final int id;
  final String statusSebelumnya;
  final String statusBaru;
  final String? keterangan;
  final String createdAt;
 
  RiwayatPengajuanModel({
    required this.id,
    required this.statusSebelumnya,
    required this.statusBaru,
    this.keterangan,
    required this.createdAt,
  });
 
  factory RiwayatPengajuanModel.fromJson(Map<String, dynamic> json) {
    return RiwayatPengajuanModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      statusSebelumnya: json['status_sebelumnya'] ?? '',
      statusBaru: json['status_baru'] ?? '',
      keterangan: json['keterangan'],
      createdAt: json['created_at'] ?? '',
    );
  }
}
 
class PengajuanJudulModel {
  final int id;
  final int mahasiswaId;
  final int periodeSkripsiId;
  final String judul;
  final String? deskripsi;
  final String status;
  final String? namaPeriode;
  final String? namaMahasiswa;
  final String? nimMahasiswa;
  final String? prodiMahasiswa;
  final int? totalPersentase;
  final List<RiwayatPengajuanModel> riwayat;
  final List<PembimbingModel> pembimbings;
 
  PengajuanJudulModel({
    required this.id,
    required this.mahasiswaId,
    required this.periodeSkripsiId,
    required this.judul,
    this.deskripsi,
    required this.status,
    this.namaPeriode,
    this.namaMahasiswa,
    this.nimMahasiswa,
    this.prodiMahasiswa,
    this.totalPersentase,
    this.riwayat = const [],
    this.pembimbings = const [],
  });
 
  factory PengajuanJudulModel.fromJson(Map<String, dynamic> json) {
    // Extract Student Info if nested
    String? name;
    String? nim;
    String? prodi;
    if (json['mahasiswa'] != null) {
      final mhs = json['mahasiswa'];
      nim = mhs['nim']?.toString();
      if (mhs['user'] != null) {
        name = mhs['user']['name']?.toString();
      }
      if (mhs['program_studi'] != null) {
        prodi = mhs['program_studi']['nama_prodi']?.toString();
      }
    }
 
    // Parse riwayat
    List<RiwayatPengajuanModel> riwayatList = [];
    if (json['riwayat_pengajuans'] != null && json['riwayat_pengajuans'] is List) {
      riwayatList = (json['riwayat_pengajuans'] as List)
          .map((item) => RiwayatPengajuanModel.fromJson(item))
          .toList();
    }
 
    // Parse pembimbings
    List<PembimbingModel> pembimbingList = [];
    if (json['pembimbings'] != null && json['pembimbings'] is List) {
      pembimbingList = (json['pembimbings'] as List)
          .map((item) => PembimbingModel.fromJson(item))
          .toList();
    }
 
    return PengajuanJudulModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      mahasiswaId: json['mahasiswa_id'] is int ? json['mahasiswa_id'] : int.parse(json['mahasiswa_id'].toString()),
      periodeSkripsiId: json['periode_skripsi_id'] is int ? json['periode_skripsi_id'] : int.parse(json['periode_skripsi_id'].toString()),
      judul: json['judul'] ?? '',
      deskripsi: json['deskripsi'],
      status: json['status'] ?? 'pending',
      namaPeriode: json['periode_skripsi'] != null ? json['periode_skripsi']['nama_periode'] : null,
      namaMahasiswa: name,
      nimMahasiswa: nim,
      prodiMahasiswa: prodi,
      totalPersentase: json['total_persentase'] is int ? json['total_persentase'] : (json['total_persentase'] != null ? int.tryParse(json['total_persentase'].toString()) : null),
      riwayat: riwayatList,
      pembimbings: pembimbingList,
    );
  }
 
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mahasiswa_id': mahasiswaId,
      'periode_skripsi_id': periodeSkripsiId,
      'judul': judul,
      'deskripsi': deskripsi,
      'status': status,
    };
  }
}
