import 'package:eduera_student/features/payment/domain/entities/enroll_entity.dart';
import 'package:eduera_student/features/home/data/models/course_model.dart';

class CourseWithEnrollment {
  final EnrollEntity enrollment;
  final CourseModel course;

  const CourseWithEnrollment({required this.enrollment, required this.course});

  // Convenience getters for UI
  String get courseId => enrollment.courseId;
  String get mentorId => enrollment.mentorId;
  String get title => course.title;
  String get category => course.category;
  String? get imageUrl => course.thumbnailUrl;
  double? get rating => course.rating;
  String get status => enrollment.status;
  DateTime get enrolledAt => enrollment.enrolledAt;
  String get duration => formatDuration(totalDurationSeconds);

  /// Total duration in seconds, summed from all sub-lessons
  int get totalDurationSeconds {
    int total = 0;

    for (final lesson in course.lessons) {
      for (final sub in lesson.subLessons) {
        total += sub.duration; // duration from SubLessonModel
      }
    }

    return total;
  }

  /// Formatted duration for UI, like "3 Hrs 06 Mins"
  /// Utility to format duration (in seconds) into a human-friendly string
  String formatDuration(int totalSeconds) {
    if (totalSeconds <= 0) return '—';

    // If less than a minute, show seconds
    if (totalSeconds < 60) {
      return '$totalSeconds ${totalSeconds == 1 ? "Sec" : "Secs"}';
    }

    final totalMinutes = totalSeconds ~/ 60;
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    if (hours == 0) {
      return '$minutes ${minutes == 1 ? "Min" : "Mins"}';
    }

    return '$hours ${hours == 1 ? "Hr" : "Hrs"} '
        '$minutes ${minutes == 1 ? "Min" : "Mins"}';
  }

  /// Progress between 0.0 and 1.0
  /// For now:
  /// - 1.0 if status == 'completed'
  /// - 0.0 otherwise (placeholder until real tracking)
  double get progress {
    final completedCount = enrollment.completedSubLessons.length;

    final totalSubLessons = course.lessons.fold<int>(
      0,
      (sum, lesson) => sum + lesson.subLessons.length,
    );

    if (totalSubLessons == 0) return 0.0;

    return completedCount / totalSubLessons;
  }
}
