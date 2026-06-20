import 'program_studi_model.dart';

class KelasModel {
  final int id;
  final String namaKelas;
  final int programStudiId;
  final ProgramStudiModel? programStudi;

  KelasModel({
    required this.id,
    required this.namaKelas,
    required this.programStudiId,
    this.programStudi,
  });

  factory KelasModel.fromJson(Map<String, dynamic> json) {
    return KelasModel(
      id: json['id'],
      namaKelas: json['nama_kelas'] ?? '',
      programStudiId: json['program_studi_id'] ?? 0,
      programStudi: json['program_studi'] != null
          ? ProgramStudiModel.fromJson(json['program_studi'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_kelas': namaKelas,
      'program_studi_id': programStudiId,
    };
  }
}
