import '../repositories/chat_repository.dart';

class EnsureChatExists {
  final ChatRepository repo;

  EnsureChatExists(this.repo);

Future<String> call({
    required String studentId,
    required String mentorId,
  }) async {
    return await repo.ensureChatExists(
      studentId: studentId,
      mentorId: mentorId,
    );
  }

}
