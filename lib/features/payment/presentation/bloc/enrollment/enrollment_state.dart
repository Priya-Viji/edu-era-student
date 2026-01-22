// presentation/bloc/enrollment_state.dart
import 'package:eduera_student/features/payment/data/model/course_with_enrollment.dart';
import 'package:equatable/equatable.dart';

abstract class EnrollmentState extends Equatable {
  const EnrollmentState();
  @override
  List<Object?> get props => [];
}

class EnrollmentInitial extends EnrollmentState {}

class EnrollmentLoading extends EnrollmentState {}

class EnrollmentSaved extends EnrollmentState {}

class EnrollmentError extends EnrollmentState {
  final String message;
  const EnrollmentError(this.message);
  @override
  List<Object?> get props => [message];
}

class EnrolledCoursesLoaded extends EnrollmentState {
  final List<CourseWithEnrollment> courses;
  const EnrolledCoursesLoaded(this.courses);
  @override
  List<Object?> get props => [courses];
}
