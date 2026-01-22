import '../entities/chat_thread.dart';
import '../entities/chat_message.dart';

abstract class ChatRepository {
  /// Stream inbox list for a student
  Stream<List<ChatThread>> watchStudentInbox(String studentId);

  /// Stream messages inside a chat
  Stream<List<ChatMessage>> watchMessages(String chatId);

  /// Send a message
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String message, // FIXED
  });

  /// Create chat document if missing
  Future<String> ensureChatExists({
    required String studentId,
    required String mentorId,
  });

  /// Typing indicator
  Future<void> setTyping({
    required String chatId,
    required bool isStudentTyping, // FIXED
    required bool isMentorTyping, // FIXED
  });

  /// Mark messages as read
Future<void> markMessagesAsRead({
    required String chatId,
    required String userId,
  });

  Future<void> deleteMessageForEveryone({
    required String chatId,
    required String messageId,
  });

  Future<void> deleteMessageForMe({
    required String chatId,
    required String messageId,
    required String userId,
  });
}
