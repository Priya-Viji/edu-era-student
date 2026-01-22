import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduera_student/features/payment/domain/usecases/watch_enroll_progress_usecase.dart';
import 'package:eduera_student/features/payment/domain/usecases/mark_sublesson_completed_usecase.dart';
import 'package:eduera_student/features/payment/domain/usecases/mark_course_completed_usecase.dart';

// ---------------------------------------------------------
// EVENTS
// ---------------------------------------------------------

abstract class LessonProgressEvent {}

class LoadLessonProgressEvent extends LessonProgressEvent {
  final String studentId;
  final String courseId;
  final int totalSubLessons;

  LoadLessonProgressEvent({
    required this.studentId,
    required this.courseId,
    required this.totalSubLessons,
  });
}

class MarkSubLessonCompletedEvent extends LessonProgressEvent {
  final String studentId;
  final String courseId;
  final String subLessonId;

  MarkSubLessonCompletedEvent({
    required this.studentId,
    required this.courseId,
    required this.subLessonId,
  });
}

class _ProgressUpdatedEvent extends LessonProgressEvent {
  final List<String> completed;
  final int total;
  final String studentId;
  final String courseId;

  _ProgressUpdatedEvent(
    this.completed,
    this.total,
    this.studentId,
    this.courseId,
  );
}

// ---------------------------------------------------------
// STATES
// ---------------------------------------------------------

abstract class LessonProgressState {}

class LessonProgressInitial extends LessonProgressState {}

class LessonProgressLoading extends LessonProgressState {}

class LessonProgressLoaded extends LessonProgressState {
  final List<String> completedSubLessons;

  LessonProgressLoaded(this.completedSubLessons);
}

class LessonProgressError extends LessonProgressState {
  final String message;
  LessonProgressError(this.message);
}

// ---------------------------------------------------------
// BLOC
// ---------------------------------------------------------

class LessonProgressBloc
    extends Bloc<LessonProgressEvent, LessonProgressState> {
  final WatchEnrollmentProgressUseCase watchUseCase;
  final MarkSublessonCompletedUseCase markUseCase;
  final MarkCourseCompletedUseCase markCourseCompletedUseCase;

  StreamSubscription<List<String>>? _sub;

  LessonProgressBloc({
    required this.watchUseCase,
    required this.markUseCase,
    required this.markCourseCompletedUseCase,
  }) : super(LessonProgressInitial()) {
    on<LoadLessonProgressEvent>(_onLoad);
    on<MarkSubLessonCompletedEvent>(_onMark);
    on<_ProgressUpdatedEvent>(_onUpdated);
  }

  // Load progress stream
  void _onLoad(LoadLessonProgressEvent e, Emitter emit) {
    emit(LessonProgressLoading());

    _sub?.cancel();

    _sub = watchUseCase(e.studentId, e.courseId).listen(
      (completedList) {
        add(
          _ProgressUpdatedEvent(
            completedList,
            e.totalSubLessons,
            e.studentId,
            e.courseId,
          ),
        );
      },
      onError: (err) {
        emit(LessonProgressError(err.toString()));
      },
    );
  }

  // Mark a sublesson completed
  void _onMark(MarkSubLessonCompletedEvent e, Emitter emit) {
    markUseCase(e.studentId, e.courseId, e.subLessonId);
  }

  // Update UI + check course completion
  void _onUpdated(_ProgressUpdatedEvent e, Emitter emit) {
    emit(LessonProgressLoaded(e.completed));

    if (e.completed.length == e.total) {
      markCourseCompletedUseCase(e.studentId, e.courseId);
    }
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
