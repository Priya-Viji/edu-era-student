import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class WatchMessages {
  final ChatRepository repository;

  WatchMessages(this.repository);

  Stream<List<ChatMessage>> call(String chatId) {
    return repository.watchMessages(chatId);
  }
}
