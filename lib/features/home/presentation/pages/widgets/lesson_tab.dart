import 'package:eduera_student/features/home/presentation/pages/youtube_player_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:eduera_student/injection_container.dart';
import 'package:eduera_student/features/payment/presentation/bloc/course_progress_bloc/lesson_progress_bloc.dart';
import 'package:eduera_student/features/home/domain/entities/course_entity.dart';


class LessonTab extends StatefulWidget {
  final CourseEntity course;
  final bool isEnrolled;

  const LessonTab({super.key, required this.course, required this.isEnrolled});

  @override
  State<LessonTab> createState() => _LessonTabState();
}

class _LessonTabState extends State<LessonTab> {
  late bool enrolled;
  late String studentId;
  late List<bool> expandedSections;

  @override
  void initState() {
    super.initState();
    enrolled = widget.isEnrolled;
    studentId = FirebaseAuth.instance.currentUser!.uid;

    expandedSections = List.generate(
      widget.course.lessons.length,
      (_) => false,
    );
  }

  int _countTotalSubLessons() {
    int count = 0;
    for (final lesson in widget.course.lessons) {
      count += lesson.subLessons.length;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final lessons = widget.course.lessons;
    final theme = Theme.of(context);

    if (!enrolled) {
      return _buildLockedPreviewHeader(theme);
    }

    return BlocProvider(
      create: (_) => sl<LessonProgressBloc>()
        ..add(
          LoadLessonProgressEvent(
            studentId: studentId,
            courseId: widget.course.id,
            totalSubLessons: _countTotalSubLessons(),
          ),
        ),
      child: BlocBuilder<LessonProgressBloc, LessonProgressState>(
        builder: (context, state) {
          final completed = state is LessonProgressLoaded
              ? state.completedSubLessons
              : <String>[];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUnlockedHeader(theme),
              const SizedBox(height: 20),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: lessons.length,
                itemBuilder: (context, lessonIndex) {
                  final lesson = lessons[lessonIndex];
                  return _buildLessonSection(
                    theme: theme,
                    lessonIndex: lessonIndex,
                    lessonTitle: lesson.title,
                    subLessons: lesson.subLessons,
                    completed: completed,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------
  // UI COMPONENTS
  // ---------------------------------------------------------

  Widget _buildLockedPreviewHeader(ThemeData theme) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade300),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 14,
                    color: Colors.orange.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Preview Mode',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.orange.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildUnlockedHeader(ThemeData theme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.shade300),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, size: 14, color: Colors.green.shade600),
              const SizedBox(width: 4),
              Text(
                'Enrolled',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLessonSection({
    required ThemeData theme,
    required int lessonIndex,
    required String lessonTitle,
    required List<SubLesson> subLessons,
    required List<String> completed,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                expandedSections[lessonIndex] = !expandedSections[lessonIndex];
              });
            },
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(
                    expandedSections[lessonIndex]
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Section ${lessonIndex + 1}: $lessonTitle',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (expandedSections[lessonIndex])
            Column(
              children: subLessons.asMap().entries.map((entry) {
                final subIndex = entry.key;
                final sub = entry.value;
                final subId = "$lessonIndex-$subIndex";

                final unlocked = _isSubLessonUnlocked(
                  lessonIndex: lessonIndex,
                  subIndex: subIndex,
                  completed: completed,
                );

                final isCompleted = completed.contains(subId);

                return _buildSubLessonTile(
                  theme: theme,
                  subIndex: subIndex,
                  sub: sub,
                  subId: subId,
                  unlocked: unlocked,
                  isCompleted: isCompleted,
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildSubLessonTile({
    required ThemeData theme,
    required int subIndex,
    required SubLesson sub,
    required String subId,
    required bool unlocked,
    required bool isCompleted,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: unlocked
            ? Colors.blue.shade50.withValues(alpha: 0.4)
            : theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: unlocked ? Colors.blue.shade200 : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: unlocked ? Colors.blue.shade100 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              (subIndex + 1).toString().padLeft(2, '0'),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: unlocked ? Colors.blue.shade700 : Colors.grey.shade600,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              sub.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(width: 12),

          GestureDetector(
            onTap: () {
              if (!unlocked) {
                _showEnrollDialog();
                return;
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<LessonProgressBloc>(),
                    child: YoutubePlayerPage(
                      videoUrl: sub.youtubeLink,
                      courseId: widget.course.id,
                      studentId: studentId,
                      subLessonId: subId,
                    ),
                  ),
                ),
              );
            },
            child: Icon(
              isCompleted
                  ? Icons.check_circle
                  : unlocked
                  ? Icons.play_circle_fill
                  : Icons.lock_outline,
              size: 28,
              color: isCompleted
                  ? Colors.green
                  : unlocked
                  ? Colors.blue.shade600
                  : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // UNLOCK LOGIC
  // ---------------------------------------------------------

  bool _isSubLessonUnlocked({
    required int lessonIndex,
    required int subIndex,
    required List<String> completed,
  }) {
    if (lessonIndex == 0 && subIndex == 0) return true;
    if (subIndex == 0) return true;

    final prevId = "$lessonIndex-${subIndex - 1}";
    return completed.contains(prevId);
  }

  // ---------------------------------------------------------
  // ENROLL DIALOG
  // ---------------------------------------------------------

  void _showEnrollDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Enroll to Access'),
        content: const Text('Please enroll to unlock full course content.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => enrolled = true);
            },
            child: const Text('Enroll Now'),
          ),
        ],
      ),
    );
  }
}
