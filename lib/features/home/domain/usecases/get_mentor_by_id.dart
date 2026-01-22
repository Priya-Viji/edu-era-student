// domain/usecases/get_mentor_by_id.dart
import '../entities/mentor_entity.dart';
import '../repositories/mentor_repository.dart';

class GetMentorById {
  final MentorRepository repository;
  GetMentorById(this.repository);

  Future<MentorEntity> call(String mentorId) {
    return repository.getMentorById(mentorId);
  }
}
