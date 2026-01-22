import 'package:equatable/equatable.dart';

abstract class BookmarkEvent extends Equatable {
  const BookmarkEvent();

  @override
  List<Object?> get props => [];
}

/// 🔹 Load bookmark status for a single course
class LoadBookmarkStatus extends BookmarkEvent {
  final String userId;
  final String courseId;

  const LoadBookmarkStatus({required this.userId, required this.courseId});

  @override
  List<Object?> get props => [userId, courseId];
}

/// 🔹 Toggle bookmark for a single course
class ToggleBookmarkEvent extends BookmarkEvent {
  final String userId;
  final String courseId;

  const ToggleBookmarkEvent({required this.userId, required this.courseId});

  @override
  List<Object?> get props => [userId, courseId];
}

/// 🔹 Load all bookmarks for a user (global list)
class LoadAllBookmarks extends BookmarkEvent {
  final String userId;

  const LoadAllBookmarks({required this.userId});

  @override
  List<Object?> get props => [userId];
}
