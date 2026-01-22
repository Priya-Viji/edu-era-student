
import 'package:eduera_student/features/chat/domain/repositories/chat_repository.dart';

class DeleteMessageForMe {
  final ChatRepository repository;

  DeleteMessageForMe(this.repository);

  Future<void> call({
    required String chatId,
    required String messageId,
    required String userId,
  }) {
    return repository.deleteMessageForMe(
      chatId: chatId,
      messageId: messageId,
      userId: userId,
    );
  }
}
