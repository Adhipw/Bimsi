import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../mahasiswa/providers/logbook_provider.dart'; // We reuse the fetch logic
import '../../mahasiswa/models/logbook_model.dart';
import '../providers/dosen_logbook_provider.dart';

class DosenReviewLogbookPage extends ConsumerStatefulWidget {
  const DosenReviewLogbookPage({super.key});

  @override
  ConsumerState<DosenReviewLogbookPage> createState() => _DosenReviewLogbookPageState();
}

class _DosenReviewLogbookPageState extends ConsumerState<DosenReviewLogbookPage> {
  @override
  Widget build(BuildContext context) {
    // Note: In real app, Dosen should have a separate endpoint to fetch ALL their students' logbooks
    // For this prototype, we reuse logbookListProvider assuming it fetches relevant data
    final listState = ref.watch(logbookListProvider);
    final approveState = ref.watch(approveLogbookProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text('Review Logbook Mahasiswa', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF111827), // Gray-900
        elevation: 0,
      ),
      body: listState.when(
        data: (list) {
          final pendingList = list.where((l) => l.statusApproval == 'pending').toList();
          
          if (pendingList.isEmpty) {
            return const Center(child: Text('Semua logbook sudah di-review.'));
          }

          return RefreshIndicator(
            onRefresh: () async => ref.refresh(logbookListProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pendingList.length,
              itemBuilder: (context, index) {
                final item = pendingList[index];
                return _buildLogbookCard(item, approveState.isLoading);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildLogbookCard(LogbookModel item, bool isLoading) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mhs ID: ${item.mahasiswaId}',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                item.tanggalKegiatan,
                style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item.deskripsiKegiatan,
            style: GoogleFonts.inter(color: Colors.grey[800], height: 1.5),
          ),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(foregroundColor: Colors.orange, side: const BorderSide(color: Colors.orange)),
                onPressed: isLoading ? null : () => _updateStatus(item.id, 'revised'),
                child: const Text('Revisi'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: isLoading ? null : () => _updateStatus(item.id, 'approved'),
                child: const Text('Setujui'),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _updateStatus(int id, String status) {
    ref.read(approveLogbookProvider.notifier).approve(id, status).then((_) {
      ref.refresh(logbookListProvider);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logbook di-$status')));
    });
  }
}
