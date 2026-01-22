import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduera_student/features/chat/domain/entities/chat_thread.dart';

class ChatThreadModel {
  final String chatId;
  final String studentId;
  final String studentName;
  final String studentAvatarUrl;
  final String mentorId;
  final String mentorName;
  final String mentorAvatarUrl;
  final String? lastMessage;
  final DateTime? lastMessageAt;

  ChatThreadModel({
    required this.chatId,
    required this.studentId,
    required this.studentName,
    required this.studentAvatarUrl,
    required this.mentorId,
    required this.mentorName,
    required this.mentorAvatarUrl,
    this.lastMessage,
    this.lastMessageAt,
  });

  factory ChatThreadModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatThreadModel(
      chatId: doc.id,
      studentId: data['studentId'],
      studentName: data['studentName'] ?? '',
      studentAvatarUrl: data['studentAvatarUrl'] ?? '',
      mentorId: data['mentorId'],
      mentorName: data['mentorName'],
      mentorAvatarUrl: data['mentorAvatarUrl'] ?? '',
      lastMessage: data['lastMessage'],
      lastMessageAt: (data['lastMessageAt'] as Timestamp?)?.toDate(),
    );
  }

  ChatThread toEntity() {
    return ChatThread(
      chatId: chatId,
      studentId: studentId,
      studentName: studentName,
      studentAvatarUrl: studentAvatarUrl,
      mentorId: mentorId,
      mentorName: mentorName,
      mentorAvatarUrl: mentorAvatarUrl,
      lastMessage: lastMessage,
      lastMessageAt: lastMessageAt,
    );
  }
}
