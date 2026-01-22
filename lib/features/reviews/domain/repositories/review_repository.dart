import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduera_student/features/reviews/domain/entities/fetch_reviews_result.dart';
import 'package:eduera_student/features/reviews/domain/entities/review.dart';

abstract class ReviewRepository {
  /// Add a new review
  Future<void> addReview(Review review);

  /// Edit an existing review
  Future<void> editReview(Review review);

  /// Delete a review
  Future<void> deleteReview(String reviewId);

  /// Fetch reviews with pagination + sorting + filtering
  Future<FetchReviewsResult> fetchReviews({
    required String courseId,
    required String currentUserId,
    DocumentSnapshot? lastDoc,
    int limit = 10,
    String sortBy = "newest",
    String? filter,
  });

  /// Toggle like
  Future<void> toggleLike({
    required String reviewId,
    required String currentUserId,
  });

  /// Toggle dislike
  Future<void> toggleDislike({
    required String reviewId,
    required String currentUserId,
  });
}
