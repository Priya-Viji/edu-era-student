import 'package:eduera_student/features/payment/data/model/course_with_enrollment.dart';
import 'package:eduera_student/features/payment/presentation/pages/widget/course_card.dart';
import 'package:flutter/material.dart';

class CourseTabView extends StatefulWidget {
  final String status;
  final List<CourseWithEnrollment> allCourses;

  const CourseTabView({
    super.key,
    required this.status,
    required this.allCourses,
  });

  @override
  State<CourseTabView> createState() => _CourseTabViewState();
}

class _CourseTabViewState extends State<CourseTabView> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    var filteredCourses = widget.allCourses
        .where((c) => c.status.toLowerCase() == widget.status.toLowerCase())
        .toList();

    if (searchQuery.isNotEmpty) {
      filteredCourses = filteredCourses
          .where(
            (c) => c.title.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }

    return filteredCourses.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.status == 'completed'
                      ? Icons.workspace_premium_outlined
                      : Icons.school_outlined,
                  size: 80,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                Text(
                  searchQuery.isEmpty
                      ? 'No ${widget.status} courses yet'
                      : 'No courses found',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                if (searchQuery.isEmpty && widget.status == 'ongoing')
                  Text(
                    'Start learning to see your courses here',
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            itemCount: filteredCourses.length,
            itemBuilder: (_, index) =>
                CourseCard(course: filteredCourses[index]),
          );
  }
}
