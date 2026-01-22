import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduera_student/features/chat/data/models/chat_message_model.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_thread.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remote;

  ChatRepositoryImpl(this.remote);


  // Inbox 
  @override
  Stream<List<ChatThread>> watchStudentInbox(String studentId) {
    return remote.watchStudentInbox(studentId).map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return ChatThread(
          chatId: doc.id,
          studentId: data['studentId'],
          studentName: data['studentName'],
          studentAvatarUrl: data['studentAvatarUrl'],
          mentorId: data['mentorId'],
          mentorName: data['mentorName'],
          mentorAvatarUrl: data['mentorAvatarUrl'] ?? "",
          lastMessage: data['lastMessage'],
          lastMessageAt: (data['lastMessageAt'] as Timestamp?)?.toDate(),
        );
      }).toList();
    });
  }

  // ---------------------------
  // Messages Stream
  // ---------------------------
  @override
  Stream<List<ChatMessage>> watchMessages(String chatId) {
    return remote.watchMessages(chatId).map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatMessageModel.fromDoc(doc, chatId).toEntity())
          .toList()
          .reversed // because ListView.reverse = true
          .toList();
    });
  }
  
  // Send Message
 
  @override
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String message, 
  }) {
    return remote.sendMessage(
      chatId: chatId,
      senderId: senderId,
      receiverId: receiverId,
      message: message, 
    );
  }

  
  // Ensure Chat Exists
 
  @override
  Future<String> ensureChatExists({
    required String studentId,
    required String mentorId,
  }) {
    return remote.ensureChatExists(studentId: studentId, mentorId: mentorId);
  }


  // Typing Indicator
  
  @override
  Future<void> setTyping({
    required String chatId,
    required bool isStudentTyping, 
    required bool isMentorTyping, 
  }) {
    return remote.setTyping(
      chatId: chatId,
      isStudentTyping: isStudentTyping,
      isMentorTyping: isMentorTyping, 
    );
  }

  
  // Mark Messages as Read
 
  @override
  Future<void> markMessagesAsRead({
    required String chatId,
    required String userId,
  }) {
    return remote.markMessagesAsRead(chatId: chatId, userId: userId);
  }


@override
Future<void> deleteMessageForEveryone({
  required String chatId,
  required String messageId,
}) {
  return remote.deleteMessageForEveryone(chatId: chatId, messageId: messageId);
}

@override
Future<void> deleteMessageForMe({
  required String chatId,
  required String messageId,
  required String userId,
}) {
  return remote.deleteMessageForMe(
    chatId: chatId,
    messageId: messageId,
    userId: userId,
  );
}
}
