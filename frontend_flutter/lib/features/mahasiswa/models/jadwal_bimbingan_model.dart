import 'slot_bimbingan_model.dart';
 
class JadwalBimbinganModel {
  final int id;
  final int pembimbingId;
  final int slotBimbinganId;
  final String tanggal;
  final String status;
 
  // Nested Details
  final SlotBimbinganModel? slotBimbingan;
  final String? namaDosen;
  final String? namaMahasiswa;
  final String? nimMahasiswa;
  final String? prodiMahasiswa;
  final String? kelasMahasiswa;
  final String? judulSkripsi;
 
  JadwalBimbinganModel({
    required this.id,
    required this.pembimbingId,
    required this.slotBimbinganId,
    required this.tanggal,
    required this.status,
    this.slotBimbingan,
    this.namaDosen,
    this.namaMahasiswa,
    this.nimMahasiswa,
    this.prodiMahasiswa,
    this.kelasMahasiswa,
    this.judulSkripsi,
  });
 
  factory JadwalBimbinganModel.fromJson(Map<String, dynamic> json) {
    // Standardize date
    String formatVal = json['tanggal'] ?? '';
    if (formatVal.contains('T')) {
      formatVal = formatVal.split('T').first;
    }
 
    // Parse Slot
    SlotBimbinganModel? slot;
    if (json['slot_bimbingan'] != null) {
      slot = SlotBimbinganModel.fromJson(json['slot_bimbingan']);
    }
 
    // Parse Lecturer & Student Info from Pembimbing relation
    String? nameD;
    String? nameM;
    String? nimM;
    String? prodiM;
    String? kelasM;
    String? judulS;
 
    if (json['pembimbing'] != null) {
      final pb = json['pembimbing'];
      if (pb['dosen'] != null && pb['dosen']['user'] != null) {
        nameD = pb['dosen']['user']['name']?.toString();
      }
 
      if (pb['pengajuan_judul'] != null) {
        final pj = pb['pengajuan_judul'];
        judulS = pj['judul']?.toString();
 
        if (pj['mahasiswa'] != null) {
          final mhs = pj['mahasiswa'];
          nimM = mhs['nim']?.toString();
          if (mhs['user'] != null) {
            nameM = mhs['user']['name']?.toString();
          }
          if (mhs['program_studi'] != null) {
            prodiM = mhs['program_studi']['nama_prodi']?.toString();
          }
          if (mhs['kelas'] != null) {
            kelasM = mhs['kelas']['nama_kelas']?.toString();
          }
        }
      }
    }
 
    return JadwalBimbinganModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      pembimbingId: json['pembimbing_id'] is int ? json['pembimbing_id'] : int.parse(json['pembimbing_id'].toString()),
      slotBimbinganId: json['slot_bimbingan_id'] is int ? json['slot_bimbingan_id'] : int.parse(json['slot_bimbingan_id'].toString()),
      tanggal: formatVal,
      status: json['status'] ?? 'scheduled',
      slotBimbingan: slot,
      namaDosen: nameD,
      namaMahasiswa: nameM,
      nimMahasiswa: nimM,
      prodiMahasiswa: prodiM,
      kelasMahasiswa: kelasM,
      judulSkripsi: judulS,
    );
  }
}
