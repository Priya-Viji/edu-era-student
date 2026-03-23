import 'package:eduera_student/features/home/presentation/pages/course_detail_page.dart';
import 'package:eduera_student/features/payment/data/model/course_with_enrollment.dart';
import 'package:eduera_student/features/payment/presentation/pages/certification_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final CourseWithEnrollment course;
  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final isCompleted = course.status.toLowerCase() == 'completed';
    final isOngoing = course.status.toLowerCase() == 'ongoing';
    final progressPercent = (course.progress * 100).toStringAsFixed(0);
final currentUser = FirebaseAuth.instance.currentUser;
    return GestureDetector(
      onTap: () {
        if (isOngoing) {
         Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CourseDetailPage(courseId: course.courseId,isEnrolled: true,),
            ),
          );
        } else if (isCompleted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CertificationPage(studentName: currentUser?.displayName ?? 'Student', courseName: course.title)),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Row(
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  child: Container(
                    width: 120,
                    height: 140,
                    color: Colors.grey[900],
                    child:
                        course.imageUrl != null && course.imageUrl!.isNotEmpty
                        ? Image.network(
                            course.imageUrl!,
                            width: 120,
                            height: 140,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Icon(
                              Icons.image,
                              size: 40,
                              color: Colors.grey[400],
                            ),
                          )
                        : Icon(Icons.image, size: 40, color: Colors.grey[400]),
                  ),
                ),
                // Details
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Category
                        Text(
                          course.category,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFF9800),
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Title
                        Text(
                          course.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        // Rating and duration
                        Row(
                          children: [
                            // const Icon(
                            //   Icons.star,
                            //   color: Color(0xFFFFC107),
                            //   size: 14,
                            // ),
                            const SizedBox(width: 4),
                             Text(
                              course.rating == null
                                  ? "⭐ —"
                                  : "⭐ ${course.rating!.toStringAsFixed(1)}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(width: 8),
                            Text(
                              '|',
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                course.duration,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Progress bar for ongoing courses
                        if (isOngoing) ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: course.progress,
                              backgroundColor: Colors.grey[200],
                              color: const Color(0xFF2196F3),
                              minHeight: 6,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$progressPercent% completed',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],

                        // Certificate button for completed courses
                        if (isCompleted)
                          GestureDetector(
                            onTap: () {
                              // Navigate to certificate
                              // Navigator.push(context, MaterialPageRoute(builder: (_) => CertificatePage()));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00897B).withAlpha(25),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.workspace_premium,
                                    color: Color(0xFF00897B),
                                    size: 16,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'VIEW CERTIFICATE',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF00897B),
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Completed badge
            if (isCompleted)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 20),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
