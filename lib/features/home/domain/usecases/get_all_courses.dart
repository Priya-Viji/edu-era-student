import 'package:eduera_student/features/home/domain/entities/course_entity.dart';
import 'package:eduera_student/features/home/domain/repositories/course_repository.dart';

class GetAllCourses {
  final CourseRepository repository;

  GetAllCourses(this.repository);

  Future<List<CourseEntity>> call() async {
    return await repository.getAllCourses();
  }
}

// 4. Get Course By ID Use Case (domain/usecases/get_course_by_id.dart)
class GetCourseById {
  final CourseRepository repository;

  GetCourseById(this.repository);

  Future<CourseEntity> call(String courseId) async {
    return await repository.getCourseById(courseId);
  }
}



