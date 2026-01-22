import 'package:cloud_firestore/cloud_firestore.dart';
import 'course_entity.dart';

class PaginatedCourses {
  final List<CourseEntity> courses;
  final DocumentSnapshot? lastDoc;

  PaginatedCourses({required this.courses, this.lastDoc});
}
