import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/chat_message.dart';

class ChatMessageModel {
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
  final List<String> deletedFor; // 👈 NEW

  ChatMessageModel({
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

  factory ChatMessageModel.fromDoc(DocumentSnapshot doc, String chatId) {
    final raw = doc.data();
    if (raw == null) {
      return ChatMessageModel(
        id: doc.id,
        chatId: chatId,
        senderId: '',
        receiverId: '',
        message: '',
        sentAt: DateTime.now(),
        edited: false,
        deletedForEveryone: false,
        isRead: false,
        isDelivered: false,
        deletedFor: const [],
      );
    }

    final data = raw as Map<String, dynamic>;

    final ts = data['sentAt'];
    final created = data['createdAt'];

    DateTime rawSentAt = ts is Timestamp
        ? ts.toDate().toLocal()
        : created is Timestamp
        ? created.toDate().toLocal()
        : DateTime.now();
    rawSentAt = _fixOldTimestamp(rawSentAt);

    return ChatMessageModel(
      id: doc.id,
      chatId: chatId,
      senderId: data['senderId']?.toString() ?? '',
      receiverId: data['receiverId']?.toString() ?? '',
      message: data['message']?.toString() ?? '',
      sentAt: rawSentAt,
      edited: data['edited'] ?? false,
      deletedForEveryone: data['deletedForEveryone'] ?? false,
      isDelivered: data['isDelivered'] ?? false,
      isRead: data['isRead'] ?? false,
      deletedFor: List<String>.from(data['deletedFor'] ?? const []), // 👈 NEW
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'sentAt': Timestamp.fromDate(sentAt),
      'isRead': isRead,
      'isDelivered': isDelivered,
      'deletedForEveryone': deletedForEveryone,
      'deletedFor': deletedFor,
    };
  }

  ChatMessage toEntity() {
    return ChatMessage(
      id: id,
      chatId: chatId,
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      sentAt: sentAt,
      isRead: isRead,
      isDelivered: isDelivered,
      edited: edited,
      deletedForEveryone: deletedForEveryone,
      deletedFor: deletedFor,
    );
  }
}

DateTime _fixOldTimestamp(DateTime dt) {
  // If timestamp is in the future → it was saved in UTC → convert manually
  if (dt.isAfter(DateTime.now())) {
    return dt.subtract(const Duration(hours: 5, minutes: 30)); // IST offset
  }

  // If timestamp is "today" but message is actually older → adjust
  final now = DateTime.now();
  if (dt.day == now.day && dt.month == now.month && dt.year == now.year) {
    // If time difference is too small (< 1 minute), it's likely UTC
    if (now.difference(dt).inMinutes < 1) {
      return dt.subtract(const Duration(hours: 5, minutes: 30));
    }
  }

  return dt;
}
