// features/reviews/presentation/bloc/course_review_bloc.dart
import 'dart:async';
import 'package:eduera_student/features/reviews/domain/usecases/get_course_reviews.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/usecases/add_course_review.dart';
import 'course_review_event.dart';
import 'course_review_state.dart';

class CourseReviewBloc extends Bloc<CourseReviewEvent, CourseReviewState> {
  final AddCourseReview addReview;
  final GetCourseReviewsStream getReviewsStream;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _sub;

  CourseReviewBloc(this.addReview, this.getReviewsStream)
    : super(CourseReviewInitial()) {
    on<SubmitReviewEvent>(_onSubmit);
    on<LoadReviewsEvent>(_onLoad);
  }

  Future<void> _onSubmit(
    SubmitReviewEvent event,
    Emitter<CourseReviewState> emit,
  ) async {
    emit(CourseReviewLoading());
    try {
      await addReview(
        courseId: event.courseId,
        studentId: event.studentId,
        rating: event.rating,
        reviewText: event.reviewText,
      );
      emit(CourseReviewSubmitted());
    } catch (e) {
      emit(CourseReviewError(e.toString()));
    }
  }

  Future<void> _onLoad(
    LoadReviewsEvent event,
    Emitter<CourseReviewState> emit,
  ) async {
    emit(CourseReviewLoading());
    await _sub?.cancel();
    _sub = getReviewsStream(event.courseId).listen(
      (snap) => add(_EmitReviewsInternal(snap.docs)),
      onError: (e) => add(_EmitErrorInternal(e.toString())),
    );
  }

  // Internal events to bridge stream to bloc state

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}

// Internal event classes (kept private in same file)
class _EmitReviewsInternal extends CourseReviewEvent {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;
  _EmitReviewsInternal(this.docs);
}

class _EmitErrorInternal extends CourseReviewEvent {
  final String message;
  _EmitErrorInternal(this.message);
}

// Extend Bloc to handle internal events
extension _InternalHandlers on CourseReviewBloc {
}
