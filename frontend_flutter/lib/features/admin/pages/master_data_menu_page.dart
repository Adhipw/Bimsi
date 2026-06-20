import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MasterDataMenuPage extends StatelessWidget {
  const MasterDataMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {
        'title': 'Program Studi',
        'subtitle': 'Kelola daftar program studi & jenjang',
        'icon': Icons.school_rounded,
        'type': 'program-studi',
        'color': const Color(0xFF0056A6),
      },
      {
        'title': 'Tahun Akademik',
        'subtitle': 'Kelola tahun ajaran & status aktif',
        'icon': Icons.date_range_rounded,
        'type': 'tahun-akademik',
        'color': const Color(0xFFF2A900),
      },
      {
        'title': 'Semester',
        'subtitle': 'Kelola semester ganjil/genap',
        'icon': Icons.calendar_today_rounded,
        'type': 'semester',
        'color': const Color(0xFF4CAF50),
      },
      {
        'title': 'Kelas',
        'subtitle': 'Kelola kelas per program studi',
        'icon': Icons.class_rounded,
        'type': 'kelas',
        'color': const Color(0xFF9C27B0),
      },
      {
        'title': 'User',
        'subtitle': 'Kelola semua akun pengguna & role',
        'icon': Icons.people_rounded,
        'type': 'user',
        'color': const Color(0xFFE91E63),
      },
      {
        'title': 'Dosen',
        'subtitle': 'Kelola data dosen & bidang keahlian',
        'icon': Icons.assignment_ind_rounded,
        'type': 'dosen',
        'color': const Color(0xFF3F51B5),
      },
      {
        'title': 'Mahasiswa',
        'subtitle': 'Kelola data mahasiswa & program studi',
        'icon': Icons.person_rounded,
        'type': 'mahasiswa',
        'color': const Color(0xFFFF9800),
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Kelola Data Master', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF0056A6),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Pilih Data Master',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
            const Text(
              'Silakan pilih jenis data master yang ingin Anda kelola di bawah ini.',
              style: TextStyle(color: Color(0xFF757575), fontSize: 14),
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    leading: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: (item['color'] as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        color: item['color'] as Color,
                      ),
                    ),
                    title: Text(
                      item['title'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        item['subtitle'] as String,
                        style: const TextStyle(
                          color: Color(0xFF757575),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: Color(0xFF757575),
                    ),
                    onTap: () {
                      context.push('/dashboard/admin/master-list?type=${item['type']}');
                    },
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
