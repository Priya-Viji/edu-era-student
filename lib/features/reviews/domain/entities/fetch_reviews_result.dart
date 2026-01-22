import 'package:cloud_firestore/cloud_firestore.dart';
import 'review.dart';

class FetchReviewsResult {
  final List<Review> reviews;
  final double averageRating;
  final int totalReviews;
  final bool hasMore;
  final DocumentSnapshot? lastDoc;

  FetchReviewsResult({
    required this.reviews,
    required this.averageRating,
    required this.totalReviews,
    required this.hasMore,
    required this.lastDoc,
  });
}
