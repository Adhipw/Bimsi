import 'review_dokumen_model.dart';

class VersiDokumenModel {
  final int id;
  final int dokumenSkripsiId;
  final int versi;
  final String fileUrl;
  final String? catatanRevisi;
  final String createdAt;
  final List<ReviewDokumenModel> reviewDokumens;

  VersiDokumenModel({
    required this.id,
    required this.dokumenSkripsiId,
    required this.versi,
    required this.fileUrl,
    this.catatanRevisi,
    required this.createdAt,
    required this.reviewDokumens,
  });

  factory VersiDokumenModel.fromJson(Map<String, dynamic> json) {
    String dateVal = json['created_at'] ?? '';
    if (dateVal.contains('T')) {
      dateVal = dateVal.split('T').first;
    }

    final List list = json['review_dokumens'] ?? [];
    final reviews = list.map((item) => ReviewDokumenModel.fromJson(item)).toList();

    return VersiDokumenModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      dokumenSkripsiId: json['dokumen_skripsi_id'] is int 
          ? json['dokumen_skripsi_id'] 
          : int.parse(json['dokumen_skripsi_id'].toString()),
      versi: json['versi'] is int ? json['versi'] : int.parse(json['versi'].toString()),
      fileUrl: json['file_url'] ?? '',
      catatanRevisi: json['catatan_revisi']?.toString(),
      createdAt: dateVal,
      reviewDokumens: reviews,
    );
  }

  // Get status of the version based on the last review
  String get status {
    if (reviewDokumens.isEmpty) return 'pending';
    return reviewDokumens.first.status; // First or last depending on order
  }
}
