import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduera_student/features/home/domain/entities/course_entity.dart';
import 'package:eduera_student/features/home/presentation/pages/widgets/animated_like_button.dart';
import 'package:eduera_student/features/reviews/domain/entities/review.dart';
import 'package:eduera_student/features/reviews/presentation/pages/edit_review_page.dart';
import 'package:eduera_student/features/reviews/presentation/pages/reviews_list_page.dart';
import 'package:eduera_student/features/reviews/presentation/pages/write_review_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReviewSection extends StatelessWidget {
  final String courseId;
  final bool isEnrolled;
  final CourseEntity course;

  const ReviewSection({
    super.key,
    required this.courseId,
    required this.isEnrolled,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Reviews',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReviewsListPage(courseId: courseId, courseTitle: course.title, category: course.category, courseImageUrl: course.thumbnailUrl, currentUserId: currentUserId, currentUserName: '', currentUserImageUrl: '', mentorId: course.mentorId),
                  ),
                );
              },
              child: const Text(
                "See All",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        /// Reviews Stream
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('reviews')
              .where('courseId', isEqualTo: courseId)
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final docs = snapshot.data?.docs ?? [];
            if (docs.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "No reviews yet. Be the first to share your experience!",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              );
            }

            final limitedDocs = docs.take(2).toList();

            return Column(
              children: [
                ...limitedDocs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  data['id'] = doc.id; // attach doc.id
                  return _buildReviewCard(context, data);
                }),
                const SizedBox(height: 12),
                // if (docs.length > 2)
                //   Row(
                //     children: [
                //       TextButton(
                //         onPressed: () {},
                //         child: const Text(
                //           "See All",
                //           style: TextStyle(
                //             color: Colors.blueAccent,
                //             fontWeight: FontWeight.w600,
                //             fontSize: 15,
                //           ),
                //         ),
                //       ),
                //       const SizedBox(width: 4),
                //       Icon(
                //         Icons.arrow_forward,
                //         size: 16,
                //         color: Colors.blueAccent[700],
                //       ),
                //     ],
                //   ),
              ],
            );
          },
        ),

        const SizedBox(height: 24),

        /// Current User Review Stream
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('reviews')
              .where('courseId', isEqualTo: courseId)
              .where('studentId', isEqualTo: currentUserId)
              .snapshots(),
          builder: (context, snapshot) {
            final hasWrittenReview = (snapshot.data?.docs ?? []).isNotEmpty;

            if (isEnrolled && !hasWrittenReview) {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WriteReviewPage(
                          courseId: courseId,
                          courseTitle: course.title,
                          category: course.category,
                          courseImageUrl: course.thumbnailUrl,
                          currentUserId: currentUserId,
                          currentUserName:
                              FirebaseAuth.instance.currentUser!.displayName ??
                              "User",
                          currentUserImageUrl:
                              FirebaseAuth.instance.currentUser!.photoURL ?? "",
                              mentorId: course.mentorId,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.rate_review),
                  label: const Text("Write a Review"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  /// Review Card
  Widget _buildReviewCard(BuildContext context, Map<String, dynamic> data) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final isOwner = data['studentId'] == currentUserId;
    final isLikedByCurrentUser =
        (data['likedBy'] as List?)?.contains(currentUserId) ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Avatar
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.blue.shade100,
            backgroundImage:
                (data['studentImageUrl'] != null &&
                    data['studentImageUrl'].toString().isNotEmpty)
                ? NetworkImage(data['studentImageUrl'])
                : null,
            child:
                (data['studentImageUrl'] == null ||
                    data['studentImageUrl'].toString().isEmpty)
                ? const Icon(Icons.person, size: 28, color: Colors.white)
                : null,
          ),

          const SizedBox(width: 14),

          /// Right side content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Name + Rating Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data['studentName'] ?? 'Anonymous',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent, width: 2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 5),
                          Text(
                            ((data['rating'] ?? 0) as num).toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                /// Review Text
                Text(
                  data['comment'] ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 12),

                /// Likes + Time + Owner Actions
                Row(
                  children: [
                    AnimatedLikeButton(
                      isLiked: isLikedByCurrentUser,
                      likeCount: data['likeCount'] ?? 0,
                      onTap: () async {
                        final reviewDoc = FirebaseFirestore.instance
                            .collection('reviews')
                            .doc(data['id']);

                        if (isLikedByCurrentUser) {
                          await reviewDoc.update({
                            'likedBy': FieldValue.arrayRemove([currentUserId]),
                            'likeCount': (data['likeCount'] ?? 0) - 1,
                          });
                        } else {
                          await reviewDoc.update({
                            'likedBy': FieldValue.arrayUnion([currentUserId]),
                            'likeCount': (data['likeCount'] ?? 0) + 1,
                          });
                        }
                      },
                    ),
                    const Spacer(),
                    Text(
                      _formatTimeAgo(data['createdAt']),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isOwner) ...[
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blueAccent,
                          size: 20,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditReviewPage(
                                review: Review(
                                  id: data['id'],
                                  courseId: data['courseId'],
                                  courseTitle: data['courseTitle'],
                                  category: data['category'],
                                  courseImageUrl: data['courseImageUrl'],
                                  studentId: data['studentId'],
                                  studentName: data['studentName'],
                                  studentImageUrl: data['studentImageUrl'],
                                  mentorId: data['mentorId'],
                                  comment: data['comment'],
                                  rating: (data['rating'] ?? 0).toDouble(),
                                  ratingCategory: data['ratingCategory'],
                                  createdAt: (data['createdAt'] as Timestamp)
                                      .toDate(),
                                  updatedAt: data['updatedAt'] != null
                                      ? (data['updatedAt'] as Timestamp)
                                            .toDate()
                                      : null,
                                  likeCount: data['likeCount'] ?? 0,
                                  dislikeCount: data['dislikeCount'] ?? 0,
                                  likedBy: List<String>.from(
                                    data['likedBy'] ?? [],
                                  ),
                                  dislikedBy: List<String>.from(
                                    data['dislikedBy'] ?? [],
                                  ),
                                  isLikedByCurrentUser:
                                      (data['likedBy'] as List?)?.contains(
                                        currentUserId,
                                      ) ??
                                      false,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 20,
                        ),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Delete Review"),
                              content: const Text(
                                "Are you sure you want to delete this review?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await FirebaseFirestore.instance
                                .collection('reviews')
                                .doc(data['id'])
                                .delete();
                          }
                        },
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Time Ago Formatter
  String _formatTimeAgo(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final diff = DateTime.now().difference(timestamp.toDate());

    if (diff.inDays >= 7) return '${(diff.inDays / 7).floor()} Weeks Ago';
    if (diff.inDays > 0) return '${diff.inDays} Days Ago';
    if (diff.inHours > 0) return '${diff.inHours} Hours Ago';
    return 'Just now';
  }
}
