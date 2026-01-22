import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/review.dart';

class ReviewModel {
  /// -----------------------------
  /// FROM FIRESTORE → ENTITY
  /// -----------------------------
  static Review fromDoc(DocumentSnapshot doc, String currentUserId) {
    final data = doc.data() as Map<String, dynamic>;

    final likedByList = List<String>.from(data['likedBy'] ?? []);
    final dislikedByList = List<String>.from(data['dislikedBy'] ?? []);

    return Review(
      id: doc.id,
      courseId: data['courseId'] ?? '',
      courseTitle: data['courseTitle'] ?? '',
      category: data['category'] ?? '',
      courseImageUrl: data['courseImageUrl'] ?? '',
      studentId: data['studentId'] ?? '',
      studentName: data['studentName'] ?? '',
      studentImageUrl: data['studentImageUrl'] ?? '',
      mentorId: data['mentorId'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      ratingCategory: data['ratingCategory'] ?? '',
      comment: data['comment'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
      likeCount: data['likeCount'] ?? likedByList.length,
      dislikeCount: data['dislikeCount'] ?? dislikedByList.length,
      likedBy: likedByList,
      dislikedBy: dislikedByList,
      isLikedByCurrentUser: likedByList.contains(currentUserId),
    );
  }

  /// -----------------------------
  /// ENTITY → FIRESTORE MAP
  /// -----------------------------
  static Map<String, dynamic> toMap(Review review) {
    return {
      'courseId': review.courseId,
      'courseTitle': review.courseTitle,
      'category': review.category,
      'courseImageUrl': review.courseImageUrl,
      'studentId': review.studentId,
      'studentName': review.studentName,
      'studentImageUrl': review.studentImageUrl,
      'mentorId':review.mentorId,
      'rating': review.rating,
      'ratingCategory': review.ratingCategory,
      'comment': review.comment,
      'createdAt': review.createdAt,
      'updatedAt': review.updatedAt,
      'likeCount': review.likeCount,
      'dislikeCount': review.dislikeCount,
      'likedBy': review.likedBy,
      'dislikedBy': review.dislikedBy,
    };
  }
}
