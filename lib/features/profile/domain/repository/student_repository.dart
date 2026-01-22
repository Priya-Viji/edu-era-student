import 'package:eduera_student/features/profile/domain/models/student_model.dart';

abstract class StudentRepository {
  Stream<StudentModel?> streamStudent(String id);
  Future<StudentModel?> getStudentById(String id);

  Future<void> updateStudentProfile({
    required String name,
    required String phone,
    DateTime? dob,
    String? gender,
    String? education,
  });

  Stream<StudentModel> getStudentStream(String userId);
}
