class TahunAkademikModel {
  final int id;
  final String tahun;
  final bool isActive;

  TahunAkademikModel({
    required this.id,
    required this.tahun,
    required this.isActive,
  });

  factory TahunAkademikModel.fromJson(Map<String, dynamic> json) {
    return TahunAkademikModel(
      id: json['id'],
      tahun: json['tahun'] ?? '',
      isActive: json['is_active'] == true || json['is_active'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tahun': tahun,
      'is_active': isActive,
    };
  }
}
