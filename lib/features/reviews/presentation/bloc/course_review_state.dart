// features/reviews/presentation/bloc/course_review_state.dart
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class CourseReviewState {}

class CourseReviewInitial extends CourseReviewState {}

class CourseReviewLoading extends CourseReviewState {}

class CourseReviewSubmitted extends CourseReviewState {}

class CourseReviewsLoaded extends CourseReviewState {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;
  CourseReviewsLoaded(this.docs);
}

class CourseReviewError extends CourseReviewState {
  final String message;
  CourseReviewError(this.message);
}
