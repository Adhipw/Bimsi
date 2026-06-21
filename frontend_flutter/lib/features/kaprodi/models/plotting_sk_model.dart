class PlottingSkModel {
  final String nim;
  final String nama;
  final String prodi;
  final String dosenPembimbing;
  final String statusSk;

  PlottingSkModel({
    required this.nim,
    required this.nama,
    required this.prodi,
    required this.dosenPembimbing,
    required this.statusSk,
  });

  factory PlottingSkModel.fromJson(Map<String, dynamic> json) {
    return PlottingSkModel(
      nim: json['nim'] ?? '',
      nama: json['nama'] ?? '',
      prodi: json['prodi'] ?? '',
      dosenPembimbing: json['dosen_pembimbing'] ?? '',
      statusSk: json['status_sk'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nim': nim,
      'nama': nama,
      'prodi': prodi,
      'dosen_pembimbing': dosenPembimbing,
      'status_sk': statusSk,
    };
  }
}
