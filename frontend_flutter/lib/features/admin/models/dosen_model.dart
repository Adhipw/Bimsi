import '../../auth/models/user_model.dart';

class DosenModel {
  final int id;
  final int userId;
  final String nidn;
  final String jabatanFungsional;
  final int kuotaBimbingan;
  final UserModel? user;
  final List<dynamic>? bidangKeahlians;

  DosenModel({
    required this.id,
    required this.userId,
    required this.nidn,
    required this.jabatanFungsional,
    required this.kuotaBimbingan,
    this.user,
    this.bidangKeahlians,
  });

  factory DosenModel.fromJson(Map<String, dynamic> json) {
    return DosenModel(
      id: json['id'],
      userId: json['user_id'] ?? 0,
      nidn: json['nidn'] ?? '',
      jabatanFungsional: json['jabatan_fungsional'] ?? '',
      kuotaBimbingan: json['kuota_bimbingan'] ?? 10,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      bidangKeahlians: json['bidang_keahlians'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'nidn': nidn,
      'jabatan_fungsional': jabatanFungsional,
      'kuota_bimbingan': kuotaBimbingan,
    };
  }
}
