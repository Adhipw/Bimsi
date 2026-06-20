class LogbookModel {
  final int id;
  final int mahasiswaId;
  final int pengajuanJudulId;
  final int dosenId;
  final String tanggalKegiatan;
  final String deskripsiKegiatan;
  final String? buktiFileUrl;
  final String statusApproval;

  LogbookModel({
    required this.id,
    required this.mahasiswaId,
    required this.pengajuanJudulId,
    required this.dosenId,
    required this.tanggalKegiatan,
    required this.deskripsiKegiatan,
    this.buktiFileUrl,
    required this.statusApproval,
  });

  factory LogbookModel.fromJson(Map<String, dynamic> json) {
    return LogbookModel(
      id: json['id'],
      mahasiswaId: json['mahasiswa_id'],
      pengajuanJudulId: json['pengajuan_judul_id'],
      dosenId: json['dosen_id'],
      tanggalKegiatan: json['tanggal_kegiatan'],
      deskripsiKegiatan: json['deskripsi_kegiatan'],
      buktiFileUrl: json['bukti_file_url'],
      statusApproval: json['status_approval'],
    );
  }
}
