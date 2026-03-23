import 'package:eduera_student/core/constants/colors.dart';
import 'package:eduera_student/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:eduera_student/features/bookmark/presentation/bloc/bookmark_event.dart';
import 'package:eduera_student/features/home/domain/entities/course_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseCard extends StatelessWidget {
  final CourseEntity course;
  final bool isBookmarked;
  final bool showBookmark;
  final bool horizontal;
  final VoidCallback? onTap;

  const CourseCard({
    super.key,
    required this.course,
    required this.isBookmarked,
    this.showBookmark = true,
    this.horizontal = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: horizontal
              ? _buildHorizontal(userId, context)
              : _buildVertical(userId, context),
        ),
      ),
    );
  }

  ///  Vertical Layout
  Widget _buildVertical(String userId, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Column 1: Image (fixed)
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            course.thumbnailUrl,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),

        // Column 2: Details (flexible)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course.category,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFF9800),
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                course.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '₹${course.price.toInt()}/-',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF448AFF),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '|',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                Text(
                    course.rating == null
                        ? "⭐ —" 
                        : "⭐ ${course.rating!.toStringAsFixed(1)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),


                  const SizedBox(width: 8),
                  const Text(
                    '|',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    course.studentCount == 0
                        ? "New"
                        : "${course.studentCount} std",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Column 3: Bookmark (fixed)
        if (showBookmark)
          SizedBox(
            width: 40,
            child: IconButton(
              icon: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: isBookmarked ? AppColors.primaryDark : Colors.grey,
                size: 25,
              ),
              onPressed: () {
                context.read<BookmarkBloc>().add(
                  ToggleBookmarkEvent(userId: userId, courseId: course.id),
                );
              },
            ),
          ),
      ],
    );
  }


  ///  Horizontal Layout
 Widget _buildHorizontal(String userId, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //  Top Image
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            course.thumbnailUrl,
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 12),

        // 🔹 Split into two columns under the image
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left column: details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.category,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFF9800),
                    ),
                  ),
                  const SizedBox(height: 6),

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
                  const SizedBox(height: 6),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "₹${course.price.toInt()}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Row(
                        children: [
                      Text(
                            course.rating == null
                                ? "⭐ —" // 👈 shown when no reviews
                                : "⭐ ${course.rating!.toStringAsFixed(1)}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(width: 12),
                          const Text(
                            '|',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            course.studentCount == 0 ? "New" : "${course.studentCount} std",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Right column: bookmark icon
            if (showBookmark)
              Column(
                children: [
                  IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: isBookmarked ? AppColors.primaryDark : Colors.grey,
                      size: 25,

                    ),
                    onPressed: () {
                      context.read<BookmarkBloc>().add(
                        ToggleBookmarkEvent(
                          userId: userId,
                          courseId: course.id,
                        ),
                      );
                    },
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }

}