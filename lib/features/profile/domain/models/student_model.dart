import 'package:cloud_firestore/cloud_firestore.dart';

enum StudentStatus { active, blocked }

extension StudentStatusExtension on StudentStatus {
  String get value {
    switch (this) {
      case StudentStatus.active:
        return "active";
      case StudentStatus.blocked:
        return "blocked";
    }
  }

  static StudentStatus fromString(String? status) {
    switch (status) {
      case "active":
        return StudentStatus.active;
      case "blocked":
        return StudentStatus.blocked;
      default:
        return StudentStatus.active;
    }
  }
}


class StudentModel {
  final String studentId;
  final String name;
  final String email;
  final String phone;
  final DateTime? dob;
  final String? gender;
  final String? education;
  final String? profileImageUrl;
  final String? language;
  final StudentStatus status;
  final DateTime createdAt;

  StudentModel({
    required this.studentId,
    required this.name,
    required this.email,
    required this.phone,
    this.dob,
    this.gender,
    this.education,
    this.profileImageUrl,
    this.language,
    required this.status,
    required this.createdAt,
  });

  /// ✅ Factory to build from Firestore map
  factory StudentModel.fromMap(Map<String, dynamic> map, String studentId) {
    return StudentModel(
      studentId: studentId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',

      // Safely convert Timestamp → DateTime
      dob: map['dob'] != null && map['dob'] is Timestamp
          ? (map['dob'] as Timestamp).toDate()
          : null,

      gender: map['gender'] as String?,
      education: map['education'] as String?,
      profileImageUrl: map['profileImageUrl'] as String?,
      language: map['language'] as String?,

      status: StudentStatusExtension.fromString(map['status'] as String?),

      // Safely handle createdAt
      createdAt: map['createdAt'] != null && map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  /// ✅ Convert model back to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'name': name,
      'email': email,
      'phone': phone,

      // Convert DateTime → Timestamp safely
      'dob': dob != null ? Timestamp.fromDate(dob!) : null,

      'gender': gender,
      'education': education,
      'profileImageUrl': profileImageUrl,
      'language': language,
      'status': status.value,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// ✅ Convenience factory for DocumentSnapshot
  factory StudentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StudentModel.fromMap(data, doc.id);
  }
}
