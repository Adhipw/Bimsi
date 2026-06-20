import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/app_card.dart';
import '../models/progress_skripsi_model.dart';
import '../models/pengajuan_judul_model.dart';
import '../services/progress_skripsi_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MahasiswaProgressPage extends ConsumerStatefulWidget {
  const MahasiswaProgressPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MahasiswaProgressPage> createState() => _MahasiswaProgressPageState();
}

class _MahasiswaProgressPageState extends ConsumerState<MahasiswaProgressPage> {
  bool _isLoading = true;
  PengajuanJudulModel? _pengajuan;
  int _totalPersentase = 0;
  List<ProgressSkripsiModel> _details = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchProgress();
  }

  Future<void> _fetchProgress() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final progressService = ref.read(progressSkripsiServiceProvider);
    final result = await progressService.getMahasiswaProgress();
    if (result['success']) {
      setState(() {
        _pengajuan = result['pengajuan'];
        _totalPersentase = result['total_persentase'];
        _details = result['details'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _errorMessage = result['message'];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Skripsi'),
      ),
      body: _isLoading
          ? const LoadingWidget(message: 'Memuat progress...', )
          : _errorMessage != null
              ? EmptyStateWidget(
                  title: 'Gagal Memuat',
                  message: _errorMessage!,
                  icon: Icons.error_outline,
                  buttonText: 'Coba Lagi',
                  onButtonPressed: _fetchProgress,
                )
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    return RefreshIndicator(
      onRefresh: _fetchProgress,
      child: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          _buildSummaryCard(),
          const SizedBox(height: 32.0),
          Text(
            'Detail per BAB',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          _details.isEmpty
              ? const EmptyStateWidget(title: 'Belum ada progress', message: 'Anda belum memiliki riwayat bimbingan atau persetujuan BAB.',)
              : AppCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: _details.asMap().entries.map((entry) {
                      final index = entry.key;
                      final detail = entry.value;
                      final isLast = index == _details.length - 1;
                      return _buildTimelineItem(detail, isLast);
                    }).toList(),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return AppCard(
      color: Theme.of(context).colorScheme.primary,
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Judul Skripsi',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            _pengajuan?.judul ?? "-",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Progress', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
              Text('$_totalPersentase%', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _totalPersentase / 100,
              backgroundColor: Colors.white.withOpacity(0.2),
              color: Theme.of(context).colorScheme.secondary,
              minHeight: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(ProgressSkripsiModel detail, bool isLast) {
    final isDisetujui = detail.status.toLowerCase() == 'disetujui';
    final color = isDisetujui ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 2),
                  ),
                  child: Icon(
                    isDisetujui ? Icons.check : Icons.pending_actions,
                    color: color,
                    size: 16,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(detail.bab, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '+${detail.persentase}%',
                          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Status: ${detail.status}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color, fontWeight: FontWeight.w500)),
                  if (detail.keterangan != '-') ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Theme.of(context).dividerColor),
                      ),
                      child: Text(
                        detail.keterangan,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic, color: Colors.grey.shade700),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
