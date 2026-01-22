import 'package:cloud_firestore/cloud_firestore.dart';

import '../entities/fetch_reviews_result.dart';
import '../repositories/review_repository.dart';

class FetchReviews {
  final ReviewRepository repository;

  FetchReviews(this.repository);

  Future<FetchReviewsResult> call({
    required String courseId,
    required String currentUserId,
    DocumentSnapshot? lastDoc,
    int limit = 10,
    String sortBy = 'newest',
    String? filter,
  }) {
    return repository.fetchReviews(
      courseId: courseId,
      currentUserId: currentUserId,
      lastDoc: lastDoc,
      limit: limit,
      sortBy: sortBy,
      filter: filter,
    );
  }
}
