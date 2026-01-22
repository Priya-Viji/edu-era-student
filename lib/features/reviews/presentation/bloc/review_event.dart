import '../../domain/entities/review.dart';

abstract class ReviewEvent {}

/// -------------------------------------------------------
/// LOAD FIRST PAGE OF REVIEWS
/// -------------------------------------------------------
class LoadReviews extends ReviewEvent {
  final String courseId;
  final String currentUserId;
  final String? filter; // optional filter: Excellent, Good, etc.

  LoadReviews({
    required this.courseId,
    required this.currentUserId,
    this.filter,
  });
}

/// -------------------------------------------------------
/// LOAD MORE REVIEWS (Pagination)
/// -------------------------------------------------------
class LoadMoreReviews extends ReviewEvent {
  final String courseId;
  final String currentUserId;

  LoadMoreReviews({required this.courseId, required this.currentUserId});
}

/// -------------------------------------------------------
/// ADD REVIEW
/// -------------------------------------------------------
class AddReviewEvent extends ReviewEvent {
  final Review review;

  AddReviewEvent(this.review);
}

class ChangeSortOrder extends ReviewEvent {
  final String sortBy;
  final String currentUserId;

  ChangeSortOrder({
    required this.sortBy,
    required this.currentUserId,
  });
}



/// -------------------------------------------------------
/// LIKE TOGGLE
/// -------------------------------------------------------
class ToggleLikeEvent extends ReviewEvent {
  final String reviewId;
  final String currentUserId;

  ToggleLikeEvent({required this.reviewId, required this.currentUserId});
}

/// -------------------------------------------------------
/// DISLIKE TOGGLE
/// -------------------------------------------------------
class ToggleDislikeEvent extends ReviewEvent {
  final String reviewId;
  final String currentUserId;

  ToggleDislikeEvent({required this.reviewId, required this.currentUserId});
}

class DeleteReviewEvent extends ReviewEvent {
  final String reviewId;
  final String courseId;
  final String currentUserId;

  DeleteReviewEvent({
    required this.reviewId,
    required this.courseId,
    required this.currentUserId,
  });
}

class EditReviewEvent extends ReviewEvent {
  final Review review;
  
  EditReviewEvent(this.review);
}


