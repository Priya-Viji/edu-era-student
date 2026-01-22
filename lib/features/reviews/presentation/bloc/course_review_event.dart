// features/reviews/presentation/bloc/course_review_event.dart
abstract class CourseReviewEvent {}

class SubmitReviewEvent extends CourseReviewEvent {
  final String courseId;
  final String studentId;
  final double rating;
  final String reviewText;
  SubmitReviewEvent({
    required this.courseId,
    required this.studentId,
    required this.rating,
    required this.reviewText,
  });
}

class LoadReviewsEvent extends CourseReviewEvent {
  final String courseId;
  LoadReviewsEvent(this.courseId);
}
