class DosenKuotaModel {
  final String nidn;
  final String nama;
  final String jabatan;
  int kuotaMaksimal;
  final int terisi;

  DosenKuotaModel({
    required this.nidn,
    required this.nama,
    required this.jabatan,
    required this.kuotaMaksimal,
    required this.terisi,
  });

  factory DosenKuotaModel.fromJson(Map<String, dynamic> json) {
    return DosenKuotaModel(
      nidn: json['nidn'] ?? '',
      nama: json['nama'] ?? '',
      jabatan: json['jabatan'] ?? '',
      kuotaMaksimal: json['kuota_maksimal'] ?? 0,
      terisi: json['terisi'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nidn': nidn,
      'nama': nama,
      'jabatan': jabatan,
      'kuota_maksimal': kuotaMaksimal,
      'terisi': terisi,
    };
  }
}
