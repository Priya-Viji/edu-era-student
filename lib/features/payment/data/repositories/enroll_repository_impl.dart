import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduera_student/features/home/data/models/course_model.dart';
import 'package:eduera_student/features/payment/data/data_sources/enroll_remote_datasource.dart';
import 'package:eduera_student/features/payment/data/model/course_with_enrollment.dart';
import 'package:eduera_student/features/payment/data/model/enroll_model.dart';
import 'package:eduera_student/features/payment/domain/entities/enroll_entity.dart';
import 'package:eduera_student/features/payment/domain/repositories/enroll_repository.dart';

class EnrollRepositoryImpl implements EnrollRepository {
  final EnrollRemoteDataSource dataSource;
  final FirebaseFirestore firestore;

  EnrollRepositoryImpl(this.dataSource, this.firestore);

  // ---------------------------------------------------------
  // BASIC ENROLLMENT
  // ---------------------------------------------------------

  @override
  Future<void> saveEnrollment(EnrollEntity enrollment) async {
    final model = EnrollModel.fromEntity(enrollment);
    await dataSource.saveEnrollment(model);
  }

  @override
  Future<bool> isEnrolled(String studentId, String courseId) {
    return dataSource.isEnrolled(studentId, courseId);
  }

  @override
  Future<List<EnrollEntity>> getEnrolledCourses(String studentId) async {
    final models = await dataSource.getEnrolledCourses(studentId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<EnrollEntity?> getEnrollment({
    required String studentId,
    required String courseId,
  }) async {
    final enrollmentId = "${studentId}_$courseId";
    final doc = await firestore
        .collection('enrollments')
        .doc(enrollmentId)
        .get();

    if (!doc.exists) return null;

    final model = EnrollModel.fromMap(doc.data()!);
    return model.toEntity();
  }

  // ---------------------------------------------------------
  // ENROLLMENT + COURSE DETAILS
  // ---------------------------------------------------------

  @override
  Future<List<CourseWithEnrollment>> getEnrolledCoursesWithDetails(
    String studentId,
  ) async {
    final enrollments = await dataSource.getEnrolledCourses(studentId);
    final List<CourseWithEnrollment> result = [];

    for (final e in enrollments) {
      final entity = e.toEntity();

      // 1. Load course
      final courseDoc = await firestore
          .collection('courses')
          .doc(entity.courseId)
          .get();

      if (!courseDoc.exists) continue;

      var course = CourseModel.fromFirestore(courseDoc);

      // 2. Load all reviews for this course
     final reviewsSnap = await firestore
          .collection('reviews')
          .where('courseId', isEqualTo: entity.courseId)
          .get();

      double? avgRating = course.rating; // fallback if no reviews

      if (reviewsSnap.docs.isNotEmpty) {
        final ratings = reviewsSnap.docs
            .map((d) => (d.data()['rating'] as num).toDouble())
            .toList();
        print('ratings: $ratings');

        final total = ratings.fold<double>(0.0, (sum, r) => sum + r);
        avgRating = total / ratings.length;
        print('average: $avgRating');
      }

      // 3. Override rating in course model
      course = course.copyWith(rating: avgRating);

      // 4. Build CourseWithEnrollment
      result.add(CourseWithEnrollment(enrollment: entity, course: course));
    }

    return result;
  }

  // ---------------------------------------------------------
  // PROGRESS TRACKING (NEW SYSTEM)
  // ---------------------------------------------------------

  // ---------------------------------------------------------
// PROGRESS TRACKING (NEW SYSTEM)
// ---------------------------------------------------------

@override
Stream<List<String>> watchCompletedSublessons({
  required String studentId,
  required String courseId,
}) {
  return dataSource.watchCompletedSublessons(
    studentId: studentId,
    courseId: courseId,
  );
}

@override
Future<void> markSublessonCompleted({
  required String studentId,
  required String courseId,
  required String sublessonId,   // MUST MATCH abstract class
}) {
  return dataSource.markSublessonCompleted(
    studentId: studentId,
    courseId: courseId,
    sublessonId: sublessonId,
  );
}

@override
Future<void> markCourseCompleted({
  required String studentId,
  required String courseId,
}) {
  return dataSource.markCourseCompleted(
    studentId: studentId,
    courseId: courseId,
  );
}
}