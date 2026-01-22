// widgets/review_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../bloc/course_review_bloc.dart';
import '../bloc/course_review_event.dart';
import '../bloc/course_review_state.dart';

class ReviewForm extends StatefulWidget {
  final String courseId;
  const ReviewForm({super.key, required this.courseId});

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  double rating = 0;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final studentId = FirebaseAuth.instance.currentUser!.uid;

    return BlocConsumer<CourseReviewBloc, CourseReviewState>(
      listener: (_, state) {
        if (state is CourseReviewSubmitted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Review submitted')));
          controller.clear();
          setState(() => rating = 0);
        }
      },
      builder: (_, state) {
        final loading = state is CourseReviewLoading;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your rating: ${rating.toStringAsFixed(1)} ★'),
            Slider(
              value: rating,
              min: 0,
              max: 5,
              divisions: 10,
              label: rating.toStringAsFixed(1),
              onChanged: loading ? null : (v) => setState(() => rating = v),
            ),
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Review',
                border: OutlineInputBorder(),
              ),
              enabled: !loading,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: loading
                  ? null
                  : () {
                      context.read<CourseReviewBloc>().add(
                        SubmitReviewEvent(
                          courseId: widget.courseId,
                          studentId: studentId,
                          rating: rating,
                          reviewText: controller.text.trim(),
                        ),
                      );
                    },
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text('Submit review'),
            ),
          ],
        );
      },
    );
  }
}
