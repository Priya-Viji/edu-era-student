import 'package:eduera_student/features/payment/data/model/course_with_enrollment.dart';
import 'package:eduera_student/features/payment/domain/entities/enroll_entity.dart';

abstract class EnrollRepository {
  /// Save enrollment. Throws on failure.
  Future<void> saveEnrollment(EnrollEntity entity);

  /// Optionally check if enrolled already
  Future<bool> isEnrolled(String userId, String courseId);

  Future<List<EnrollEntity>> getEnrolledCourses(String studentId);

  /// New method: enrollments + course metadata
  Future<List<CourseWithEnrollment>> getEnrolledCoursesWithDetails(
    String studentId,
  );

  Future<void> markSublessonCompleted({
    required String studentId,
    required String courseId,
    required String sublessonId,
  });

  Future<EnrollEntity?> getEnrollment({
    required String studentId,
    required String courseId,
  });

  // 2) Watch list of completed sublessons (read stream)
  Stream<List<String>> watchCompletedSublessons({
    required String studentId,
    required String courseId,
  });
  
   // optional: mark full course completed
  Future<void> markCourseCompleted({
    required String studentId,
    required String courseId,
  });
}
