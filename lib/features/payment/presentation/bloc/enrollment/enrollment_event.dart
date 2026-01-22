// presentation/bloc/enrollment_event.dart
import 'package:eduera_student/features/payment/domain/entities/enroll_entity.dart';
import 'package:equatable/equatable.dart';

abstract class EnrollmentEvent extends Equatable {
  const EnrollmentEvent();
  @override
  List<Object?> get props => [];
}

class SaveEnrollmentEvent extends EnrollmentEvent {
  final EnrollEntity enrollment;
  const SaveEnrollmentEvent(this.enrollment);
  @override
  List<Object?> get props => [enrollment];
}

class LoadEnrolledCoursesEvent extends EnrollmentEvent {
  final String studentId;
  const LoadEnrolledCoursesEvent(this.studentId);
  @override
  List<Object?> get props => [studentId];
}
