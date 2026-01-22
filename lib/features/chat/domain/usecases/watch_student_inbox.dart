import '../entities/chat_thread.dart';
import '../repositories/chat_repository.dart';

class WatchStudentInbox {
  final ChatRepository repository;

  WatchStudentInbox(this.repository);

  Stream<List<ChatThread>> call(String studentId) {
    return repository.watchStudentInbox(studentId);
  }
}
