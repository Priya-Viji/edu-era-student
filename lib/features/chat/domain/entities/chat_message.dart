class ChatMessage {
  final String id;
  final String chatId;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime sentAt;
  final bool edited;
  final bool deletedForEveryone;
  final bool isRead;
  final bool isDelivered;
  final List<String> deletedFor;

  ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.sentAt,
    required this.edited,
    required this.deletedForEveryone,
    required this.isRead,
    required this.isDelivered,
    required this.deletedFor,
  });
}
