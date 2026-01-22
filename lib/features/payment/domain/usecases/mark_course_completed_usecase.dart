import 'package:eduera_student/features/payment/domain/repositories/enroll_repository.dart';

class MarkCourseCompletedUseCase {
  final EnrollRepository repo;
  MarkCourseCompletedUseCase(this.repo);

  Future<void> call(String studentId, String courseId) {
    return repo.markCourseCompleted(studentId: studentId, courseId: courseId);
  }
}
