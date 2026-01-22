// widgets/reviews_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/course_review_bloc.dart';
import '../bloc/course_review_event.dart';
import '../bloc/course_review_state.dart';

class ReviewsList extends StatelessWidget {
  final String courseId;
  const ReviewsList({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    context.read<CourseReviewBloc>().add(LoadReviewsEvent(courseId));

    return BlocBuilder<CourseReviewBloc, CourseReviewState>(
      builder: (_, state) {
        if (state is CourseReviewLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is CourseReviewsLoaded) {
          if (state.docs.isEmpty) {
            return const Center(child: Text('No reviews yet'));
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.docs.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final data = state.docs[i].data();
              final rating = (data['rating'] ?? 0).toDouble();
              final reviewText = (data['reviewText'] ?? '') as String;
              return ListTile(
                title: Text('${rating.toStringAsFixed(1)} ★'),
                subtitle: Text(reviewText),
              );
            },
          );
        }
        if (state is CourseReviewError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }
}
