import '../repositories/chat_repository.dart';

class SetTyping {
  final ChatRepository repository;

  SetTyping(this.repository);

  Future<void> call({
    required String chatId,
    required bool isStudentTyping, // FIXED
    required bool isMentorTyping, // FIXED
  }) {
    return repository.setTyping(
      chatId: chatId,
      isStudentTyping: isStudentTyping, // FIXED
      isMentorTyping: isMentorTyping, // FIXED
    );
  }
}
