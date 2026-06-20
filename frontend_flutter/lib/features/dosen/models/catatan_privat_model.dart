class CatatanPrivatModel {
  final int id;
  final int dosenId;
  final int mahasiswaId;
  final String catatan;

  CatatanPrivatModel({
    required this.id,
    required this.dosenId,
    required this.mahasiswaId,
    required this.catatan,
  });

  factory CatatanPrivatModel.fromJson(Map<String, dynamic> json) {
    return CatatanPrivatModel(
      id: json['id'],
      dosenId: json['dosen_id'],
      mahasiswaId: json['mahasiswa_id'],
      catatan: json['catatan'],
    );
  }
}
