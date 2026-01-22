import '../repositories/chat_repository.dart';

class MarkMessagesAsRead {
  final ChatRepository repository;

  MarkMessagesAsRead(this.repository);

  Future<void> call({required String chatId, required String userId}) {
    return repository.markMessagesAsRead(chatId: chatId, userId: userId);
  }
}
