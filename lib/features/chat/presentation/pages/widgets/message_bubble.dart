import 'package:eduera_student/features/chat/domain/entities/chat_message.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage msg;
  final bool isMe;
  final VoidCallback onEdit;
  final Function(DeleteOption) onDelete;

  const MessageBubble({
    super.key,
    required this.msg,
    required this.isMe,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDeleted = msg.deletedForEveryone;
    final canEdit =
        isMe &&
        !isDeleted &&
        DateTime.now().difference(msg.sentAt).inMinutes < 15;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) => SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (canEdit)
                    ListTile(
                      leading: const Icon(Icons.edit, color: Colors.blue),
                      title: const Text("Edit message"),
                      onTap: () {
                        Navigator.pop(context);
                        onEdit();
                      },
                    ),
                  ListTile(
                    leading: const Icon(Icons.delete, color: Colors.red),
                    title: const Text("Delete message"),
                    onTap: () {
                      Navigator.pop(context);
                      _showDeleteDialog(context);
                    },
                  ),
                ],
              ),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(12),
          constraints: const BoxConstraints(maxWidth: 280),
          decoration: BoxDecoration(
            color: isDeleted
                ? Colors.grey.shade300
                : (isMe ? const Color(0xFFE1FFC7) : Colors.white),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
              bottomRight: isMe ? Radius.zero : const Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(
                isDeleted ? "This message was deleted" : msg.message,
                style: TextStyle(
                  color: isDeleted ? Colors.grey.shade700 : Colors.black87,
                  fontStyle: isDeleted ? FontStyle.italic : FontStyle.normal,
                  fontSize: 15,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: isMe
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  if (msg.edited && !isDeleted)
                    Text(
                      "Edited",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  const SizedBox(width: 4),
                  Text(
                    _formatTime(msg.sentAt),
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                  ),
                  if (isMe) const SizedBox(width: 4),
                  if (isMe) _buildReadTick(msg),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Delete dialog
  void _showDeleteDialog(BuildContext context) {
    final canDeleteForEveryone =
        isMe && DateTime.now().difference(msg.sentAt).inHours < 48;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete message?',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        contentPadding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(ctx);
                onDelete(DeleteOption.forMe);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      color: Colors.grey.shade700,
                      size: 24,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Delete for me',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Message will be removed from this device only',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (canDeleteForEveryone)
              InkWell(
                onTap: () {
                  Navigator.pop(ctx);
                  onDelete(DeleteOption.forEveryone);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                        size: 24,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Delete for everyone',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Message will be removed for all participants',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (canDeleteForEveryone)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: Text(
                  'You can delete for everyone within 48 hours',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'CANCEL',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadTick(ChatMessage msg) {
    if (msg.isRead) {
      return const Icon(Icons.done_all, size: 18, color: Color(0xFF34B7F1));
    }
    if (msg.isDelivered) {
      return const Icon(Icons.done_all, size: 18, color: Colors.grey);
    }
    return const Icon(Icons.done, size: 18, color: Colors.grey);
  }

  // ✅ Corrected time formatter
  String _formatTime(DateTime dt) {
    final local = dt.toLocal(); // convert to local timezone
    final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    final ampm = local.hour >= 12 ? "PM" : "AM";
    return "$hour:$minute $ampm";
  }
}

// Delete options enum
enum DeleteOption { forMe, forEveryone }
