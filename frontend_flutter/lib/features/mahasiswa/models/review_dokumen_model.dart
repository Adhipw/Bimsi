class ReviewDokumenModel {
  final int id;
  final int versiDokumenId;
  final int dosenId;
  final String komentar;
  final String status; // 'approved', 'revisi', 'rejected'
  final String createdAt;
  final String? namaDosen;

  ReviewDokumenModel({
    required this.id,
    required this.versiDokumenId,
    required this.dosenId,
    required this.komentar,
    required this.status,
    required this.createdAt,
    this.namaDosen,
  });

  factory ReviewDokumenModel.fromJson(Map<String, dynamic> json) {
    String dateVal = json['created_at'] ?? '';
    if (dateVal.contains('T')) {
      dateVal = dateVal.split('T').first;
    }

    String? nameD;
    if (json['dosen'] != null && json['dosen']['user'] != null) {
      nameD = json['dosen']['user']['name']?.toString();
    }

    return ReviewDokumenModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      versiDokumenId: json['versi_dokumen_id'] is int 
          ? json['versi_dokumen_id'] 
          : int.parse(json['versi_dokumen_id'].toString()),
      dosenId: json['dosen_id'] is int ? json['dosen_id'] : int.parse(json['dosen_id'].toString()),
      komentar: json['komentar'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: dateVal,
      namaDosen: nameD,
    );
  }
}
