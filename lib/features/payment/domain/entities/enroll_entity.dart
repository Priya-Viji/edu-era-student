class EnrollEntity {
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

  const EnrollEntity({
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
}
