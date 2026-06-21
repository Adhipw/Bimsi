class DokumenResmiModel {
  final String nama;
  final String tanggal;
  final String keterangan;
  final String ukuran;
  final String url;

  DokumenResmiModel({
    required this.nama,
    required this.tanggal,
    required this.keterangan,
    required this.ukuran,
    required this.url,
  });

  factory DokumenResmiModel.fromJson(Map<String, dynamic> json) {
    return DokumenResmiModel(
      nama: json['nama'] ?? '',
      tanggal: json['tanggal'] ?? '',
      keterangan: json['keterangan'] ?? '',
      ukuran: json['ukuran'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'tanggal': tanggal,
      'keterangan': keterangan,
      'ukuran': ukuran,
      'url': url,
    };
  }
}
