import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/chat_message.dart';

class ChatMessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime? sentAt; // nullable until Firestore fills server timestamp
  final bool edited;
  final bool deletedForEveryone;
  final bool isRead;
  final bool isDelivered;
  final List<String> deletedFor;

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
    final data = doc.data() as Map<String, dynamic>? ?? {};

    final ts = data['sentAt'];
    DateTime? rawSentAt = ts is Timestamp ? ts.toDate().toLocal() : null;

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
      deletedFor: List<String>.from(data['deletedFor'] ?? const []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'sentAt': sentAt != null
          ? Timestamp.fromDate(sentAt!)
          : FieldValue.serverTimestamp(),
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
      sentAt: sentAt ?? DateTime.now(), // fallback only for UI display
      isRead: isRead,
      isDelivered: isDelivered,
      edited: edited,
      deletedForEveryone: deletedForEveryone,
      deletedFor: deletedFor,
    );
  }
}
