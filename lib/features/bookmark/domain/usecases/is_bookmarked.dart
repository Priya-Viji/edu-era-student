import '../repositories/bookmark_repository.dart';

class IsBookmarked {
  final BookmarkRepository repository;
  IsBookmarked(this.repository);

  Future<bool> call({required String userId, required String courseId}) {
    return repository.isBookmarked(userId: userId, courseId: courseId);
  }
}
