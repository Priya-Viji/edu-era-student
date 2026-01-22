import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduera_student/features/profile/domain/models/student_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentService {
  final _db = FirebaseFirestore.instance;

  /// Create a new student document
  Future<void> createStudent(StudentModel student) async {
    try {
      await _db
          .collection('students')
          .doc(student.studentId)
          .set(student.toMap());
    } catch (e) {
      throw Exception("Failed to create student: $e");
    }
  }

  /// One-time fetch by ID
  Future<StudentModel?> getStudentById(String id) async {
    try {
      final doc = await _db.collection('students').doc(id).get();
      if (!doc.exists) return null;
      return StudentModel.fromFirestore(doc);
    } catch (e) {
      throw Exception("Failed to fetch student: $e");
    }
  }

  /// Update current logged-in student's profile
  Future<void> updateStudentProfile({
    required String name,
    required String phone,
    DateTime? dob,
    String? gender,
    String? education,
    String? profileImageUrl,
    String? language,
  }) async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;

      await _db.collection("students").doc(userId).update({
        "name": name,
        "phone": phone,
        "dob": dob != null ? Timestamp.fromDate(dob) : null,
        "gender": gender,
        "education": education,
        "profileImageUrl": profileImageUrl,
        "language": language,
      });
    } catch (e) {
      throw Exception("Failed to update student profile: $e");
    }
  }

  /// Real-time stream of student profile
  Stream<StudentModel> getStudentStream(String userId) {
    try {
      return _db
          .collection('students')
          .doc(userId)
          .snapshots()
          .map((doc) => StudentModel.fromFirestore(doc));
    } catch (e) {
      // Convert synchronous errors into a stream error
      return Stream.error("Failed to stream student: $e");
    }
  }
}
