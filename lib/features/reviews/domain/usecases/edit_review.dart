import 'package:eduera_student/features/reviews/domain/entities/review.dart';

import '../repositories/review_repository.dart';

class EditReview {
  final ReviewRepository repository;

  EditReview(this.repository);

  Future<void> call(Review review) {
    return repository.editReview(review);
  }
}
