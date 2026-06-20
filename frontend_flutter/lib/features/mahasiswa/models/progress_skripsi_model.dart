class ProgressSkripsiModel {
  final int id;
  final int pengajuanJudulId;
  final String bab;
  final String status;
  final int persentase;
  final String keterangan;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProgressSkripsiModel({
    required this.id,
    required this.pengajuanJudulId,
    required this.bab,
    required this.status,
    required this.persentase,
    required this.keterangan,
    this.createdAt,
    this.updatedAt,
  });

  factory ProgressSkripsiModel.fromJson(Map<String, dynamic> json) {
    return ProgressSkripsiModel(
      id: json['id'],
      pengajuanJudulId: json['pengajuan_judul_id'],
      bab: json['bab'] ?? '-',
      status: json['status'] ?? 'pending',
      persentase: json['persentase'] ?? 0,
      keterangan: json['keterangan'] ?? '-',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pengajuan_judul_id': pengajuanJudulId,
      'bab': bab,
      'status': status,
      'persentase': persentase,
      'keterangan': keterangan,
    };
  }
}
