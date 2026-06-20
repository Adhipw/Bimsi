class ReferensiModel {
  final int id;
  final int mahasiswaId;
  final int pengajuanJudulId;
  final String judulArtikel;
  final String? penulis;
  final String? tahunTerbit;
  final String? urlTautan;
  final String tipeReferensi; // jurnal, buku, website

  ReferensiModel({
    required this.id,
    required this.mahasiswaId,
    required this.pengajuanJudulId,
    required this.judulArtikel,
    this.penulis,
    this.tahunTerbit,
    this.urlTautan,
    required this.tipeReferensi,
  });

  factory ReferensiModel.fromJson(Map<String, dynamic> json) {
    return ReferensiModel(
      id: json['id'],
      mahasiswaId: json['mahasiswa_id'],
      pengajuanJudulId: json['pengajuan_judul_id'],
      judulArtikel: json['judul_artikel'],
      penulis: json['penulis'],
      tahunTerbit: json['tahun_terbit'],
      urlTautan: json['url_tautan'],
      tipeReferensi: json['tipe_referensi'],
    );
  }
}
