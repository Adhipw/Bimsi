class PesanDiskusiModel {
  final int id;
  final String pengirim;
  final String waktu;
  final String pesan;
  final bool isMe;

  PesanDiskusiModel({
    required this.id,
    required this.pengirim,
    required this.waktu,
    required this.pesan,
    required this.isMe,
  });

  factory PesanDiskusiModel.fromJson(Map<String, dynamic> json) {
    return PesanDiskusiModel(
      id: json['id'] ?? 0,
      pengirim: json['pengirim'] ?? '',
      waktu: json['waktu'] ?? '',
      pesan: json['pesan'] ?? '',
      isMe: json['isMe'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pengirim': pengirim,
      'waktu': waktu,
      'pesan': pesan,
      'isMe': isMe,
    };
  }
}
