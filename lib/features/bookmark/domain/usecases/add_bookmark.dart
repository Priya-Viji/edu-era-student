import '../repositories/bookmark_repository.dart';

class AddBookmark {
  final BookmarkRepository repository;
  AddBookmark(this.repository);

  Future<void> call({required String userId, required String courseId}) {
    return repository.addBookmark(userId: userId, courseId: courseId);
  }
}
