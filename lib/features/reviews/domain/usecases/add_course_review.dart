// features/reviews/domain/usecases/add_course_review.dart
import '../repositories/course_review_repository.dart';

class AddCourseReview {
  final CourseReviewRepository repo;
  AddCourseReview(this.repo);

  Future<void> call({
    required String courseId,
    required String studentId,
    required double rating,
    required String reviewText,
  }) async {
    await repo.addReview(courseId, studentId, rating, reviewText);
    await repo.recomputeAggregate(courseId);
  }
}
