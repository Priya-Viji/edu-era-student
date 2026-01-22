import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduera_student/features/home/domain/entities/course_entity.dart';
import 'package:eduera_student/features/home/presentation/bloc/mentor_bloc/mentor_bloc.dart';
import 'package:eduera_student/features/home/presentation/pages/widgets/mentor_card.dart';
import 'package:eduera_student/features/home/presentation/pages/widgets/what_you_get_section.dart';
import 'package:eduera_student/features/home/presentation/pages/widgets/review_section.dart';

class AboutTab extends StatefulWidget {
  final CourseEntity course;
  final bool isEnrolled;

  const AboutTab({super.key, required this.course, required this.isEnrolled});

  @override
  State<AboutTab> createState() => _AboutTabState();
}

class _AboutTabState extends State<AboutTab> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final description = widget.course.description;
    final previewText = description.length > 150
        ? '${description.substring(0, 150)}...'
        : description;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Course Description
          Text(
            _isExpanded ? description : previewText,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.grey[700],
            ),
          ),

          const SizedBox(height: 16),

          if (description.length > 250)
            GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Text(
                _isExpanded ? 'Show Less -' : 'Show More +',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2196F3),
                ),
              ),
            ),

          const SizedBox(height: 24),

          ///  Mentor Section
          BlocBuilder<MentorBloc, MentorState>(
            builder: (context, state) {
              if (state is MentorSuccess) {
                return MentorCard(mentor: state.mentor);
              }
              if (state is MentorLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return const SizedBox.shrink();
            },
          ),

          const SizedBox(height: 24),

          /// ⭐ What You'll Get Section
          WhatYouGetSection(course: widget.course),

          const SizedBox(height: 24),

          /// ⭐ Review Section (2 reviews + See All)
          ReviewSection(
            courseId: widget.course.id,
            isEnrolled: widget.isEnrolled,
            course: widget.course,
          ),
        ],
      ),
    );
  }
}
