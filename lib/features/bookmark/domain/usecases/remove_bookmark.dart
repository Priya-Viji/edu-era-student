import '../repositories/bookmark_repository.dart';

class RemoveBookmark {
  final BookmarkRepository repository;
  RemoveBookmark(this.repository);

  Future<void> call({required String userId, required String courseId}) {
    return repository.removeBookmark(userId: userId, courseId: courseId);
  }
}
