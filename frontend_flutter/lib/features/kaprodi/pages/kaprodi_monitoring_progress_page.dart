import 'package:flutter/material.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../mahasiswa/services/progress_skripsi_service.dart';
import '../../mahasiswa/models/pengajuan_judul_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KaprodiMonitoringProgressPage extends ConsumerStatefulWidget {
  const KaprodiMonitoringProgressPage({Key? key}) : super(key: key);

  @override
  ConsumerState<KaprodiMonitoringProgressPage> createState() => _KaprodiMonitoringProgressPageState();
}

class _KaprodiMonitoringProgressPageState extends ConsumerState<KaprodiMonitoringProgressPage> {
  bool _isLoading = false;
  List<PengajuanJudulModel> _list = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData([String search = '']) async {
    setState(() {
      _isLoading = true;
    });

    final _service = ref.read(progressSkripsiServiceProvider);
    final result = await _service.getKaprodiMonitoring(search: search);
    
    setState(() {
      _isLoading = false;
      if (result['success']) {
        _list = result['data'];
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Gagal mengambil data')),
        );
      }
    });
  }

  void _onSearchChanged(String query) {
    _fetchData(query);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoring Progress Skripsi'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: CustomTextField(
                label: 'Cari Mahasiswa',
                controller: _searchController,
                hint: 'Masukkan Nama atau NIM...',
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _fetchData(_searchController.text),
                    child: _list.isEmpty
                        ? const Center(child: Text('Tidak ada data mahasiswa bimbingan aktif.'))
                        : Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 1000),
                              child: ListView.builder(
                                padding: const EdgeInsets.all(24),
                                itemCount: _list.length,
                                itemBuilder: (context, index) {
                                  final item = _list[index];
                                  return _buildCard(item);
                                },
                              ),
                            ),
                          ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(PengajuanJudulModel item) {
    int progress = item.totalPersentase ?? 0;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: AppCard(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.namaMahasiswa ?? '-',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'NIM: ${item.nimMahasiswa ?? "-"}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$progress%',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.article_outlined, color: Colors.grey.shade500, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.judul ?? '-',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress / 100,
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                color: Theme.of(context).colorScheme.primary,
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
