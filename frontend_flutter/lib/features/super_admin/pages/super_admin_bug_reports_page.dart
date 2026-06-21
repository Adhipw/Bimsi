import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/app_card.dart';
import '../../../shared/layouts/responsive_scaffold.dart';
import '../models/bug_report_model.dart';

class SuperAdminBugReportsPage extends ConsumerStatefulWidget {
  const SuperAdminBugReportsPage({super.key});

  @override
  ConsumerState<SuperAdminBugReportsPage> createState() => _SuperAdminBugReportsPageState();
}

class _SuperAdminBugReportsPageState extends ConsumerState<SuperAdminBugReportsPage> {
  final List<BugReportModel> _bugReports = [
    BugReportModel(
      id: '#BUG-001',
      pelapor: 'Budi Santoso (Mahasiswa)',
      judul: 'Gagal Upload File Revisi',
      deskripsi: 'Ketika mencoba upload file PDF ukuran 5MB, selalu muncul error timeout padahal koneksi lancar.',
      prioritas: 'High',
      status: 'Open',
      waktu: '2 jam lalu',
    ),
    BugReportModel(
      id: '#BUG-002',
      pelapor: 'Dr. Ir. Budi Santoso, M.Kom (Dosen)',
      judul: 'Tombol Validasi Berita Acara Tidak Muncul',
      deskripsi: 'Pada dashboard saya, berita acara sidang Ahmad tidak memiliki tombol validasi.',
      prioritas: 'High',
      status: 'In Progress',
      waktu: '1 hari lalu',
    ),
    BugReportModel(
      id: '#FB-001',
      pelapor: 'Siti Aminah (Mahasiswa)',
      judul: 'Saran: Tambahkan Filter Status di Pengajuan',
      deskripsi: 'Akan sangat membantu jika di daftar pengajuan judul ada filter untuk memisahkan yang Diterima dan Ditolak.',
      prioritas: 'Low',
      status: 'Resolved',
      waktu: '3 hari lalu',
    ),
  ];

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Open':
        return Colors.red;
      case 'In Progress':
        return Colors.orange;
      case 'Resolved':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _updateStatus(int index, String newStatus) {
    setState(() {
      _bugReports[index].status = newStatus;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Status tiket ${_bugReports[index].id} diubah menjadi $newStatus.')),
    );
  }

  void _showTicketDetails(BugReportModel ticket, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${ticket.id} - ${ticket.judul}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pelapor: ${ticket.pelapor}'),
              Text('Waktu Lapor: ${ticket.waktu}'),
              const Divider(height: 32),
              const Text('Deskripsi:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(ticket.deskripsi),
              const SizedBox(height: 24),
              const Text('Ubah Status Tiket:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['Open', 'In Progress', 'Resolved'].map((status) {
                  return ChoiceChip(
                    label: Text(status),
                    selected: ticket.status == status,
                    onSelected: (selected) {
                      if (selected) {
                        _updateStatus(index, status);
                        Navigator.pop(context);
                      }
                    },
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Bug & Feedback Reporting',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sistem Pelaporan Tiket',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Pantau dan tindak lanjuti laporan bug atau saran dari pengguna aplikasi.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _bugReports.length,
              itemBuilder: (context, index) {
                final report = _bugReports[index];
                return AppCard(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Row(
                      children: [
                        Text(report.id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            report.judul,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text('Pelapor: ${report.pelapor} • ${report.waktu}'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getPriorityColor(report.prioritas).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Priority: ${report.prioritas}',
                                style: TextStyle(
                                  color: _getPriorityColor(report.prioritas),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(report.status).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                report.status,
                                style: TextStyle(
                                  color: _getStatusColor(report.status),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _showTicketDetails(report, index),
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
