import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduera_student/features/payment/domain/entities/enroll_entity.dart';

class EnrollModel {
  final String studentId;
  final String mentorId;
  final String courseId;
  final String courseTitle;
  final String paymentId;
  final String status;
  final double price;
  final String plan;
  final DateTime enrolledAt;

  final List<String> completedSubLessons;
  final bool isCourseCompleted;

  const EnrollModel({
    required this.studentId,
    required this.mentorId,
    required this.courseId,
    required this.courseTitle,
    required this.paymentId,
    required this.status,
    required this.price,
    required this.plan,
    required this.enrolledAt,
    required this.completedSubLessons,
    required this.isCourseCompleted,
  });

  // -----------------------------
  // FROM ENTITY → MODEL
  // -----------------------------
  factory EnrollModel.fromEntity(EnrollEntity e) => EnrollModel(
    studentId: e.studentId,
    mentorId: e.mentorId,
    courseId: e.courseId,
    courseTitle: e.courseTitle,
    paymentId: e.paymentId,
    status: e.status,
    price: e.price,
    plan: e.plan,
    enrolledAt: e.enrolledAt,
    completedSubLessons: e.completedSubLessons,
    isCourseCompleted: e.isCourseCompleted,
  );

  // -----------------------------
  // FROM FIRESTORE → MODEL
  // -----------------------------
  factory EnrollModel.fromMap(Map<String, dynamic> map) {
    return EnrollModel(
      studentId: map['studentId'] ?? '',
      mentorId: map['mentorId'] ?? '',
      courseId: map['courseId'] ?? '',
      courseTitle: map['courseTitle'] ?? '',
      paymentId: map['paymentId'] ?? '',
      status: map['status'] ?? 'ongoing',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      plan: map['plan'] ?? '',
      enrolledAt: (map['enrolledAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      completedSubLessons: List<String>.from(map['completedSubLessons'] ?? []),
      isCourseCompleted: map['isCourseCompleted'] ?? false,
    );
  }

  // -----------------------------
  // MODEL → FIRESTORE MAP
  // -----------------------------
  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'mentorId': mentorId,
      'courseId': courseId,
      'courseTitle': courseTitle,
      'paymentId': paymentId,
      'status': status,
      'price': price,
      'plan': plan,
      'enrolledAt': Timestamp.fromDate(enrolledAt),
      'completedSubLessons': completedSubLessons,
      'isCourseCompleted': isCourseCompleted,
    };
  }

  // -----------------------------
  // MODEL → ENTITY
  // -----------------------------
  EnrollEntity toEntity() => EnrollEntity(
    studentId: studentId,
    mentorId: mentorId,
    courseId: courseId,
    courseTitle: courseTitle,
    paymentId: paymentId,
    status: status,
    price: price,
    plan: plan,
    enrolledAt: enrolledAt,
    completedSubLessons: completedSubLessons,
    isCourseCompleted: isCourseCompleted,
  );
}
