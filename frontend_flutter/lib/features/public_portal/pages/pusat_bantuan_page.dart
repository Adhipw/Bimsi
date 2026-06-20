import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/pusat_bantuan_provider.dart';
import '../models/pusat_bantuan_model.dart';

class PusatBantuanPage extends ConsumerStatefulWidget {
  const PusatBantuanPage({super.key});

  @override
  ConsumerState<PusatBantuanPage> createState() => _PusatBantuanPageState();
}

class _PusatBantuanPageState extends ConsumerState<PusatBantuanPage> {
  String _selectedKategori = 'faq'; // faq atau dokumen_template

  @override
  Widget build(BuildContext context) {
    final listState = ref.watch(pusatBantuanListProvider(_selectedKategori));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text('Pusat Bantuan', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1E3A8A), // Indigo-900
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF1E3A8A),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedKategori == 'faq' ? Colors.white : Colors.transparent,
                      foregroundColor: _selectedKategori == 'faq' ? const Color(0xFF1E3A8A) : Colors.white,
                      elevation: 0,
                      side: BorderSide(color: _selectedKategori == 'faq' ? Colors.transparent : Colors.white54),
                    ),
                    onPressed: () => setState(() => _selectedKategori = 'faq'),
                    child: const Text('FAQ'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedKategori == 'dokumen_template' ? Colors.white : Colors.transparent,
                      foregroundColor: _selectedKategori == 'dokumen_template' ? const Color(0xFF1E3A8A) : Colors.white,
                      elevation: 0,
                      side: BorderSide(color: _selectedKategori == 'dokumen_template' ? Colors.transparent : Colors.white54),
                    ),
                    onPressed: () => setState(() => _selectedKategori = 'dokumen_template'),
                    child: const Text('Template Dokumen'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: listState.when(
              data: (list) {
                if (list.isEmpty) {
                  return Center(
                    child: Text('Tidak ada data tersedia.', style: GoogleFonts.inter(color: Colors.grey)),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    if (_selectedKategori == 'faq') {
                      return _buildFaqCard(item);
                    } else {
                      return _buildTemplateCard(item);
                    }
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqCard(PusatBantuanModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            item.judulPertanyaanAtauDokumen,
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: const Color(0xFF111827)),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Text(
                item.isiJawabanAtauUrlFile,
                style: GoogleFonts.inter(color: Colors.grey[700], height: 1.5),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateCard(PusatBantuanModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.description, color: Color(0xFF2563EB)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.judulPertanyaanAtauDokumen,
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text('Format: DOCX/PDF', style: GoogleFonts.inter(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download, color: Color(0xFF2563EB)),
            onPressed: () => _launchUrl(item.isiJawabanAtauUrlFile),
          )
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
