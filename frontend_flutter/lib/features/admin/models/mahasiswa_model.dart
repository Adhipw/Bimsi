import '../../auth/models/user_model.dart';
import 'program_studi_model.dart';
import 'kelas_model.dart';

class MahasiswaModel {
  final int id;
  final int userId;
  final String nim;
  final int programStudiId;
  final int kelasId;
  final String tahunMasuk;
  final UserModel? user;
  final ProgramStudiModel? programStudi;
  final KelasModel? kelas;

  MahasiswaModel({
    required this.id,
    required this.userId,
    required this.nim,
    required this.programStudiId,
    required this.kelasId,
    required this.tahunMasuk,
    this.user,
    this.programStudi,
    this.kelas,
  });

  factory MahasiswaModel.fromJson(Map<String, dynamic> json) {
    return MahasiswaModel(
      id: json['id'],
      userId: json['user_id'] ?? 0,
      nim: json['nim'] ?? '',
      programStudiId: json['program_studi_id'] ?? 0,
      kelasId: json['kelas_id'] ?? 0,
      tahunMasuk: json['tahun_masuk'] ?? '',
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      programStudi: json['program_studi'] != null
          ? ProgramStudiModel.fromJson(json['program_studi'])
          : null,
      kelas: json['kelas'] != null ? KelasModel.fromJson(json['kelas']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'nim': nim,
      'program_studi_id': programStudiId,
      'kelas_id': kelasId,
      'tahun_masuk': tahunMasuk,
    };
  }
}
