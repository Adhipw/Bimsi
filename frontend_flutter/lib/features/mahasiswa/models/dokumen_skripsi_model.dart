import 'versi_dokumen_model.dart';

class DokumenSkripsiModel {
  final int id;
  final int pengajuanJudulId;
  final String jenisDokumen; // 'proposal', 'bab1', 'bab2', 'bab3', 'bab4', 'bab5', 'final'
  final String fileUrl;
  final String createdAt;
  final List<VersiDokumenModel> versiDokumens;

  // Extra metadata
  final String? namaMahasiswa;
  final String? nimMahasiswa;
  final String? kelasMahasiswa;
  final String? judulSkripsi;

  DokumenSkripsiModel({
    required this.id,
    required this.pengajuanJudulId,
    required this.jenisDokumen,
    required this.fileUrl,
    required this.createdAt,
    required this.versiDokumens,
    this.namaMahasiswa,
    this.nimMahasiswa,
    this.kelasMahasiswa,
    this.judulSkripsi,
  });

  factory DokumenSkripsiModel.fromJson(Map<String, dynamic> json) {
    String dateVal = json['created_at'] ?? '';
    if (dateVal.contains('T')) {
      dateVal = dateVal.split('T').first;
    }

    final List list = json['versi_dokumens'] ?? [];
    final versions = list.map((item) => VersiDokumenModel.fromJson(item)).toList();
    // Sort versions by version number descending so version.first is the latest
    versions.sort((a, b) => b.versi.compareTo(a.versi));

    String? nameM;
    String? nimM;
    String? kelasM;
    String? judulS;

    if (json['pengajuan_judul'] != null) {
      final pj = json['pengajuan_judul'];
      judulS = pj['judul']?.toString();

      if (pj['mahasiswa'] != null) {
        final mhs = pj['mahasiswa'];
        nimM = mhs['nim']?.toString();
        if (mhs['user'] != null) {
          nameM = mhs['user']['name']?.toString();
        }
        if (mhs['kelas'] != null) {
          kelasM = mhs['kelas']['nama_kelas']?.toString();
        }
      }
    }

    return DokumenSkripsiModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      pengajuanJudulId: json['pengajuan_judul_id'] is int 
          ? json['pengajuan_judul_id'] 
          : int.parse(json['pengajuan_judul_id'].toString()),
      jenisDokumen: json['jenis_dokumen'] ?? '',
      fileUrl: json['file_url'] ?? '',
      createdAt: dateVal,
      versiDokumens: versions,
      namaMahasiswa: nameM,
      nimMahasiswa: nimM,
      kelasMahasiswa: kelasM,
      judulSkripsi: judulS,
    );
  }

  // Get localized label for types
  String get jenisDokumenLabel {
    switch (jenisDokumen) {
      case 'proposal': return 'Proposal Skripsi';
      case 'bab1': return 'BAB I (Pendahuluan)';
      case 'bab2': return 'BAB II (Tinjauan Pustaka)';
      case 'bab3': return 'BAB III (Metodologi)';
      case 'bab4': return 'BAB IV (Hasil & Pembahasan)';
      case 'bab5': return 'BAB V (Penutup)';
      case 'final': return 'Laporan Akhir (Final)';
      default: return jenisDokumen;
    }
  }

  // Get latest version's status
  String get latestStatus {
    if (versiDokumens.isEmpty) return 'pending';
    return versiDokumens.first.status;
  }

  // Get latest version's URL
  String get latestFileUrl {
    if (versiDokumens.isEmpty) return fileUrl;
    return versiDokumens.first.fileUrl;
  }

  // Get latest version's version number
  int get latestVersionNumber {
    if (versiDokumens.isEmpty) return 1;
    return versiDokumens.first.versi;
  }
}
