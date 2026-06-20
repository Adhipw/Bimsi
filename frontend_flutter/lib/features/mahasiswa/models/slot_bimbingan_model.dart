class SlotBimbinganModel {
  final int id;
  final int dosenId;
  final String hari;
  final String jamMulai;
  final String jamSelesai;
  final int kuota;
 
  SlotBimbinganModel({
    required this.id,
    required this.dosenId,
    required this.hari,
    required this.jamMulai,
    required this.jamSelesai,
    required this.kuota,
  });
 
  factory SlotBimbinganModel.fromJson(Map<String, dynamic> json) {
    // Standardize time strings to H:i
    String formatTime(dynamic timeVal) {
      if (timeVal == null) return '';
      final str = timeVal.toString();
      if (str.length >= 5) {
        return str.substring(0, 5); // Ambil format HH:MM
      }
      return str;
    }
 
    return SlotBimbinganModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      dosenId: json['dosen_id'] is int ? json['dosen_id'] : int.parse(json['dosen_id'].toString()),
      hari: json['hari'] ?? '',
      jamMulai: formatTime(json['jam_mulai']),
      jamSelesai: formatTime(json['jam_selesai']),
      kuota: json['kuota'] is int ? json['kuota'] : int.parse(json['kuota'].toString()),
    );
  }
 
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dosen_id': dosenId,
      'hari': hari,
      'jam_mulai': jamMulai,
      'jam_selesai': jamSelesai,
      'kuota': kuota,
    };
  }
}
