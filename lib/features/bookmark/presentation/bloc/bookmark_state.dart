import 'package:equatable/equatable.dart';

abstract class BookmarkState extends Equatable {
  const BookmarkState();

  @override
  List<Object?> get props => [];
}

class BookmarkInitial extends BookmarkState {}

class BookmarkLoading extends BookmarkState {}

/// 🔹 State for single course bookmark status
class BookmarkStatus extends BookmarkState {
  final String courseId;
  final bool isBookmarked;

  const BookmarkStatus({required this.courseId, required this.isBookmarked});

  @override
  List<Object?> get props => [courseId, isBookmarked];
}

/// 🔹 State for all bookmarks (list of IDs)
class BookmarkListLoaded extends BookmarkState {
  final Set<String> bookmarkedCourseIds;

  const BookmarkListLoaded(this.bookmarkedCourseIds);

  @override
  List<Object?> get props => [bookmarkedCourseIds];
}

class BookmarkError extends BookmarkState {
  final String message;

  const BookmarkError(this.message);

  @override
  List<Object?> get props => [message];
}
