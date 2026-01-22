import 'package:eduera_student/features/bookmark/domain/repositories/bookmark_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bookmark_event.dart';
import 'bookmark_state.dart';
import '../../domain/usecases/add_bookmark.dart';
import '../../domain/usecases/remove_bookmark.dart';
import '../../domain/usecases/is_bookmarked.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  final AddBookmark addBookmark;
  final RemoveBookmark removeBookmark;
  final IsBookmarked isBookmarked;
  final BookmarkRepository repository;

  BookmarkBloc({
    required this.addBookmark,
    required this.removeBookmark,
    required this.isBookmarked,
    required this.repository,
  }) : super(BookmarkInitial()) {
    on<LoadBookmarkStatus>(_onLoad);
    on<ToggleBookmarkEvent>(_onToggle);
    on<LoadAllBookmarks>(_onLoadAll);
  }

  Future<void> _onLoad(
    LoadBookmarkStatus event,
    Emitter<BookmarkState> emit,
  ) async {
    emit(BookmarkLoading());
    try {
      final status = await isBookmarked(
        userId: event.userId,
        courseId: event.courseId,
      );
      emit(BookmarkStatus(courseId: event.courseId, isBookmarked: status));
    } catch (e) {
      emit(BookmarkError(e.toString()));
    }
  }

  Future<void> _onToggle(
    ToggleBookmarkEvent event,
    Emitter<BookmarkState> emit,
  ) async {
    final currentState = state;

    try {
      if (currentState is BookmarkListLoaded) {
        final isBookmarked = currentState.bookmarkedCourseIds.contains(
          event.courseId,
        );

        if (isBookmarked) {
          await removeBookmark(userId: event.userId, courseId: event.courseId);
          final updatedIds = Set<String>.from(currentState.bookmarkedCourseIds)
            ..remove(event.courseId);
          emit(BookmarkListLoaded(updatedIds));
        } else {
          await addBookmark(userId: event.userId, courseId: event.courseId);
          final updatedIds = Set<String>.from(currentState.bookmarkedCourseIds)
            ..add(event.courseId);
          emit(BookmarkListLoaded(updatedIds));
        }
      } else if (currentState is BookmarkStatus) {
        final current = currentState.isBookmarked;

        if (current) {
          await removeBookmark(userId: event.userId, courseId: event.courseId);
        } else {
          await addBookmark(userId: event.userId, courseId: event.courseId);
        }

        emit(BookmarkStatus(courseId: event.courseId, isBookmarked: !current));
      }
    } catch (e) {
      emit(BookmarkError(e.toString()));
    }
  }

  Future<void> _onLoadAll(
    LoadAllBookmarks event,
    Emitter<BookmarkState> emit,
  ) async {
    emit(BookmarkLoading());
    try {
      final ids = await repository.getBookmarkedCourseIds(userId: event.userId);
      emit(BookmarkListLoaded(ids.toSet()));
    } catch (e) {
      emit(BookmarkError(e.toString()));
    }
  }
}
