import 'package:eduera_student/features/reviews/domain/repositories/review_repository.dart';

class ToggleLike {
  final ReviewRepository repository;

  ToggleLike(this.repository);

  Future<void> call({required String reviewId, required String currentUserId}) {
    return repository.toggleLike(
      reviewId: reviewId,
      currentUserId: currentUserId,
    );
  }
}
