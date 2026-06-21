class MahasiswaBebasPustakaModel {
  final String nim;
  final String nama;
  final String prodi;
  final String statusRevisi;
  bool suratBebasTerbit;

  MahasiswaBebasPustakaModel({
    required this.nim,
    required this.nama,
    required this.prodi,
    required this.statusRevisi,
    required this.suratBebasTerbit,
  });

  factory MahasiswaBebasPustakaModel.fromJson(Map<String, dynamic> json) {
    return MahasiswaBebasPustakaModel(
      nim: json['nim'] ?? '',
      nama: json['nama'] ?? '',
      prodi: json['prodi'] ?? '',
      statusRevisi: json['status_revisi'] ?? '',
      suratBebasTerbit: json['surat_bebas_terbit'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nim': nim,
      'nama': nama,
      'prodi': prodi,
      'status_revisi': statusRevisi,
      'surat_bebas_terbit': suratBebasTerbit,
    };
  }
}
