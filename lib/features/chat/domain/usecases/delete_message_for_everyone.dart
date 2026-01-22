
import 'package:eduera_student/features/chat/domain/repositories/chat_repository.dart';

class DeleteMessageForEveryone {
  final ChatRepository repository;

  DeleteMessageForEveryone(this.repository);

  Future<void> call({required String chatId, required String messageId}) {
    return repository.deleteMessageForEveryone(
      chatId: chatId,
      messageId: messageId,
    );
  }
}
