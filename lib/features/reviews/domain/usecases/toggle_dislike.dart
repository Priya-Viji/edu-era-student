import '../repositories/review_repository.dart';

class ToggleDislike {
  final ReviewRepository repository;

  ToggleDislike(this.repository);

  Future<void> call({required String reviewId, required String currentUserId}) {
    return repository.toggleDislike(
      reviewId: reviewId,
      currentUserId: currentUserId,
    );
  }
}
