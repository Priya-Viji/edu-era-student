import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduera_student/features/home/domain/entities/course_entity.dart';

abstract class CourseState {}

class CourseInitial extends CourseState {}

class CourseLoading extends CourseState {}

class CourseLoaded extends CourseState {
  final List<CourseEntity> courses;
  final List<String> categories;
  final bool hasReachedEnd; // 🔹 new
  final DocumentSnapshot? lastDoc; // 🔹 new (for Firestore pagination)

  CourseLoaded({
    required this.courses,
    required this.categories,
    this.hasReachedEnd = false,
    this.lastDoc,
  });
}

class CourseLoadedMentor extends CourseState {
  final List<CourseEntity> courses;
  CourseLoadedMentor(this.courses);
}
class CourseDetailLoaded extends CourseState {
  final CourseEntity course;

  CourseDetailLoaded(this.course);
}

class CourseError extends CourseState {
  final String message;

  CourseError(this.message);
}

