import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/usecases/fetch_reviews.dart';
import '../../domain/usecases/add_review.dart';
import '../../domain/usecases/edit_review.dart';
import '../../domain/usecases/delete_review.dart';
import '../../domain/usecases/toggle_like.dart';
import '../../domain/usecases/toggle_dislike.dart';

import 'review_event.dart';
import 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final FetchReviews fetchReviews;
  final AddReview addReview;
  final EditReview editReview;
  final DeleteReview deleteReview;
  final ToggleLike toggleLike;
  final ToggleDislike toggleDislike;

  DocumentSnapshot? lastDoc;
  String currentSort = "newest";
  String? currentFilter;

  ReviewBloc({
    required this.fetchReviews,
    required this.addReview,
    required this.editReview,
    required this.deleteReview,
    required this.toggleLike,
    required this.toggleDislike,
  }) : super(ReviewInitial()) {
    on<LoadReviews>(_onLoadReviews);
    on<LoadMoreReviews>(_onLoadMoreReviews);
    on<ChangeSortOrder>(_onChangeSortOrder);
    on<AddReviewEvent>(_onAddReview);
    on<EditReviewEvent>(_onEditReview);
    on<DeleteReviewEvent>(_onDeleteReview);
    on<ToggleLikeEvent>(_onToggleLike);
    on<ToggleDislikeEvent>(_onToggleDislike);
  }

  // -------------------------------------------------------
  // LOAD FIRST PAGE
  // -------------------------------------------------------
  Future<void> _onLoadReviews(
    LoadReviews event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoading());

    try {
      currentFilter = event.filter;
      lastDoc = null;

      final result = await fetchReviews(
        courseId: event.courseId,
        currentUserId: event.currentUserId,
        lastDoc: null,
        limit: 10,
        sortBy: currentSort,
        filter: currentFilter,
      );

      lastDoc = result.lastDoc;

      emit(
        ReviewLoaded(
          reviews: result.reviews,
          averageRating: result.averageRating,
          totalReviews: result.totalReviews,
          hasMore: result.hasMore,
          sortBy: currentSort,
        ),
      );
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  // -------------------------------------------------------
  // LOAD MORE (PAGINATION)
  // -------------------------------------------------------
  Future<void> _onLoadMoreReviews(
    LoadMoreReviews event,
    Emitter<ReviewState> emit,
  ) async {
    if (state is! ReviewLoaded) return;

    final currentState = state as ReviewLoaded;

    if (!currentState.hasMore) return;

    try {
      final result = await fetchReviews(
        courseId: event.courseId,
        currentUserId: event.currentUserId,
        lastDoc: lastDoc,
        limit: 10,
        sortBy: currentSort,
        filter: currentFilter,
      );

      lastDoc = result.lastDoc;

      emit(
        ReviewLoaded(
          reviews: [...currentState.reviews, ...result.reviews],
          averageRating: result.averageRating,
          totalReviews: result.totalReviews,
          hasMore: result.hasMore,
          sortBy: currentSort,
        ),
      );
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  // -------------------------------------------------------
  // CHANGE SORT ORDER
  // -------------------------------------------------------
  Future<void> _onChangeSortOrder(
    ChangeSortOrder event,
    Emitter<ReviewState> emit,
  ) async {
    currentSort = event.sortBy;

    if (state is ReviewLoaded) {
      final loaded = state as ReviewLoaded;

      add(
        LoadReviews(
          courseId: loaded.reviews.first.courseId,
          currentUserId: event.currentUserId,
          filter: currentFilter,
        ),
      );
    }
  }

  // -------------------------------------------------------
  // ADD REVIEW
  // -------------------------------------------------------
  Future<void> _onAddReview(
    AddReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    try {
      await addReview(event.review);

      add(
        LoadReviews(
          courseId: event.review.courseId,
          currentUserId: event.review.studentId,
          filter: currentFilter,
        ),
      );
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  // -------------------------------------------------------
  // EDIT REVIEW
  // -------------------------------------------------------
Future<void> _onEditReview(
    EditReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    try {
      await editReview(event.review);

      add(
        LoadReviews(
          courseId: event.review.courseId,
          currentUserId: event.review.studentId,
          filter: currentFilter,
        ),
      );
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }



  // -------------------------------------------------------
  // DELETE REVIEW
  // -------------------------------------------------------
  Future<void> _onDeleteReview(
    DeleteReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    try {
      await deleteReview(event.reviewId);

      add(
        LoadReviews(
          courseId: event.courseId,
          currentUserId: event.currentUserId,
          filter: currentFilter,
        ),
      );
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  // -------------------------------------------------------
  // LIKE TOGGLE (Optimistic UI)
  // -------------------------------------------------------
  Future<void> _onToggleLike(
    ToggleLikeEvent event,
    Emitter<ReviewState> emit,
  ) async {
    if (state is! ReviewLoaded) return;

    final currentState = state as ReviewLoaded;

    final index = currentState.reviews.indexWhere(
      (r) => r.id == event.reviewId,
    );
    if (index == -1) return;

    final oldReview = currentState.reviews[index];

    // Local update
    final updatedReview = oldReview.copyWith(
      likedBy: oldReview.likedBy.contains(event.currentUserId)
          ? (oldReview.likedBy..remove(event.currentUserId))
          : (oldReview.likedBy..add(event.currentUserId)),
      dislikedBy: oldReview.dislikedBy..remove(event.currentUserId),
      likeCount: oldReview.likedBy.length,
      dislikeCount: oldReview.dislikedBy.length,
      isLikedByCurrentUser: !oldReview.isLikedByCurrentUser,
    );

    final updatedList = [...currentState.reviews];
    updatedList[index] = updatedReview;

    emit(
      ReviewLoaded(
        reviews: updatedList,
        averageRating: currentState.averageRating,
        totalReviews: currentState.totalReviews,
        hasMore: currentState.hasMore,
        sortBy: currentState.sortBy,
      ),
    );

    // Sync with Firestore
    await toggleLike(
      reviewId: event.reviewId,
      currentUserId: event.currentUserId,
    );
  }

  // -------------------------------------------------------
  // DISLIKE TOGGLE (Optimistic UI)
  // -------------------------------------------------------
  Future<void> _onToggleDislike(
    ToggleDislikeEvent event,
    Emitter<ReviewState> emit,
  ) async {
    if (state is! ReviewLoaded) return;

    final currentState = state as ReviewLoaded;

    final index = currentState.reviews.indexWhere(
      (r) => r.id == event.reviewId,
    );
    if (index == -1) return;

    final oldReview = currentState.reviews[index];

    // Local update
    final updatedReview = oldReview.copyWith(
      dislikedBy: oldReview.dislikedBy.contains(event.currentUserId)
          ? (oldReview.dislikedBy..remove(event.currentUserId))
          : (oldReview.dislikedBy..add(event.currentUserId)),
      likedBy: oldReview.likedBy..remove(event.currentUserId),
      likeCount: oldReview.likedBy.length,
      dislikeCount: oldReview.dislikedBy.length,
      isLikedByCurrentUser: false,
    );

    final updatedList = [...currentState.reviews];
    updatedList[index] = updatedReview;

    emit(
      ReviewLoaded(
        reviews: updatedList,
        averageRating: currentState.averageRating,
        totalReviews: currentState.totalReviews,
        hasMore: currentState.hasMore,
        sortBy: currentState.sortBy,
      ),
    );

    // Sync with Firestore
    await toggleDislike(
      reviewId: event.reviewId,
      currentUserId: event.currentUserId,
    );
  }
}
