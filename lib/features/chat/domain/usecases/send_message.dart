import '../repositories/chat_repository.dart';

class SendMessage {
  final ChatRepository repository;

  SendMessage(this.repository);

  Future<void> call({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String message, // FIXED
  }) {
    return repository.sendMessage(
      chatId: chatId,
      senderId: senderId,
      receiverId: receiverId,
      message: message, // FIXED
    );
  }
}
