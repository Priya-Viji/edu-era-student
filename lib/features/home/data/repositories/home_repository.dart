import 'package:eduera_student/features/home/data/datasources/firebase_course_datasource.dart';
import 'package:eduera_student/features/home/data/models/category_model.dart';
import 'package:eduera_student/features/home/data/models/course_model.dart';
import 'package:eduera_student/features/home/data/models/mentor_model.dart';

class HomeRepository {
  final FirebaseCourseDataSource dataSource;

  HomeRepository(this.dataSource);

  Future<List<CourseModel>> getAllCourses() => dataSource.getAllCoursesWithStats();
  Future<List<CourseModel>> getCoursesByCategory(String category) =>
      dataSource.getCoursesByCategory(category);
  Future<List<CategoryModel>> fetchCategories() => dataSource.fetchCategories();

  // Mentors — ALL
  Future<List<MentorModel>> fetchMentors() => dataSource.fetchMentors();

  // Mentor — BY ID (IMPLEMENTED HERE)
  Future<MentorModel> fetchMentorById(String mentorId) =>
      dataSource.fetchMentorById(mentorId);

  // If using nested schema:
  Future<bool> isUserEnrolledInCourseNested({
    required String userId,
    required String courseId,
  }) => dataSource.isUserEnrolledInCourse(
    userId: userId,
    courseId: courseId,
  );
}
