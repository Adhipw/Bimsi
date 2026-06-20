import 'package:flutter/material.dart';
import '../../../core/services/api_client.dart';

class SuperAdminAuditLogPage extends StatefulWidget {
  const SuperAdminAuditLogPage({Key? key}) : super(key: key);

  @override
  _SuperAdminAuditLogPageState createState() => _SuperAdminAuditLogPageState();
}

class _SuperAdminAuditLogPageState extends State<SuperAdminAuditLogPage> {
  final ApiClient _apiClient = ApiClient();
  List<dynamic> _logs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }

  Future<void> _fetchLogs() async {
    setState(() => _isLoading = true);
    try {
      final response = await _apiClient.get('/super-admin/audit-logs');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          setState(() {
            _logs = data['data']['data'] ?? [];
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat audit log: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Audit Logs')),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _logs.isEmpty
          ? const Center(child: Text('Tidak ada log aktivitas'))
          : ListView.builder(
              itemCount: _logs.length,
              itemBuilder: (context, index) {
                final log = _logs[index];
                final user = log['user'] != null ? log['user']['name'] : 'System';
                final date = log['created_at'] != null ? DateTime.parse(log['created_at']).toLocal().toString() : '';

                return ListTile(
                  leading: const Icon(Icons.history),
                  title: Text('$user - ${log['action']}'),
                  subtitle: Text('${log['entity']} #${log['entity_id']} \n$date'),
                  isThreeLine: true,
                );
              },
            ),
    );
  }
}
