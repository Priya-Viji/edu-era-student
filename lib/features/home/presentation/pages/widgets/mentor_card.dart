import 'package:eduera_student/core/constants/course_detail_colors.dart';
import 'package:eduera_student/core/constants/course_detail_sizes.dart';
import 'package:eduera_student/core/constants/course_detail_text.dart';
import 'package:eduera_student/features/home/data/models/mentor_model.dart';
import 'package:flutter/material.dart';

class MentorCard extends StatelessWidget {
  final MentorModel mentor;

  const MentorCard({super.key, required this.mentor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Instructor label
        const Text(
          CourseDetailText.instructor,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        /// Mentor card container
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(CourseDetailSizes.cardRadius),
            border: Border.all(color: CourseDetailColors.cardBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              /// Profile image
              CircleAvatar(
                radius: 28,
                backgroundImage:
                    (mentor.photoUrl != null && mentor.photoUrl!.isNotEmpty)
                    ? NetworkImage(mentor.photoUrl!)
                    : null,
                child: (mentor.photoUrl == null || mentor.photoUrl!.isEmpty)
                    ? const Icon(Icons.person, color: Colors.white, size: 28)
                    : null,
              ),

              const SizedBox(width: 16),

              /// Name + Expertise
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mentor.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mentor.expertise.join(', '),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              /// Chat icon
              // IconButton(
              //   icon: const Icon(
              //     Icons.chat_bubble_outline,
              //     size: 20,
              //     color: Colors.grey,
              //   ),
              //   onPressed: () {   },
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
