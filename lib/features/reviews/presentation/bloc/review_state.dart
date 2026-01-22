import '../../domain/entities/review.dart';

abstract class ReviewState {}

/// -------------------------------------------------------
/// INITIAL
/// -------------------------------------------------------
class ReviewInitial extends ReviewState {}

/// -------------------------------------------------------
/// LOADING (first page)
/// -------------------------------------------------------
class ReviewLoading extends ReviewState {}

/// -------------------------------------------------------
/// LOADED (supports pagination)
/// -------------------------------------------------------
class ReviewLoaded extends ReviewState {
  final List<Review> reviews;
  final double averageRating;
  final int totalReviews;
  final bool hasMore;
  final String sortBy; //  important for lazy loading
  final String? filter;

  ReviewLoaded({
    required this.reviews,
    required this.averageRating,
    required this.totalReviews,
    required this.hasMore,
    required this.sortBy,
    this.filter,
  });
}

/// -------------------------------------------------------
/// ERROR
/// -------------------------------------------------------
class ReviewError extends ReviewState {
  final String message;

  ReviewError(this.message);
}

