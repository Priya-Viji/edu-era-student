class InboxItem {
  final String chatId;
  final String mentorId;
  final String mentorName;
  final String mentorAvatarUrl;
  final String lastMessage;
  final DateTime? lastMessageAt;
  final int unreadCount;

  InboxItem({
    required this.chatId,
    required this.mentorId,
    required this.mentorName,
    required this.mentorAvatarUrl,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.unreadCount,
  });
}
