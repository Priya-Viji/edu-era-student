import 'package:eduera_student/core/constants/colors.dart';
import 'package:eduera_student/features/home/presentation/bloc/course_bloc.dart';
import 'package:eduera_student/features/home/presentation/bloc/course_event.dart';
import 'package:eduera_student/features/home/presentation/bloc/course_state.dart';
import 'package:eduera_student/features/home/presentation/pages/course_detail_page.dart';
import 'package:eduera_student/features/home/presentation/pages/widgets/course_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MentorCourseListPage extends StatelessWidget {
  final String mentorId;
  final String mentorName;

  const MentorCourseListPage({
    super.key,
    required this.mentorId,
    required this.mentorName,
  });

  @override
  Widget build(BuildContext context) {
    // Dispatch event to load courses by mentorId
    context.read<CourseBloc>().add(LoadCoursesByMentorEvent(mentorId));

    return Scaffold(
      appBar: AppBar(
        title: Text(mentorName,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<CourseBloc, CourseState>(
        builder: (context, state) {
          if (state is CourseLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CourseLoadedMentor) {
            if (state.courses.isEmpty) {
              return const Center(child: Text('No courses found'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.courses.length,
              itemBuilder: (context, index) {
                final course = state.courses[index];

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CourseDetailPage(courseId: course.id),
                      ),
                    );
                  },
                  child: CourseCard(
                    course: course,
                    horizontal: false,
                    isBookmarked: false,
                  ),
                );
              },
            );
          } else if (state is CourseError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
