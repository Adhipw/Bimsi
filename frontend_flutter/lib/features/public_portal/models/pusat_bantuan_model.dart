class PusatBantuanModel {
  final int id;
  final String kategori; // faq, dokumen_template
  final String judulPertanyaanAtauDokumen;
  final String isiJawabanAtauUrlFile;
  final bool isActive;

  PusatBantuanModel({
    required this.id,
    required this.kategori,
    required this.judulPertanyaanAtauDokumen,
    required this.isiJawabanAtauUrlFile,
    required this.isActive,
  });

  factory PusatBantuanModel.fromJson(Map<String, dynamic> json) {
    return PusatBantuanModel(
      id: json['id'],
      kategori: json['kategori'],
      judulPertanyaanAtauDokumen: json['judul_pertanyaan_atau_dokumen'],
      isiJawabanAtauUrlFile: json['isi_jawaban_atau_url_file'],
      isActive: json['is_active'] == 1 || json['is_active'] == true,
    );
  }
}
