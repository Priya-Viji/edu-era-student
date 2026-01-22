import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduera_student/features/home/data/datasources/firebase_course_datasource.dart';
import 'package:eduera_student/features/home/data/models/category_model.dart';
import 'package:eduera_student/features/home/data/models/mentor_model.dart';
import 'package:eduera_student/features/home/domain/entities/course_entity.dart';
import 'package:eduera_student/features/home/domain/entities/paginated_courses.dart';
import 'package:eduera_student/features/home/domain/repositories/course_repository.dart';

class CourseRepositoryImpl implements CourseRepository {
  final FirebaseCourseDataSource dataSource;
  final FirebaseFirestore firestore;

  CourseRepositoryImpl(this.dataSource, this.firestore);

@override
  Future<PaginatedCourses> getCoursesPaginated({
    int limit = 20,
    DocumentSnapshot? lastDoc,
  }) async {
    final (models, newLastDoc) = await dataSource.getCoursesPaginated(
      limit: limit,
      lastDoc: lastDoc,
    );
    final entities = models.map((m) => m.toEntity()).toList();
    return PaginatedCourses(courses: entities, lastDoc: newLastDoc);
  }



  @override
  Future<List<CourseEntity>> getAllCourses() async {
    final models = await dataSource.getAllCoursesWithStats();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<CourseEntity>> getCoursesByCategory(String category) async {
    final models = await dataSource.getCoursesByCategory(category);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<CourseEntity> getCourseById(String courseId) async {
    final model = await dataSource.getCourseById(courseId);
    return model.toEntity();
  }

  @override
  Future<List<CategoryModel>> fetchCategories() async {
    return await dataSource.fetchCategories();
  }

  @override
  Future<List<MentorModel>> fetchMentors() async {
    return await dataSource.fetchMentors();
  }

  @override
  Future<List<CourseEntity>> searchCourses(String query) async {
    final models = await dataSource.searchCourses(query);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<String>> getCategories() async {
    final categories = await dataSource.fetchCategories();
    return categories.map((category) => category.name).toList();
  }

  @override
  Future<List<CourseEntity>> filterCourses({
    List<String>? categories,
    List<String>? levels,
    bool? isFree,
    double? rating,
  }) async {
    final models = await dataSource.filterCourses(
      categories: categories,
      levels: levels,
      isFree: isFree,
      rating: rating,
    );

    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<CourseEntity>> getCoursesByMentor(String mentorId) async {
    final models = await dataSource.getCoursesByMentor(mentorId);
    return models.map((m) => m.toEntity()).toList();
  }
}




