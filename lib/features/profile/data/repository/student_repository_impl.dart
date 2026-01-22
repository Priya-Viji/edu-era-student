import 'package:eduera_student/features/profile/data/services/student_service.dart';
import 'package:eduera_student/features/profile/domain/models/student_model.dart';
import 'package:eduera_student/features/profile/domain/repository/student_repository.dart';

class StudentRepositoryImpl implements StudentRepository {
  final StudentService service;
  StudentRepositoryImpl(this.service);

  @override
  Stream<StudentModel?> streamStudent(String id) =>
      service.getStudentStream(id);

  @override
  Future<StudentModel?> getStudentById(String id) => service.getStudentById(id);

  @override
  Future<void> updateStudentProfile({
    required String name,
    required String phone,
    DateTime? dob,
    String? gender,
    String? education,
  }) {
    return service.updateStudentProfile(
      name: name,
      phone: phone,
      dob: dob,
      gender: gender,
      education: education,
    );
  }

  @override
  Stream<StudentModel> getStudentStream(String userId) {
    return service.getStudentStream(userId);
  }
}
