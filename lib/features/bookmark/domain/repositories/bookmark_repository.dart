abstract class BookmarkRepository {
  /// Add a course to the user's bookmarks
  Future<void> addBookmark({required String userId, required String courseId});

  /// Remove a course from the user's bookmarks
  Future<void> removeBookmark({
    required String userId,
    required String courseId,
  });

  /// Check if a specific course is bookmarked by the user
  Future<bool> isBookmarked({required String userId, required String courseId});

  /// Get all bookmarked course IDs for a user
  Future<List<String>> getBookmarkedCourseIds({required String userId});
}
