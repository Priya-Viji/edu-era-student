// features/reviews/domain/repositories/course_review_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class CourseReviewRepository {
  Future<void> addReview(
    String courseId,
    String studentId,
    double rating,
    String reviewText,
  );

  Stream<QuerySnapshot<Map<String, dynamic>>> reviewsStream(String courseId);

  Future<void> recomputeAggregate(String courseId);
}
