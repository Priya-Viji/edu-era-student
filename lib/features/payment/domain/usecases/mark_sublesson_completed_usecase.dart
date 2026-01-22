import 'package:eduera_student/features/payment/domain/repositories/enroll_repository.dart';

class MarkSublessonCompletedUseCase {
  final EnrollRepository repo;
  MarkSublessonCompletedUseCase(this.repo);

  Future<void> call(String studentId, String courseId, String subId) {
    return repo.markSublessonCompleted(
      studentId: studentId,
      courseId: courseId,
      sublessonId: subId, // FIXED
    );
  }
}
