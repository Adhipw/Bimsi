import 'jadwal_bimbingan_model.dart';

class RiwayatBimbinganModel {
  final int id;
  final int jadwalBimbinganId;
  final String? catatanMahasiswa;
  final String catatanDosen;
  final String status; // 'selesai' or 'revisi'
  final String createdAt;

  // Nested Details
  final JadwalBimbinganModel? jadwalBimbingan;

  RiwayatBimbinganModel({
    required this.id,
    required this.jadwalBimbinganId,
    this.catatanMahasiswa,
    required this.catatanDosen,
    required this.status,
    required this.createdAt,
    this.jadwalBimbingan,
  });

  factory RiwayatBimbinganModel.fromJson(Map<String, dynamic> json) {
    JadwalBimbinganModel? jadwal;
    if (json['jadwal_bimbingan'] != null) {
      jadwal = JadwalBimbinganModel.fromJson(json['jadwal_bimbingan']);
    }

    // Parse created_at date
    String dateVal = json['created_at'] ?? '';
    if (dateVal.contains('T')) {
      dateVal = dateVal.split('T').first;
    }

    return RiwayatBimbinganModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      jadwalBimbinganId: json['jadwal_bimbingan_id'] is int 
          ? json['jadwal_bimbingan_id'] 
          : int.parse(json['jadwal_bimbingan_id'].toString()),
      catatanMahasiswa: json['catatan_mahasiswa']?.toString(),
      catatanDosen: json['catatan_dosen']?.toString() ?? '',
      status: json['status'] ?? 'selesai',
      createdAt: dateVal,
      jadwalBimbingan: jadwal,
    );
  }

  // Get helper attributes for easy presentation
  String get namaMahasiswa => jadwalBimbingan?.namaMahasiswa ?? '-';
  String get nimMahasiswa => jadwalBimbingan?.nimMahasiswa ?? '-';
  String get kelasMahasiswa => jadwalBimbingan?.kelasMahasiswa ?? '-';
  String get prodiMahasiswa => jadwalBimbingan?.prodiMahasiswa ?? '-';
  String get judulSkripsi => jadwalBimbingan?.judulSkripsi ?? '-';
  String get namaDosen => jadwalBimbingan?.namaDosen ?? '-';
  String get tanggalBimbingan => jadwalBimbingan?.tanggal ?? '-';
  String get slotWaktu {
    final slot = jadwalBimbingan?.slotBimbingan;
    return slot != null ? '${slot.hari} (${slot.jamMulai} - ${slot.jamSelesai})' : '-';
  }
}
