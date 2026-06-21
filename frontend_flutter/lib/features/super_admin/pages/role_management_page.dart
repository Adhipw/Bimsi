import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/layouts/responsive_scaffold.dart';
import '../../../core/services/api_client.dart';
import '../../../core/utils/snackbar_utils.dart';

final rolesProvider = FutureProvider<List<dynamic>>((ref) async {
  final api = ref.watch(apiClientProvider);
  final response = await api.get('/roles');
  return response.data as List<dynamic>;
});

final permissionsProvider = FutureProvider<List<dynamic>>((ref) async {
  final api = ref.watch(apiClientProvider);
  final response = await api.get('/permissions');
  return response.data as List<dynamic>;
});

class RoleManagementPage extends ConsumerWidget {
  const RoleManagementPage({super.key});

  Future<void> _deleteRole(BuildContext context, WidgetRef ref, int id, String name) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Role'),
        content: Text('Apakah Anda yakin ingin menghapus role "$name"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final api = ref.read(apiClientProvider);
        await api.delete('/roles/$id');
        if (context.mounted) SnackbarUtils.showSuccess(context, 'Role berhasil dihapus');
        ref.invalidate(rolesProvider);
      } catch (e) {
        if (context.mounted) SnackbarUtils.showError(context, 'Gagal menghapus role: $e');
      }
    }
  }

  void _showRoleDialog(BuildContext context, WidgetRef ref, {Map<String, dynamic>? role}) {
    showDialog(
      context: context,
      builder: (context) => _RoleDialog(role: role),
    ).then((changed) {
      if (changed == true) {
        ref.invalidate(rolesProvider);
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rolesAsync = ref.watch(rolesProvider);

    return ResponsiveScaffold(
      title: 'Manajemen Role & Permissions',
      body: rolesAsync.when(
        data: (roles) {
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: roles.length,
            itemBuilder: (context, index) {
              final role = roles[index];
              final permissions = (role['permissions'] as List<dynamic>?) ?? [];
              
              return Container(
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).cardColor,
                      Theme.of(context).cardColor.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withOpacity(0.05),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  Icons.shield_rounded,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                role['name'].toString().toUpperCase(),
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Tooltip(
                                message: 'Edit Role',
                                child: IconButton(
                                  icon: const Icon(Icons.edit_rounded, color: Colors.blueAccent),
                                  onPressed: () => _showRoleDialog(context, ref, role: role),
                                  splashRadius: 24,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Tooltip(
                                message: 'Hapus Role',
                                child: IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                                  onPressed: () => _deleteRole(context, ref, role['id'], role['name']),
                                  splashRadius: 24,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'HAK AKSES / PERMISSIONS',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.grey,
                          letterSpacing: 1.2,
                          fontSize: 12,
                        )
                      ),
                      const SizedBox(height: 12),
                      permissions.isEmpty 
                        ? const Text('Belum ada hak akses spesifik', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic))
                        : Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: permissions.map((p) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check_circle_rounded,
                                      size: 16,
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      p['name'],
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.secondary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRoleDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _RoleDialog extends ConsumerStatefulWidget {
  final Map<String, dynamic>? role;
  const _RoleDialog({this.role});

  @override
  ConsumerState<_RoleDialog> createState() => _RoleDialogState();
}

class _RoleDialogState extends ConsumerState<_RoleDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  List<String> _selectedPermissions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.role != null) {
      _nameController.text = widget.role!['name'];
      final perms = widget.role!['permissions'] as List<dynamic>? ?? [];
      _selectedPermissions = perms.map((p) => p['name'].toString()).toList();
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final api = ref.read(apiClientProvider);
      final data = {
        'name': _nameController.text,
        'permissions': _selectedPermissions,
      };

      if (widget.role == null) {
        await api.post('/roles', data: data);
        if (mounted) SnackbarUtils.showSuccess(context, 'Role berhasil ditambahkan');
      } else {
        await api.put('/roles/${widget.role!['id']}', data: data);
        if (mounted) SnackbarUtils.showSuccess(context, 'Role berhasil diupdate');
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) SnackbarUtils.showError(context, 'Gagal menyimpan role: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final permissionsAsync = ref.watch(permissionsProvider);

    return AlertDialog(
      title: Text(widget.role == null ? 'Tambah Role' : 'Edit Role'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Role', border: OutlineInputBorder()),
                validator: (val) => val == null || val.isEmpty ? 'Nama harus diisi' : null,
              ),
              const SizedBox(height: 16),
              const Text('Permissions:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SizedBox(
                height: 300,
                child: permissionsAsync.when(
                  data: (permissions) {
                    return ListView.builder(
                      itemCount: permissions.length,
                      itemBuilder: (context, index) {
                        final pName = permissions[index]['name'];
                        return CheckboxListTile(
                          title: Text(pName),
                          value: _selectedPermissions.contains(pName),
                          onChanged: (val) {
                            setState(() {
                              if (val == true) {
                                _selectedPermissions.add(pName);
                              } else {
                                _selectedPermissions.remove(pName);
                              }
                            });
                          },
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, s) => Text('Error loading permissions: $e'),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _save,
          child: _isLoading 
            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) 
            : const Text('Simpan'),
        ),
      ],
    );
  }
}
