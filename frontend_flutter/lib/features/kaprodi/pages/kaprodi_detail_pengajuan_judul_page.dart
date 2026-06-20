import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../mahasiswa/services/pengajuan_judul_service.dart';
import '../../mahasiswa/models/pengajuan_judul_model.dart';
import '../../../core/widgets/custom_text_field.dart';
 
class KaprodiDetailPengajuanJudulPage extends ConsumerStatefulWidget {
  final String id;
 
  const KaprodiDetailPengajuanJudulPage({super.key, required this.id});
 
  @override
  ConsumerState<KaprodiDetailPengajuanJudulPage> createState() => _KaprodiDetailPengajuanJudulPageState();
}
 
class _KaprodiDetailPengajuanJudulPageState extends ConsumerState<KaprodiDetailPengajuanJudulPage> {
  PengajuanJudulModel? _pengajuan;
  List<dynamic> _similarTitles = [];
  bool _isLoading = false;
  bool _isCheckingSimilarity = false;
  bool _isActionLoading = false;
 
  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }
 
  Future<void> _fetchDetail() async {
    setState(() {
      _isLoading = true;
    });
 
    try {
      final service = ref.read(pengajuanJudulServiceProvider);
      final detail = await service.getKaprodiDetail(int.parse(widget.id));
      setState(() {
        _pengajuan = detail;
      });
      // Ambil kemiripan judul setelah detail dimuat
      _checkSimilarity(detail.judul);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat detail pengajuan: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
 
  Future<void> _checkSimilarity(String judul) async {
    setState(() {
      _isCheckingSimilarity = true;
    });
 
    try {
      final service = ref.read(pengajuanJudulServiceProvider);
      final data = await service.cekKemiripan(judul, excludeId: int.parse(widget.id));
      setState(() {
        _similarTitles = data;
      });
    } catch (_) {
      // Abaikan error cek kemiripan agar tidak mengganggu flow utama
    } finally {
      setState(() {
        _isCheckingSimilarity = false;
      });
    }
  }
 
  Color _getStatusColor(String status) {
    switch (status) {
      case 'disetujui': return const Color(0xFF4CAF50);
      case 'revisi': return const Color(0xFFFF9800);
      case 'ditolak': return const Color(0xFFF44336);
      default: return const Color(0xFF2196F3);
    }
  }
 
  String _getStatusLabel(String status) {
    switch (status) {
      case 'disetujui': return 'DISETUJUI';
      case 'revisi': return 'BUTUH REVISI';
      case 'ditolak': return 'DITOLAK';
      default: return 'MENUNGGU VALIDASI';
    }
  }
 
  Future<void> _handleApprove() async {
    final catatanController = TextEditingController(text: 'Judul skripsi disetujui oleh Kaprodi.');
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Setujui Judul Skripsi', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Berikan catatan tambahan untuk mahasiswa (Opsional):', style: TextStyle(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 12),
            CustomTextField(
              label: 'Catatan Persetujuan',
              controller: catatanController,
              hint: 'Tulis pesan persetujuan...',
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4CAF50), foregroundColor: Colors.white),
            child: const Text('Setujui', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
 
    if (confirm == true) {
      _executeAction(() async {
        final service = ref.read(pengajuanJudulServiceProvider);
        await service.approveJudul(_pengajuan!.id, catatan: catatanController.text);
        return 'Judul skripsi berhasil disetujui!';
      });
    }
  }
 
  Future<void> _handleRejectOrRevision(String targetStatus) async {
    final catatanController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final isRevisi = targetStatus == 'revisi';
 
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          isRevisi ? 'Minta Revisi Judul' : 'Tolak Judul Skripsi',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isRevisi 
                  ? 'Masukkan kekurangan atau aspek yang perlu diperbaiki oleh mahasiswa:'
                  : 'Berikan alasan penolakan judul skripsi secara jelas:',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Catatan / Alasan',
                controller: catatanController,
                hint: 'Wajib diisi (min. 5 karakter)...',
                maxLines: 4,
                validator: (v) => v == null || v.trim().length < 5 
                    ? 'Catatan wajib diisi minimal 5 karakter' 
                    : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(ctx, true);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isRevisi ? const Color(0xFFFF9800) : const Color(0xFFF44336),
              foregroundColor: Colors.white,
            ),
            child: Text(
              isRevisi ? 'Minta Revisi' : 'Tolak',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
 
    if (confirm == true) {
      _executeAction(() async {
        final service = ref.read(pengajuanJudulServiceProvider);
        await service.rejectJudul(
          _pengajuan!.id,
          status: targetStatus,
          catatan: catatanController.text,
        );
        return isRevisi 
            ? 'Permintaan revisi berhasil dikirim ke mahasiswa.'
            : 'Pengajuan judul telah ditolak.';
      });
    }
  }
 
  Future<void> _executeAction(Future<String> Function() action) async {
    setState(() {
      _isActionLoading = true;
    });
 
    try {
      final successMsg = await action();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(successMsg), backgroundColor: Colors.green),
        );
        _fetchDetail(); // Refresh data detail
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tindakan gagal: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isActionLoading = false;
        });
      }
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Rincian Judul Skripsi', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF0056A6),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: _isLoading || _pengajuan == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Student Info Card
                  _buildStudentInfoCard(),
                  const SizedBox(height: 16),
                  
                  // Title Details Card
                  _buildTitleDetailsCard(),
                  const SizedBox(height: 16),
                  
                  // Similarity Detector Card
                  _buildSimilarityCheckCard(),
                  const SizedBox(height: 16),
                  
                  // Review Timeline/History Card
                  _buildHistoryCard(),
                  const SizedBox(height: 24),
                  
                  // Validation Action Area
                  if (_isActionLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (_pengajuan!.status == 'pending' || _pengajuan!.status == 'revisi')
                    _buildActionButtons()
                  else
                    _buildLockedStatusBanner(),
                ],
              ),
            ),
    );
  }
 
  Widget _buildStudentInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profil Pengaju',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF0056A6).withValues(alpha: 0.1),
                  child: const Icon(Icons.person, color: Color(0xFF0056A6)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _pengajuan!.namaMahasiswa ?? 'Mahasiswa',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1A1A1A)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'NIM: ${_pengajuan!.nimMahasiswa ?? "-"}',
                        style: const TextStyle(color: Color(0xFF555555), fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 12.0), child: Divider(height: 1)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Program Studi:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text(_pengajuan!.prodiMahasiswa ?? '-', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Periode Skripsi:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text(_pengajuan!.namaPeriode ?? '-', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
 
  Widget _buildTitleDetailsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Usulan Judul & Deskripsi',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(_pengajuan!.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _getStatusColor(_pengajuan!.status), width: 1),
                  ),
                  child: Text(
                    _getStatusLabel(_pengajuan!.status),
                    style: TextStyle(
                      color: _getStatusColor(_pengajuan!.status),
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _pengajuan!.judul,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            const Text(
              'Deskripsi / Rumusan Masalah:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF555555)),
            ),
            const SizedBox(height: 6),
            Text(
              _pengajuan!.deskripsi ?? 'Tidak ada deskripsi latar belakang.',
              style: const TextStyle(fontSize: 14, color: Color(0xFF333333), height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
 
  Widget _buildSimilarityCheckCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.analytics_outlined, color: Color(0xFF0056A6), size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Deteksi Kemiripan Judul (Database)',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                ),
                if (_isCheckingSimilarity) ...[
                  const SizedBox(width: 12),
                  const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)),
                ]
              ],
            ),
            const SizedBox(height: 12),
            if (!_isCheckingSimilarity && _similarTitles.isEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Aman. Tidak terdeteksi judul lain yang memiliki kemiripan signifikan di database.',
                        style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              const Text(
                'Usulan judul ini memiliki kemiripan dengan judul-judul skripsi berikut:',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              ..._similarTitles.map((item) {
                final int score = item['persentase'] ?? 0;
                final Color scoreColor = score >= 50 ? Colors.red : (score >= 30 ? Colors.orange : Colors.blue);
                final List keywords = item['kata_kunci_cocok'] ?? [];
 
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${item['mahasiswa']} (${item['nim']})',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF555555)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '$score% Mirip',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: scoreColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['judul'],
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF222222)),
                      ),
                      if (keywords.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: keywords.map<Widget>((kw) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: scoreColor.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: scoreColor.withValues(alpha: 0.3), width: 0.5),
                            ),
                            child: Text(
                              kw.toString(),
                              style: TextStyle(fontSize: 10, color: scoreColor, fontWeight: FontWeight.bold),
                            ),
                          )).toList(),
                        ),
                      ]
                    ],
                  ),
                );
              }),
            ]
          ],
        ),
      ),
    );
  }
 
  Widget _buildHistoryCard() {
    final riwayat = _pengajuan!.riwayat;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Riwayat Status & Catatan Kaprodi',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            if (riwayat.isEmpty)
              const Text('Belum ada riwayat perubahan status.', style: TextStyle(fontSize: 13, color: Colors.grey))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: riwayat.length,
                itemBuilder: (context, idx) {
                  final item = riwayat[idx];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left status circle marker
                        Column(
                          children: [
                            Icon(
                              item.statusBaru == 'disetujui' 
                                  ? Icons.check_circle 
                                  : (item.statusBaru == 'revisi' ? Icons.warning : Icons.info),
                              color: _getStatusColor(item.statusBaru),
                              size: 20,
                            ),
                            if (idx < riwayat.length - 1)
                              Container(width: 2, height: 40, color: Colors.grey.shade300),
                          ],
                        ),
                        const SizedBox(width: 12),
                        // Right content card
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item.statusBaru.toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold, 
                                      fontSize: 12, 
                                      color: _getStatusColor(item.statusBaru),
                                    ),
                                  ),
                                  Text(
                                    item.createdAt.split('T').first,
                                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                                  ),
                                ],
                              ),
                              if (item.keterangan != null && item.keterangan!.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  item.keterangan!,
                                  style: const TextStyle(fontSize: 13, color: Color(0xFF444444)),
                                ),
                              ]
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
 
  Widget _buildActionButtons() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _handleApprove,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 16),
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text('Setujui Judul Skripsi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _handleRejectOrRevision('revisi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9800),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Minta Revisi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _handleRejectOrRevision('ditolak'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF44336),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Tolak Judul', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ],
    );
  }
 
  Widget _buildLockedStatusBanner() {
    final status = _pengajuan!.status;
    final isDisetujui = status == 'disetujui';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDisetujui ? Colors.green.withValues(alpha: 0.08) : Colors.red.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDisetujui ? Colors.green.withValues(alpha: 0.3) : Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(isDisetujui ? Icons.check_circle_outline : Icons.highlight_off, color: isDisetujui ? Colors.green : Colors.red, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isDisetujui 
                  ? 'Judul skripsi ini telah disetujui. Pengubahan status tidak lagi dapat dilakukan.'
                  : 'Pengajuan judul ini telah ditolak. Mahasiswa harus mengajukan judul skripsi baru.',
              style: TextStyle(fontSize: 13, color: isDisetujui ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
