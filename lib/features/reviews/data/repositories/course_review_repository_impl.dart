// features/reviews/data/repositories/course_review_repository_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduera_student/features/reviews/data/datasources/course_review_remote.dart';
import '../../domain/repositories/course_review_repository.dart';

class CourseReviewRepositoryImpl implements CourseReviewRepository {
  final CourseReviewRemoteDataSource remote;
  CourseReviewRepositoryImpl(this.remote);

  @override
  Future<void> addReview(
    String courseId,
    String studentId,
    double rating,
    String reviewText,
  ) {
    return remote.addReview(
      courseId: courseId,
      studentId: studentId,
      rating: rating,
      reviewText: reviewText,
    );
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> reviewsStream(String courseId) {
    return remote.reviewsStream(courseId);
  }

  @override
  Future<void> recomputeAggregate(String courseId) {
    return remote.recomputeCourseAggregate(courseId);
  }
}
