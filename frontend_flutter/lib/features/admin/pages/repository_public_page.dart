import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/layouts/responsive_scaffold.dart';
import '../services/repository_service.dart';

class RepositoryPublicPage extends ConsumerStatefulWidget {
  const RepositoryPublicPage({super.key});

  @override
  ConsumerState<RepositoryPublicPage> createState() => _RepositoryPublicPageState();
}

class _RepositoryPublicPageState extends ConsumerState<RepositoryPublicPage> {
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(publicRepositoryProvider(_searchQuery.isEmpty ? null : _searchQuery));

    return ResponsiveScaffold(
      title: 'Digital Library (Repository)',
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari Judul atau Penulis...',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                ),
              ),
              onSubmitted: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(
            child: asyncData.when(
              data: (data) {
                final list = data['data'] as List<dynamic>;
                if (list.isEmpty) return const Center(child: Text('Tidak ada dokumen ditemukan.'));

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final repo = list[index];
                    final judul = repo['pengajuan_judul']['judul'];
                    final penulis = repo['mahasiswa']['user']['name'];
                    final views = repo['views_count'];
                    final abstrak = repo['abstrak'] ?? '-';

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(judul, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
                            const SizedBox(height: 4),
                            Text('Penulis: $penulis', style: const TextStyle(fontWeight: FontWeight.w500)),
                            const SizedBox(height: 8),
                            Text(abstrak, maxLines: 3, overflow: TextOverflow.ellipsis),
                            const Divider(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.visibility, size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text('$views x dilihat', style: const TextStyle(color: Colors.grey)),
                                  ],
                                ),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    // Buka dialog untuk lihat detail (belum diimplementasi penuh untuk brevity)
                                  },
                                  icon: const Icon(Icons.library_books),
                                  label: const Text('Baca Selengkapnya'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
