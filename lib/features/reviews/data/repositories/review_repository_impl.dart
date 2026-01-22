import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/review.dart';
import '../../domain/entities/fetch_reviews_result.dart';
import '../../domain/repositories/review_repository.dart';
import '../models/review_model.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final FirebaseFirestore firestore;

  ReviewRepositoryImpl(this.firestore);

  CollectionReference get _reviews => firestore.collection('reviews');

  // ---------------------------------------------------------
  // ADD REVIEW
  // ---------------------------------------------------------
  @override
  Future<void> addReview(Review review) async {
    await _reviews.doc(review.id).set(ReviewModel.toMap(review));
  }

  // ---------------------------------------------------------
  // EDIT REVIEW
  // ---------------------------------------------------------
  @override
  Future<void> editReview(Review review) async {
    await _reviews.doc(review.id).update({
      'rating': review.rating,
      'comment': review.comment,
      'ratingCategory': review.ratingCategory,
      'updatedAt': DateTime.now(),
    });
  }

  // ---------------------------------------------------------
  // DELETE REVIEW
  // ---------------------------------------------------------
  @override
  Future<void> deleteReview(String reviewId) async {
    await _reviews.doc(reviewId).delete();
  }

  // ---------------------------------------------------------
  // FETCH REVIEWS (pagination + sorting + filtering)
  // ---------------------------------------------------------
  @override
  Future<FetchReviewsResult> fetchReviews({
    required String courseId,
    required String currentUserId,
    DocumentSnapshot? lastDoc,
    int limit = 10,
    String sortBy = "newest",
    String? filter,
  }) async {
    Query query = _reviews.where('courseId', isEqualTo: courseId);

    //  Filtering by ratingCategory
    if (filter != null && filter.isNotEmpty) {
      query = query.where('ratingCategory', isEqualTo: filter);
    }

    // ⭐ Sorting
    if (sortBy == "rating") {
      query = query.orderBy('rating', descending: true);
    } else {
      query = query.orderBy('createdAt', descending: true);
    }

    // ⭐ Pagination
    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    query = query.limit(limit);

    final snapshot = await query.get();

    final reviews = snapshot.docs
        .map((doc) => ReviewModel.fromDoc(doc, currentUserId))
        .toList();

    //  Compute average rating
    final avg = reviews.isEmpty
        ? 0.0
        : reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;

    return FetchReviewsResult(
      reviews: reviews,
      averageRating: avg,
      totalReviews: reviews.length,
      hasMore: snapshot.docs.length == limit,
      lastDoc: snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
    );
  }

  // ---------------------------------------------------------
  // TOGGLE LIKE
  // ---------------------------------------------------------
  @override
  Future<void> toggleLike({
    required String reviewId,
    required String currentUserId,
  }) async {
    final ref = _reviews.doc(reviewId);

    await firestore.runTransaction((tx) async {
      final snap = await tx.get(ref);
      if (!snap.exists) return;

      final data = snap.data() as Map<String, dynamic>;

      List likedBy = List.from(data['likedBy'] ?? []);
      List dislikedBy = List.from(data['dislikedBy'] ?? []);

      if (likedBy.contains(currentUserId)) {
        likedBy.remove(currentUserId);
      } else {
        likedBy.add(currentUserId);
        dislikedBy.remove(currentUserId);
      }

      tx.update(ref, {
        'likedBy': likedBy,
        'dislikedBy': dislikedBy,
        'likeCount': likedBy.length,
        'dislikeCount': dislikedBy.length,
      });
    });
  }

  // ---------------------------------------------------------
  // TOGGLE DISLIKE
  // ---------------------------------------------------------
  @override
  Future<void> toggleDislike({
    required String reviewId,
    required String currentUserId,
  }) async {
    final ref = _reviews.doc(reviewId);

    await firestore.runTransaction((tx) async {
      final snap = await tx.get(ref);
      if (!snap.exists) return;

      final data = snap.data() as Map<String, dynamic>;

      List likedBy = List.from(data['likedBy'] ?? []);
      List dislikedBy = List.from(data['dislikedBy'] ?? []);

      if (dislikedBy.contains(currentUserId)) {
        dislikedBy.remove(currentUserId);
      } else {
        dislikedBy.add(currentUserId);
        likedBy.remove(currentUserId);
      }

      tx.update(ref, {
        'likedBy': likedBy,
        'dislikedBy': dislikedBy,
        'likeCount': likedBy.length,
        'dislikeCount': dislikedBy.length,
      });
    });
  }
}
