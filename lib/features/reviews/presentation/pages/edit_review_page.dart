import 'package:eduera_student/features/reviews/domain/entities/review.dart';
import 'package:eduera_student/features/reviews/presentation/bloc/review_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/review_bloc.dart';

class EditReviewPage extends StatefulWidget {
  final Review review;
  const EditReviewPage({super.key, required this.review});

  @override
  State<EditReviewPage> createState() => _EditReviewPageState();
}

class _EditReviewPageState extends State<EditReviewPage> {
  late double rating;
  late TextEditingController commentController;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
   rating = widget.review.rating;
    commentController = TextEditingController(text: widget.review.comment);
  }

  String _detectRatingCategory(double rating) {
    if (rating >= 4.5) return "Excellent";
    if (rating >= 3.5) return "Good";
    if (rating >= 2.5) return "Average";
    if (rating >= 1.5) return "Below Average";
    return "Poor";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Review")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///  Rating
            const Text(
              "Update Rating",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            Row(
              children: List.generate(5, (index) {
                final starIndex = index + 1;
                return GestureDetector(
                  onTap: () => setState(() => rating = starIndex.toDouble()),
                  child: Icon(
                    Icons.star,
                    size: 32,
                    color: rating >= starIndex ? Colors.orange : Colors.grey,
                  ),
                );
              }),
            ),

            const SizedBox(height: 24),

            /// ⭐ Comment
            const Text(
              "Update Comment",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: commentController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Update your review...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const Spacer(),

            /// ⭐ Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : _submitEdit,
                child: isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Save Changes"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitEdit() async {
    if (rating == 0) {
      _showMessage("Please select a rating");
      return;
    }

    if (commentController.text.trim().isEmpty) {
      _showMessage("Please write a comment");
      return;
    }

    setState(() => isSubmitting = true);

    final updatedReview = widget.review.copyWith(
      rating: rating,
      comment: commentController.text.trim(),
      ratingCategory: _detectRatingCategory(rating),
      updatedAt: DateTime.now(),
    );
    context.read<ReviewBloc>().add(EditReviewEvent(updatedReview));

    setState(() => isSubmitting = false);

    Navigator.pop(context);
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
