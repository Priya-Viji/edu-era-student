class Review {
  final String id;

  // Course info
  final String courseId;
  final String courseTitle;
  final String category;
  final String courseImageUrl;

  // Student info
  
  final String studentId;
  final String studentName;
  final String studentImageUrl;
  final String mentorId;

  // Review content
  final double rating;
  final String ratingCategory;
  final String comment;

  // Timestamps
  final DateTime createdAt;
  final DateTime? updatedAt;

  // Like / Dislike
  final int likeCount;
  final int dislikeCount;
  final List<String> likedBy;
  final List<String> dislikedBy;

  // UI helper
  final bool isLikedByCurrentUser;

  Review({
    required this.id,
    required this.courseId,
    required this.courseTitle,
    required this.category,
    required this.courseImageUrl,
    required this.studentId,
    required this.studentName,
    required this.studentImageUrl,
    required this.mentorId,
    required this.rating,
    required this.ratingCategory,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    required this.likeCount,
    required this.dislikeCount,
    required this.likedBy,
    required this.dislikedBy,
    required this.isLikedByCurrentUser,
  });

  /// ---------------------------------------------------------
  /// COPY WITH (needed for optimistic UI + editing)
  /// ---------------------------------------------------------
  Review copyWith({
    String? id,
    String? courseId,
    String? courseTitle,
    String? category,
    String? courseImageUrl,
    String? studentId,
    String? studentName,
    String? studentImageUrl,
    String? mentorId,
    double? rating,
    String? ratingCategory,
    String? comment,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? likeCount,
    int? dislikeCount,
    List<String>? likedBy,
    List<String>? dislikedBy,
    bool? isLikedByCurrentUser,
  }) {
    return Review(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      courseTitle: courseTitle ?? this.courseTitle,
      category: category ?? this.category,
      courseImageUrl: courseImageUrl ?? this.courseImageUrl,
      mentorId: mentorId ?? this.mentorId,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      studentImageUrl: studentImageUrl ?? this.studentImageUrl,
      rating: rating ?? this.rating,
      ratingCategory: ratingCategory ?? this.ratingCategory,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likeCount: likeCount ?? this.likeCount,
      dislikeCount: dislikeCount ?? this.dislikeCount,
      likedBy: likedBy ?? this.likedBy,
      dislikedBy: dislikedBy ?? this.dislikedBy,
      isLikedByCurrentUser: isLikedByCurrentUser ?? this.isLikedByCurrentUser,
    );
  }
}
