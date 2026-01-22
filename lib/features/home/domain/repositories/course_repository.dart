import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduera_student/features/home/data/models/category_model.dart';
import 'package:eduera_student/features/home/data/models/mentor_model.dart';
import 'package:eduera_student/features/home/domain/entities/course_entity.dart';
import 'package:eduera_student/features/home/domain/entities/paginated_courses.dart';

abstract class CourseRepository {
  Future<List<CourseEntity>> getAllCourses();
  Future<List<CourseEntity>> getCoursesByCategory(String category);
  Future<CourseEntity> getCourseById(String courseId);
  Future<List<String>> getCategories();
  Future<PaginatedCourses> getCoursesPaginated({
    int limit,
    DocumentSnapshot? lastDoc,
  });
  Future<List<CourseEntity>> searchCourses(String query);
  // Optional but handy for your Home page
  Future<List<CategoryModel>> fetchCategories();
  Future<List<MentorModel>> fetchMentors();

  // New method for filtering courses
  Future<List<CourseEntity>> filterCourses({
    List<String>? categories,
    List<String>? levels,
    bool? isFree,
    double? rating,
  }) async {
    // Assuming you have a list of all courses
    List<CourseEntity> filtered = await getAllCourses();

    if (categories != null && categories.isNotEmpty) {
      filtered = filtered
          .where((c) => categories.contains(c.category))
          .toList();
    }

    if (levels != null && levels.isNotEmpty) {
      filtered = filtered.where((c) => levels.contains(c.level)).toList();
    }

    if (isFree != null) {
      filtered = filtered.where((c) => c.isFree == isFree).toList();
    }

    if (rating != null) {
      filtered = filtered.where((c) => (c.rating ?? 0) >= rating).toList();
    }


    return filtered;
  }

  Future<List<CourseEntity>> getCoursesByMentor(String mentorId);
}
