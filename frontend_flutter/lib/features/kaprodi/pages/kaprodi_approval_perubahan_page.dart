import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../shared/layouts/responsive_scaffold.dart';
import '../models/permohonan_perubahan_model.dart';

class KaprodiApprovalPerubahanPage extends ConsumerStatefulWidget {
  const KaprodiApprovalPerubahanPage({super.key});

  @override
  ConsumerState<KaprodiApprovalPerubahanPage> createState() => _KaprodiApprovalPerubahanPageState();
}

class _KaprodiApprovalPerubahanPageState extends ConsumerState<KaprodiApprovalPerubahanPage> {
  final List<PermohonanPerubahanModel> _permohonanList = [
    PermohonanPerubahanModel(
      nim: '12200111',
      nama: 'Ahmad Fadillah',
      jenis: 'Perubahan Judul',
      alasan: 'Saran dari dosen pembimbing untuk lebih spesifik.',
      tanggal: '18 Jun 2026',
    ),
    PermohonanPerubahanModel(
      nim: '12200222',
      nama: 'Siti Aminah',
      jenis: 'Pergantian Pembimbing',
      alasan: 'Dosen pembimbing sebelumnya sedang cuti studi lanjut.',
      tanggal: '19 Jun 2026',
    ),
    PermohonanPerubahanModel(
      nim: '12200333',
      nama: 'Budi Santoso',
      jenis: 'Perubahan Judul',
      alasan: 'Kesulitan mencari dataset terkait judul awal.',
      tanggal: '20 Jun 2026',
    ),
  ];

  void _handleApproval(String nim, bool isApproved) {
    setState(() {
      _permohonanList.removeWhere((p) => p.nim == nim);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isApproved ? 'Permohonan disetujui.' : 'Permohonan ditolak.'),
        backgroundColor: isApproved ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Approval Perubahan',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daftar Permohonan Perubahan',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Review dan berikan keputusan (Setujui / Tolak) atas permohonan perubahan judul atau dosen pembimbing.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            
            if (_permohonanList.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text('Tidak ada permohonan baru.', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _permohonanList.length,
                itemBuilder: (context, index) {
                  final item = _permohonanList[index];

                  return AppCard(
                    padding: const EdgeInsets.all(24),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${item.nim} - ${item.nama}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: item.jenis == 'Perubahan Judul' 
                                    ? Colors.blue.withOpacity(0.1) 
                                    : Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                item.jenis,
                                style: TextStyle(
                                  color: item.jenis == 'Perubahan Judul' ? Colors.blue : Colors.orange,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('Tgl Pengajuan: ${item.tanggal}', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text('Alasan Permohonan:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(item.alasan, style: TextStyle(fontSize: 14)),
                        
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => _handleApproval(item.nim, false),
                              icon: const Icon(Icons.close, color: Colors.red),
                              label: const Text('Tolak', style: TextStyle(color: Colors.red)),
                            ),
                            const SizedBox(width: 16),
                            CustomButton(
                              text: 'Setujui',
                              icon: Icons.check,
                              onPressed: () => _handleApproval(item.nim, true),
                            ),
                          ],
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
}
