import 'package:eduera_student/features/payment/domain/repositories/enroll_repository.dart';

class WatchEnrollmentProgressUseCase {
  final EnrollRepository repo;
  WatchEnrollmentProgressUseCase(this.repo);

  Stream<List<String>> call(String studentId, String courseId) {
    return repo.watchCompletedSublessons(
      studentId: studentId,
      courseId: courseId,
    );
  }
}
