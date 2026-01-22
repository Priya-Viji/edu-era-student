import 'package:eduera_student/features/home/domain/repositories/course_repository.dart';
import 'package:eduera_student/features/home/domain/usecases/get_all_courses.dart';
import 'package:eduera_student/features/home/presentation/bloc/course_event.dart';
import 'package:eduera_student/features/home/presentation/bloc/course_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final GetAllCourses getAllCourses;
  final GetCourseById getCourseById;
  final CourseRepository repository;

  CourseBloc({
    required this.getAllCourses,
    required this.getCourseById,
    required this.repository,
  }) : super(CourseInitial()) {
    on<LoadCoursesEvent>(_onLoadCourses);
    on<LoadCoursesByCategoryEvent>(_onLoadCoursesByCategory);
    on<LoadCourseDetailEvent>(_onLoadCourseDetail);
    on<FilterCoursesEvent>(_onFilterCourses);
    on<SearchCoursesEvent>(_onSearchCourses);
    on<LoadMoreCoursesEvent>(_onLoadMoreCourses);
    on<LoadCoursesByMentorEvent>(_onLoadCoursesByMentor);
  }

  // Load initial courses
  Future<void> _onLoadCourses(
    LoadCoursesEvent event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseLoading());
    try {
      final snapshot = await repository.getCoursesPaginated(limit: 20);
      final categories = await repository.getCategories();

      emit(
        CourseLoaded(
          courses: snapshot.courses,
          categories: categories,
          hasReachedEnd: snapshot.courses.isEmpty,
          lastDoc: snapshot.lastDoc,
        ),
      );
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }

  // Load more courses (pagination)
  Future<void> _onLoadMoreCourses(
    LoadMoreCoursesEvent event,
    Emitter<CourseState> emit,
  ) async {
    if (state is CourseLoaded) {
      final currentState = state as CourseLoaded;
      try {
        final snapshot = await repository.getCoursesPaginated(
          limit: event.limit,
          lastDoc: currentState.lastDoc,
        );

        emit(
          CourseLoaded(
            courses: [...currentState.courses, ...snapshot.courses],
            categories: currentState.categories,
            hasReachedEnd: snapshot.courses.isEmpty,
            lastDoc: snapshot.lastDoc,
          ),
        );
      } catch (e) {
        emit(CourseError(e.toString()));
      }
    }
  }

  // Load courses by category
  Future<void> _onLoadCoursesByCategory(
    LoadCoursesByCategoryEvent event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseLoading());
    try {
      final courses = await repository.getCoursesByCategory(event.category);
      final categoryModels = await repository.fetchCategories();
      final categories = categoryModels.map((c) => c.name).toList();

      emit(
        CourseLoaded(
          courses: courses,
          categories: categories,
          hasReachedEnd: true, // category fetch is finite
        ),
      );
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }

  // Load course detail
  Future<void> _onLoadCourseDetail(
    LoadCourseDetailEvent event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseLoading());
    try {
      final course = await getCourseById(event.courseId);
      emit(CourseDetailLoaded(course));
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }

  // Filter courses
  Future<void> _onFilterCourses(
    FilterCoursesEvent event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseLoading());
    try {
      final courses = await repository.filterCourses(
        categories: event.categories,
        levels: event.levels,
        isFree: event.isFree,
        rating: event.rating,
      );
      final categories = await repository.getCategories();
      // print(
      //   'Filters: ${event.categories}, ${event.levels}, ${event.isFree}, ${event.rating}',
      // );
      // print('Filtered courses count: ${courses.length}');

      emit(
        CourseLoaded(
          courses: courses,
          categories: categories,
          hasReachedEnd: true,
        ),
      );
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }

  // Search courses
  Future<void> _onSearchCourses(
    SearchCoursesEvent event,
    Emitter<CourseState> emit,
  ) async {
    try {
      final trimmed = event.query.trim();

      // If search is empty → load all courses again (paginated)
      if (trimmed.isEmpty) {
        emit(CourseLoading());

        final snapshot = await repository.getCoursesPaginated(limit: 20);
        final categories = await repository.getCategories();

        emit(
          CourseLoaded(
            courses: snapshot.courses,
            categories: categories,
            hasReachedEnd: snapshot.courses.isEmpty,
            lastDoc: snapshot.lastDoc,
          ),
        );
        return;
      }

      // Normal search
      emit(CourseLoading());

      final courses = await repository.searchCourses(trimmed);
      final categories = await repository.getCategories();

      emit(
        CourseLoaded(
          courses: courses,
          categories: categories,
          hasReachedEnd: true, // search results are finite
          lastDoc: null, // no pagination for search
        ),
      );
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }

  Future<void> _onLoadCoursesByMentor(
    LoadCoursesByMentorEvent event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseLoading());
    try {
      final courses = await repository.getCoursesByMentor(event.mentorId);
      emit(CourseLoadedMentor(courses));
    } catch (e) {
      emit(CourseError('Failed to load mentor courses: $e'));
    }
  }
}
