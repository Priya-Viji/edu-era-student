// presentation/bloc/enrollment_bloc.dart
import 'package:eduera_student/features/chat/domain/usecases/ensure_chat_exists.dart';
import 'package:eduera_student/features/payment/domain/repositories/enroll_repository.dart';
import 'package:eduera_student/features/payment/presentation/bloc/enrollment/enrollment_event.dart';
import 'package:eduera_student/features/payment/presentation/bloc/enrollment/enrollment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnrollmentBloc extends Bloc<EnrollmentEvent, EnrollmentState> {
  final EnrollRepository repo;
  final EnsureChatExists ensureChatExists;

  EnrollmentBloc(this.repo, this.ensureChatExists)
    : super(EnrollmentInitial()) {
    on<SaveEnrollmentEvent>(_onSaveEnrollment);
    on<LoadEnrolledCoursesEvent>(_onLoadCourses);
  }

  Future<void> _onSaveEnrollment(
    SaveEnrollmentEvent event,
    Emitter<EnrollmentState> emit,
  ) async {
    emit(EnrollmentLoading());
    try {
      // 1. Save enrollment
      await repo.saveEnrollment(event.enrollment);

      // 2. Ensure chat exists for this student–mentor pair
      await ensureChatExists(
        studentId: event.enrollment.studentId,
        mentorId: event.enrollment.mentorId,
      );

      // 3. Emit success state
      emit(EnrollmentSaved());
    } catch (e) {
      emit(EnrollmentError(e.toString()));
    }
  }

  Future<void> _onLoadCourses(
    LoadEnrolledCoursesEvent event,
    Emitter<EnrollmentState> emit,
  ) async {
    emit(EnrollmentLoading());
    try {
      final courses = await repo.getEnrolledCoursesWithDetails(event.studentId);
      emit(EnrolledCoursesLoaded(courses)); // now holds CourseWithEnrollment
    } catch (e) {
      emit(EnrollmentError(e.toString()));
    }
  }
}
