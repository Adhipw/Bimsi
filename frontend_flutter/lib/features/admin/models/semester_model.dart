class SemesterModel {
  final int id;
  final String nama;
  final bool isActive;

  SemesterModel({
    required this.id,
    required this.nama,
    required this.isActive,
  });

  factory SemesterModel.fromJson(Map<String, dynamic> json) {
    return SemesterModel(
      id: json['id'],
      nama: json['nama'] ?? '',
      isActive: json['is_active'] == true || json['is_active'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'is_active': isActive,
    };
  }
}
