class PendaftaranSidangModel {
  final int id;
  final int mahasiswaId;
  final int pengajuanJudulId;
  final String jenisSidang;
  final String? fileSyaratUrl;
  final String status;
  final String? keterangan;
  final bool accPembimbing;
  final String? tanggalAcc;
  final String? ttdDigitalHash;

  final int? turnitinScore;
  final String? turnitinFileUrl;
  final String? turnitinStatus;

  PendaftaranSidangModel({
    required this.id,
    required this.mahasiswaId,
    required this.pengajuanJudulId,
    required this.jenisSidang,
    this.fileSyaratUrl,
    required this.status,
    this.keterangan,
    required this.accPembimbing,
    this.tanggalAcc,
    this.ttdDigitalHash,
    this.turnitinScore,
    this.turnitinFileUrl,
    this.turnitinStatus,
  });

  factory PendaftaranSidangModel.fromJson(Map<String, dynamic> json) {
    return PendaftaranSidangModel(
      id: json['id'],
      mahasiswaId: json['mahasiswa_id'],
      pengajuanJudulId: json['pengajuan_judul_id'],
      jenisSidang: json['jenis_sidang'],
      fileSyaratUrl: json['file_syarat_url'],
      status: json['status'],
      keterangan: json['keterangan'],
      accPembimbing: json['acc_pembimbing'] == 1 || json['acc_pembimbing'] == true,
      tanggalAcc: json['tanggal_acc'],
      ttdDigitalHash: json['ttd_digital_hash'],
      turnitinScore: json['turnitin_score'],
      turnitinFileUrl: json['turnitin_file_url'],
      turnitinStatus: json['turnitin_status'],
    );
  }
}
