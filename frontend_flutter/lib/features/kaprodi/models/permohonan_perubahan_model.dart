class PermohonanPerubahanModel {
  final String nim;
  final String nama;
  final String jenis;
  final String alasan;
  final String tanggal;

  PermohonanPerubahanModel({
    required this.nim,
    required this.nama,
    required this.jenis,
    required this.alasan,
    required this.tanggal,
  });

  factory PermohonanPerubahanModel.fromJson(Map<String, dynamic> json) {
    return PermohonanPerubahanModel(
      nim: json['nim'] ?? '',
      nama: json['nama'] ?? '',
      jenis: json['jenis'] ?? '',
      alasan: json['alasan'] ?? '',
      tanggal: json['tanggal'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nim': nim,
      'nama': nama,
      'jenis': jenis,
      'alasan': alasan,
      'tanggal': tanggal,
    };
  }
}
