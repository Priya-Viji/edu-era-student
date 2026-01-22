
import 'package:eduera_student/features/home/domain/entities/mentor_entity.dart';

abstract class MentorRepository {
  Future<MentorEntity> getMentorById(String mentorId);
}
