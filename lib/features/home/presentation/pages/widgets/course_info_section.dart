import 'package:eduera_student/core/constants/course_detail_colors.dart';
import 'package:eduera_student/core/constants/course_detail_sizes.dart';
import 'package:eduera_student/features/home/domain/entities/course_entity.dart';
import 'package:flutter/material.dart';

class CourseInfoSection extends StatelessWidget {
  final CourseEntity course;

  const CourseInfoSection({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(CourseDetailSizes.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// CATEGORY + RATING (same line)
          Row(
            children: [
              Expanded(
                child: Text(
                  course.category,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: CourseDetailColors.accent,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                // decoration: BoxDecoration(
                //   color: Colors.black87,
                //   borderRadius: BorderRadius.circular(20),
                // ),
                child: Row(
                  children: [
                    Text(
                      course.rating == null
                          ? "No reviews" 
                          : "⭐ ${course.rating!.toStringAsFixed(1)}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Text("${course.studentCount} std"),
                  ],
                )

              ),
            ],
          ),

          const SizedBox(height: 8),

          /// TITLE
        Text(
            course.title,
            maxLines: 1, // show only one line
            overflow: TextOverflow.ellipsis, // add "..." if text is long
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: CourseDetailColors.textDark,
              height: 1.3,
            ),
          ),


          const SizedBox(height: 8),

          /// CLASS COUNT + TOTAL HOURS
          Row(
            children: [
              const Icon(Icons.videocam_outlined, size: 18, color: Colors.black),
              const SizedBox(width: 6),
              Text(
                '${_getTotalSubLessons(course)} Class',
                style: const TextStyle(fontSize: 14, color: Colors.black,fontWeight: FontWeight.bold),
              ),
              Divider(),
              const SizedBox(width: 20),
              const Icon(Icons.access_time, size: 18, color: Colors.black),
              const SizedBox(width: 6),
              Text(
                '${_getTotalDurationHours(course)} Hours',
                style: const TextStyle(fontSize: 14, color: Colors.black,fontWeight: FontWeight.bold),
              ),
              Spacer(),
               Text(
                '₹${course.price.toInt()}/-',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),

          //const SizedBox(height: 16),

          /// STUDENTS + PRICE
          // Row(
          //   children: [
          //     // Text(
          //     //   '7+ students enrolled',
          //     //   style: const TextStyle(fontSize: 14, color: Colors.grey),
          //     // ),
          //     // const Spacer(),
          //     Text(
          //       '₹${course.price}',
          //       style: const TextStyle(
          //         fontSize: 24,
          //         fontWeight: FontWeight.bold,
          //         color: CourseDetailColors.textDark,
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  int _getTotalSubLessons(CourseEntity course) {
    return course.lessons.fold(
      0,
      (sum, lesson) => sum + lesson.subLessons.length,
    );
  }

  int _getTotalDurationHours(CourseEntity course) {
    final totalMinutes = course.lessons
        .expand((lesson) => lesson.subLessons)
        .fold(0, (sum, sub) => sum + (sub.duration));

    return (totalMinutes / 60).round();
  }
}
