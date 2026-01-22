import '../repositories/review_repository.dart';

class DeleteReview {
  final ReviewRepository repository;

  DeleteReview(this.repository);

  Future<void> call(String reviewId) {
    return repository.deleteReview(reviewId);
  }
}
