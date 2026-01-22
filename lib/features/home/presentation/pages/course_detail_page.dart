// course_detail_page.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduera_student/core/constants/course_detail_colors.dart';
import 'package:eduera_student/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:eduera_student/features/bookmark/presentation/bloc/bookmark_event.dart';
import 'package:eduera_student/features/bookmark/presentation/bloc/bookmark_state.dart';
import 'package:eduera_student/features/home/presentation/bloc/mentor_bloc/mentor_bloc.dart';
import 'package:eduera_student/features/home/presentation/pages/widgets/lesson_tab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduera_student/features/home/presentation/bloc/course_bloc.dart';
import 'package:eduera_student/features/home/presentation/bloc/course_state.dart';
import 'package:eduera_student/features/home/presentation/bloc/course_event.dart';
import 'package:eduera_student/features/home/domain/entities/course_entity.dart';

import 'widgets/header_section.dart';
import 'widgets/course_info_section.dart';
import 'widgets/tab_bar_section.dart';
import 'widgets/about_tab.dart';

import 'widgets/enroll_button.dart';

class CourseDetailPage extends StatefulWidget {
  final String courseId;
  final bool isEnrolled;

  const CourseDetailPage({
    super.key,
    required this.courseId,
    this.isEnrolled = false,
  });

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  int _selectedTabIndex = 0;
  bool isEnrolled = false;

  @override
  void initState() {
    super.initState();
    context.read<CourseBloc>().add(LoadCourseDetailEvent(widget.courseId));
    final userId = FirebaseAuth.instance.currentUser!.uid;
    context.read<BookmarkBloc>().add(LoadAllBookmarks(userId: userId));
  
  _checkEnrollment(userId, widget.courseId).then((enrolled) {
      setState(() {
        isEnrolled = enrolled;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      backgroundColor: CourseDetailColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          BlocBuilder<CourseBloc, CourseState>(
            builder: (context, state) {
              if (state is! CourseDetailLoaded) return const SizedBox.shrink();
              final course = state.course;
              return BlocBuilder<BookmarkBloc, BookmarkState>(
                builder: (context, bState) {
                  final isBookmarked = bState is BookmarkStatus
                      ? bState.isBookmarked
                      : false;
                  return IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: Colors.blueAccent,
                    ),
                    onPressed: () {
                      context.read<BookmarkBloc>().add(
                        ToggleBookmarkEvent(
                          userId: userId,
                          courseId: course.id,
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),

      body: BlocBuilder<CourseBloc, CourseState>(
        builder: (context, state) {
          if (state is CourseLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CourseError) {
            return Center(child: Text(state.message));
          }

          if (state is CourseDetailLoaded) {
            final course = state.course;
            // Load bookmark status once course is available
            context.read<BookmarkBloc>().add(
              LoadBookmarkStatus(userId: userId, courseId: course.id),
            );
            context.read<MentorBloc>().add(LoadMentorEvent(course.mentorId));
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderSection(course: course),
                      CourseInfoSection(course: course),
                      TabBarSection(
                        selectedIndex: _selectedTabIndex,
                        onChanged: (index) {
                          setState(() => _selectedTabIndex = index);
                        },
                      ),
                      _buildTabContent(course),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
                // top bar you already had can be extracted later similarly
                if (!widget.isEnrolled) EnrollButton(course: course),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildTabContent(CourseEntity course) {
    switch (_selectedTabIndex) {
      case 0:
        return AboutTab(course: course, isEnrolled: widget.isEnrolled);
      case 1:
        return LessonTab(course: course, isEnrolled: widget.isEnrolled);
      default:
        return const SizedBox.shrink();
    }
  }
}


Future<bool> _checkEnrollment(String userId, String courseId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('enrollments')
      .where('userId', isEqualTo: userId)
      .where('courseId', isEqualTo: courseId)
      .get();

  return snapshot.docs.isNotEmpty;
}
