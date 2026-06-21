import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/layouts/responsive_scaffold.dart';
import '../models/pesan_diskusi_model.dart';

class MahasiswaDiskusiPage extends ConsumerStatefulWidget {
  const MahasiswaDiskusiPage({super.key});

  @override
  ConsumerState<MahasiswaDiskusiPage> createState() => _MahasiswaDiskusiPageState();
}

class _MahasiswaDiskusiPageState extends ConsumerState<MahasiswaDiskusiPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<PesanDiskusiModel> _messages = [
    PesanDiskusiModel(
      id: 1,
      pengirim: 'Dosen Pembimbing',
      waktu: '10:00',
      pesan: 'Halo, jangan lupa kumpulkan bab 1 minggu depan ya.',
      isMe: false,
    ),
    PesanDiskusiModel(
      id: 2,
      pengirim: 'Saya',
      waktu: '10:05',
      pesan: 'Baik Pak, segera saya kerjakan. Terima kasih arahannya.',
      isMe: true,
    ),
  ];

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        PesanDiskusiModel(
          id: DateTime.now().millisecondsSinceEpoch,
          pengirim: 'Saya',
          waktu: '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
          pesan: text,
          isMe: true,
        ),
      );
      _messageController.clear();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Diskusi Bimbingan',
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(24.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageBubble(
                  text: msg.pesan,
                  isMe: msg.isMe,
                  time: msg.waktu,
                  sender: msg.pengirim,
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                )
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ketik pesan...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble({required String text, required bool isMe, required String time, required String sender}) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              sender,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isMe ? Theme.of(context).colorScheme.primary : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(16),
                  bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(0),
                ),
              ),
              child: Text(
                text,
                style: TextStyle(color: isMe ? Colors.white : Colors.black87),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}
