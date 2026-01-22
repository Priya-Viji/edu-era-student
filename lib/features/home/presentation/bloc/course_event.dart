import 'package:cloud_firestore/cloud_firestore.dart';

abstract class CourseEvent {}

class LoadCoursesEvent extends CourseEvent {}

class LoadCoursesByCategoryEvent extends CourseEvent {
  final String category;

  LoadCoursesByCategoryEvent(this.category);
}

class LoadCourseDetailEvent extends CourseEvent {
  final String courseId;

  LoadCourseDetailEvent(this.courseId);
}

class SearchCoursesEvent extends CourseEvent {
  final String query;

  SearchCoursesEvent(this.query);
}

class FilterCoursesEvent extends CourseEvent {
  final List<String>? categories;
  final List<String>? levels;
  final bool? isFree;
  final double? rating;

  FilterCoursesEvent({this.categories, this.levels, this.isFree, this.rating});
}

class LoadMoreCoursesEvent extends CourseEvent {
  final int limit;
  final DocumentSnapshot? lastDoc;
  LoadMoreCoursesEvent({this.limit = 20, this.lastDoc});
}
class LoadCoursesByMentorEvent extends CourseEvent {
  final String mentorId;
  LoadCoursesByMentorEvent(this.mentorId);
}

