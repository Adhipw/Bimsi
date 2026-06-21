import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../shared/layouts/responsive_scaffold.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class DosenValidasiBeritaAcaraPage extends ConsumerStatefulWidget {
  const DosenValidasiBeritaAcaraPage({super.key});

  @override
  ConsumerState<DosenValidasiBeritaAcaraPage> createState() => _DosenValidasiBeritaAcaraPageState();
}

class _DosenValidasiBeritaAcaraPageState extends ConsumerState<DosenValidasiBeritaAcaraPage> {
  final TextEditingController _pinController = TextEditingController();
  bool _isSubmitting = false;

  void _showValidasiDialog(String title) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Validasi $title'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Masukkan 6 digit PIN Digital Signature Anda untuk memberikan tanda tangan pada dokumen ini.'),
              const SizedBox(height: 16),
              TextField(
                controller: _pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'PIN Digital Signature',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () async {
                if (_pinController.text.length != 6) return;
                
                setState(() => _isSubmitting = true);

                // Enkripsi PIN dengan SHA-256 sebelum dikirim ke server (simulasi)
                final bytes = utf8.encode(_pinController.text);
                final hashedPin = sha256.convert(bytes).toString();
                debugPrint('Simulating sending encrypted PIN to server: $hashedPin');

                // Simulasi validasi
                await Future.delayed(const Duration(seconds: 1));
                
                if (mounted) {
                  setState(() => _isSubmitting = false);
                  _pinController.clear();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Dokumen berhasil ditandatangani secara digital!')),
                  );
                }
              },
              child: const Text('Validasi & TTD'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dokumenList = [
      {
        'mahasiswa': 'Budi Santoso',
        'nim': '12345678',
        'jenis': 'Berita Acara Sidang Skripsi',
        'tanggal': '22 Jun 2026',
        'status': 'Menunggu Validasi',
      },
      {
        'mahasiswa': 'Siti Aminah',
        'nim': '87654321',
        'jenis': 'Lembar Pengesahan Skripsi',
        'tanggal': '20 Jun 2026',
        'status': 'Menunggu Validasi',
      },
    ];

    return ResponsiveScaffold(
      title: 'Validasi Dokumen & TTD Digital',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Menunggu Validasi Anda',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Daftar dokumen berita acara dan lembar pengesahan yang memerlukan tanda tangan digital (PIN) Anda.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            AppCard(
              padding: EdgeInsets.zero,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dokumenList.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final doc = dokumenList[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.draw, color: Colors.orange),
                    ),
                    title: Text(doc['jenis'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('Mahasiswa: ${doc['mahasiswa']} (${doc['nim']})'),
                        const SizedBox(height: 4),
                        Text('Tanggal Sidang: ${doc['tanggal']}', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                      ],
                    ),
                    trailing: CustomButton(
                      text: 'Validasi',
                      onPressed: () => _showValidasiDialog(doc['jenis']),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
