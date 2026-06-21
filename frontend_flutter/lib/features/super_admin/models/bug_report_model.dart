class BugReportModel {
  final String id;
  final String pelapor;
  final String judul;
  final String deskripsi;
  final String prioritas;
  String status;
  final String waktu;

  BugReportModel({
    required this.id,
    required this.pelapor,
    required this.judul,
    required this.deskripsi,
    required this.prioritas,
    required this.status,
    required this.waktu,
  });

  factory BugReportModel.fromJson(Map<String, dynamic> json) {
    return BugReportModel(
      id: json['id'] ?? '',
      pelapor: json['pelapor'] ?? '',
      judul: json['judul'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      prioritas: json['prioritas'] ?? 'Medium',
      status: json['status'] ?? 'Open',
      waktu: json['waktu'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pelapor': pelapor,
      'judul': judul,
      'deskripsi': deskripsi,
      'prioritas': prioritas,
      'status': status,
      'waktu': waktu,
    };
  }
}
