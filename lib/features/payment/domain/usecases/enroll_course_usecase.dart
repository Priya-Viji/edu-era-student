// domain/usecases/enroll_course_usecase.dart
import 'package:eduera_student/features/payment/domain/entities/enroll_entity.dart';
import 'package:eduera_student/features/payment/domain/repositories/enroll_repository.dart';

class EnrollCourseUseCase {
  final EnrollRepository repository;
  EnrollCourseUseCase(this.repository);

  
  Future<void> call(EnrollEntity enrollment) async {
    return await repository.saveEnrollment(enrollment);
  }
}
