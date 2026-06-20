class ProgramStudiModel {
  final int id;
  final String kodeProdi;
  final String namaProdi;
  final String jenjang;

  ProgramStudiModel({
    required this.id,
    required this.kodeProdi,
    required this.namaProdi,
    required this.jenjang,
  });

  factory ProgramStudiModel.fromJson(Map<String, dynamic> json) {
    return ProgramStudiModel(
      id: json['id'],
      kodeProdi: json['kode_prodi'] ?? '',
      namaProdi: json['nama_prodi'] ?? '',
      jenjang: json['jenjang'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kode_prodi': kodeProdi,
      'nama_prodi': namaProdi,
      'jenjang': jenjang,
    };
  }
}
