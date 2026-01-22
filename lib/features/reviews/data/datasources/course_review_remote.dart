// features/reviews/data/datasources/course_review_remote_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class CourseReviewRemoteDataSource {
  final FirebaseFirestore db;
  CourseReviewRemoteDataSource(this.db);

  Future<void> addReview({
    required String courseId,
    required String studentId,
    required double rating,
    required String reviewText,
  }) async {
    final ref = db
        .collection('courses')
        .doc(courseId)
        .collection('reviews')
        .doc();
    await ref.set({
      'studentId': studentId,
      'rating': rating,
      'reviewText': reviewText,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> reviewsStream(String courseId) {
    return db
        .collection('courses')
        .doc(courseId)
        .collection('reviews')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> recomputeCourseAggregate(String courseId) async {
    final reviewsSnap = await db
        .collection('courses')
        .doc(courseId)
        .collection('reviews')
        .get();

    double total = 0;
    for (final doc in reviewsSnap.docs) {
      final data = doc.data();
      total += (data['rating'] ?? 0).toDouble();
    }
    final count = reviewsSnap.size;
    final avg = count == 0 ? 0.0 : total / count;

    await db.collection('courses').doc(courseId).update({
      'averageRating': avg,
      'reviewCount': count,
    });
  }
}
