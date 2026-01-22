// features/reviews/domain/usecases/get_course_reviews_stream.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../repositories/course_review_repository.dart';

class GetCourseReviewsStream {
  final CourseReviewRepository repo;
  GetCourseReviewsStream(this.repo);

  Stream<QuerySnapshot<Map<String, dynamic>>> call(String courseId) {
    return repo.reviewsStream(courseId);
  }
}
