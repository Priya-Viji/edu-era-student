import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduera_student/features/home/data/models/category_model.dart';
import 'package:eduera_student/features/home/data/models/course_model.dart';
import 'package:eduera_student/features/home/data/models/mentor_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseCourseDataSource {
  final FirebaseFirestore firestore;

  FirebaseCourseDataSource(this.firestore);

  // Future<(List<CourseModel>, DocumentSnapshot?)> getCoursesPaginated({
  //   int limit = 20,
  //   DocumentSnapshot? lastDoc,
  // }) async {
  //   Query query = firestore
  //       .collection('courses')
  //       .orderBy('createdAt')
  //       .limit(limit);
  //   if (lastDoc != null) {
  //     query = query.startAfterDocument(lastDoc);
  //   }
  //   final snapshot = await query.get();
  //   final courses = snapshot.docs
  //       .map((doc) => CourseModel.fromFirestore(doc))
  //       .toList();
  //   final newLastDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
  //   return (courses, newLastDoc);
  // }

  Future<(List<CourseModel>, DocumentSnapshot?)> getCoursesPaginated({
    int limit = 20,
    DocumentSnapshot? lastDoc,
  }) async {
    Query query = firestore
        .collection('courses')
        .orderBy('createdAt')
        .limit(limit);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    final snapshot = await query.get();

    // Base courses
    final courses = await Future.wait(
      snapshot.docs.map((doc) async {
        final course = CourseModel.fromFirestore(doc);

        //  Get rating
        final ratingSnap = await firestore
            .collection('reviews') // ✅ your collection name
            .where('courseId', isEqualTo: course.id)
            .get();

        final avgRating = ratingSnap.docs.isNotEmpty
            ? ratingSnap.docs
                      .map((d) => (d['rating'] ?? 0) as num) // ✅ use 'rating'
                      .reduce((a, b) => a + b) /
                  ratingSnap.docs.length
            : null;

        // 🔹 Get enrollment count
        final enrollmentSnap = await firestore
            .collection('enrollments')
            .where('courseId', isEqualTo: course.id)
            .get();
        final studentCount = enrollmentSnap.docs.length;

        // 🔹 Get bookmark (for current user)
        final userId = FirebaseAuth.instance.currentUser?.uid;
        bool isBookmarked = false;
        if (userId != null) {
          final bookmarkSnap = await firestore
              .collection('bookmarks')
              .where('userId', isEqualTo: userId)
              .where('courseId', isEqualTo: course.id)
              .get();
          isBookmarked = bookmarkSnap.docs.isNotEmpty;
        }

        // 🔹 Merge into course model
        return course.copyWith(
          rating: avgRating,
          studentCount: studentCount,
          isBookmarked: isBookmarked,
        );
      }).toList(),
    );

    final newLastDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
    return (courses, newLastDoc);
  }

  // Future<List<CourseModel>> getAllCourses() async {
  //   try {
  //     final snapshot = await firestore.collection('courses').get();
  //     return snapshot.docs
  //         .map((doc) => CourseModel.fromFirestore(doc))
  //         .toList();
  //   } catch (e) {
  //     throw Exception('Failed to fetch courses: $e');
  //   }
  // }

  Future<List<CourseModel>> getCoursesByCategory(String category) async {
    try {
      final snapshot = await firestore
          .collection('courses')
          .where('category', isEqualTo: category)
          .where('status', isEqualTo: 'published')
          .get();

      return snapshot.docs
          .map((doc) => CourseModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch courses by category: $e');
    }
  }

  Future<CourseModel> getCourseById(String courseId) async {
    try {
      // 🔹 Get the course document first
      final doc = await firestore.collection('courses').doc(courseId).get();
      if (!doc.exists) {
        throw Exception('Course not found');
      }

      final course = CourseModel.fromFirestore(doc);

      // 🔹 Get rating for this course
      final ratingSnap = await firestore
          .collection('reviews')
          .where('courseId', isEqualTo: course.id)
          .get();

      final avgRating = ratingSnap.docs.isNotEmpty
          ? ratingSnap.docs
                    .map((d) => (d['rating'] ?? 0) as num)
                    .reduce((a, b) => a + b) /
                ratingSnap.docs.length
          : null; // null means no reviews yet

      // 🔹 Merge rating into course model
      return course.copyWith(rating: avgRating);
    } catch (e) {
      throw Exception('Failed to fetch course: $e');
    }
  }


  // Future<List<String>> getCategories() async {
  //   try {
  //     final snapshot = await firestore.collection('categories').get();
  //     return snapshot.docs.map((doc) => doc['label'] as String).toList();
  //   } catch (e) {
  //     throw Exception('Failed to fetch categories: $e');
  //   }
  // }

  Future<List<CourseModel>> searchCourses(String query) async {
    final q = query.toLowerCase().trim();

    final snapshot = await firestore.collection('courses').get();

    final filtered = snapshot.docs
        .map((doc) => CourseModel.fromFirestore(doc))
        .where((course) => course.title.toLowerCase().contains(q))
        .toList();

    // 🔹 Enrich with rating, student count, bookmark
    final enriched = await Future.wait(
      filtered.map((course) async {
        // Rating
        final ratingSnap = await firestore
            .collection('reviews')
            .where('courseId', isEqualTo: course.id)
            .get();
        final avgRating = ratingSnap.docs.isNotEmpty
            ? ratingSnap.docs
                      .map((d) => (d['rating'] ?? 0) as num)
                      .reduce((a, b) => a + b) /
                  ratingSnap.docs.length
            : null;

        // Enrollment count
        final enrollmentSnap = await firestore
            .collection('enrollments')
            .where('courseId', isEqualTo: course.id)
            .get();
        final studentCount = enrollmentSnap.docs.length;

        // Bookmark
        final userId = FirebaseAuth.instance.currentUser?.uid;
        bool isBookmarked = false;
        if (userId != null) {
          final bookmarkSnap = await firestore
              .collection('bookmarks')
              .where('userId', isEqualTo: userId)
              .where('courseId', isEqualTo: course.id)
              .get();
          isBookmarked = bookmarkSnap.docs.isNotEmpty;
        }

        return course.copyWith(
          rating: avgRating,
          studentCount: studentCount,
          isBookmarked: isBookmarked,
        );
      }),
    );

    return enriched;
  }

  Future<List<CategoryModel>> fetchCategories() async {
    final snapshot = await firestore.collection('categories').get();
    return snapshot.docs
        .map((doc) => CategoryModel.fromFirestore(doc))
        .toList();
  }

  // Mentor — BY ID
  Future<MentorModel> fetchMentorById(String mentorId) async {
    final doc = await firestore
        .collection('mentor_profiles')
        .doc(mentorId)
        .get();
    if (!doc.exists) {
      throw Exception('Mentor not found');
    }
    return MentorModel.fromFirestore(doc);
  }

  Future<List<MentorModel>> fetchMentors() async {
    final snapshot = await firestore.collection('mentor_profiles').get();
    return snapshot.docs
        .map((doc) => MentorModel.fromFirestore(doc))
        .toList(); //  ensures List<MentorModel>
  }

  Future<bool> isUserEnrolledInCourse({
    required String userId,
    required String courseId,
  }) async {
    final enrollmentId = "${userId}_$courseId";

    final doc = await firestore
        .collection('enrollments')
        .doc(enrollmentId)
        .get();

    return doc.exists;
  }

  Future<List<CourseModel>> filterCourses({
    List<String>? categories,
    List<String>? levels,
    bool? isFree,
    double? rating,
  }) async {
    try {
      Query query = firestore
          .collection('courses')
          .where('status', isEqualTo: 'Published'); // match case

      // 🔹 Category filter
      if (categories != null && categories.isNotEmpty) {
        query = query.where('category', whereIn: categories.take(10).toList());
      }

      // 🔹 Level filter
      if (levels != null && levels.isNotEmpty) {
        query = query.where('level', whereIn: levels.take(10).toList());
      }

      // 🔹 Price / Free filter
      if (isFree != null) {
        query = query.where('isFree', isEqualTo: isFree);
      }

      final snapshot = await query.get();

      // Convert to models
      var courses = snapshot.docs
          .map((doc) => CourseModel.fromFirestore(doc))
          .toList();

     // print('All Fields : $isFree $categories $levels $rating');
      // 🔹 Rating filter based on reviews collection
      if (rating != null) {
        List<CourseModel> filtered = [];
        for (var course in courses) {
          final reviewsSnap = await firestore
              .collection('reviews')
              .where('courseId', isEqualTo: course.id)
              .get();

          final ratings = reviewsSnap.docs
              .map((doc) => (doc['rating'] as num?)?.toDouble())
              .where((r) => r != null && r > 0)
              .cast<double>()
              .toList();

          if (ratings.isEmpty) continue;

          final avg = ratings.reduce((a, b) => a + b) / ratings.length;

          if (avg >= rating) {
            filtered.add(course.copyWith(rating: avg));
          }
        }
        courses = filtered;
      }

      return courses;
    } catch (e) {
      throw Exception('Failed to filter courses: $e');
    }
  }

  Future<double> getCourseAverageRating(String courseId) async {
    final reviewSnap = await firestore
        .collection('reviews')
        .where('courseId', isEqualTo: courseId)
        .get();
    double averageRating = 0;
    //print('Rating: $reviewSnap');

    if (reviewSnap.docs.isNotEmpty) {
      double total = 0;
      int count = 0;

      for (var doc in reviewSnap.docs) {
        final rating = (doc['rating'] as num?)?.toDouble();
        // print('Rating: $rating');
        if (rating != null && rating > 0) {
          total += rating;
          count++;
        }
      }

      if (count > 0) {
        averageRating = total / count;
      }
    }
    return averageRating;
  }

  Future<List<CourseModel>> getCoursesByMentor(String mentorId) async {
    final snapshot = await firestore
        .collection('courses')
        .where('mentorId', isEqualTo: mentorId)
        .where('status', isEqualTo: 'Published')
        .get();

    return snapshot.docs.map((doc) => CourseModel.fromFirestore(doc)).toList();
  }

  Future<List<CourseModel>> getAllCoursesWithStats() async {
    final snapshot = await firestore.collection('courses').get();
    List<CourseModel> courses = [];

    for (var doc in snapshot.docs) {
      var course = CourseModel.fromFirestore(doc);

      // calculate rating
      final avgRating = await getCourseAverageRating(course.id);

      // calculate student count
      final studentCount = await getCourseEnrollmentCount(course.id);

      courses.add(
        course.copyWith(rating: avgRating, studentCount: studentCount),
      );
    }

    return courses;
  }

  Future<int> getCourseEnrollmentCount(String courseId) async {
    final snapshot = await firestore
        .collection('enrollments')
        .where('courseId', isEqualTo: courseId)
        .get();
    return snapshot.docs.length;
  }
}
