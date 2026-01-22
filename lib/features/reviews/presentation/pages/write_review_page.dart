import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/review.dart';
import '../bloc/review_bloc.dart';
import '../bloc/review_event.dart';

class WriteReviewPage extends StatefulWidget {
  final String courseId;
  final String courseTitle;
  final String category;
  final String courseImageUrl;

  final String currentUserId;
  final String currentUserName;
  final String currentUserImageUrl;
  final String mentorId;

  const WriteReviewPage({
    super.key,
    required this.courseId,
    required this.courseTitle,
    required this.category,
    required this.courseImageUrl,
    required this.currentUserId,
    required this.currentUserName,
    required this.currentUserImageUrl,
    required this.mentorId,
  });

  @override
  State<WriteReviewPage> createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
  double rating = 0;
  final TextEditingController commentController = TextEditingController();
  bool isSubmitting = false;

  String _detectCategory(double rating) {
    if (rating >= 4.5) return "Excellent";
    if (rating >= 3.5) return "Good";
    if (rating >= 2.5) return "Average";
    if (rating >= 1.5) return "Below Average";
    return "Poor";
  }

  @override
  Widget build(BuildContext context) {
    final remaining = 250 - commentController.text.length;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: const Text(
          "Write a Review",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ⭐ Course Info Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 005),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.courseImageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.category,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.courseTitle,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            /// ⭐ Rating Section
            const Text(
              "Rating",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starIndex = index + 1;
                  return GestureDetector(
                    onTap: () => setState(() => rating = starIndex.toDouble()),
                    child: AnimatedScale(
                      scale: rating >= starIndex ? 1.2 : 1.0,
                      duration: const Duration(milliseconds: 150),
                      child: Icon(
                        Icons.star_rounded,
                        size: 36,
                        color: rating >= starIndex
                            ? Colors.orange
                            : Colors.grey.shade400,
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 28),

            /// ⭐ Review Input
            const Text(
              "Write your Review",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: TextField(
                controller: commentController,
                maxLength: 250,
                maxLines: 6,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: "Share your experience about the course...",
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  counterText: "*$remaining Characters Remaining",
                  counterStyle: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            /// ⭐ Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isSubmitting ? null : _submitReview,
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                label: const Text(
                  "Submit Review",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ⭐ Submit Review Logic
  void _submitReview() async {
    if (rating == 0) {
      _showError("Please select a rating");
      return;
    }

    if (commentController.text.trim().isEmpty) {
      _showError("Please write a comment");
      return;
    }

    setState(() => isSubmitting = true);

    final review = Review(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      courseId: widget.courseId,
      courseTitle: widget.courseTitle,
      category: widget.category,
      courseImageUrl: widget.courseImageUrl,
      studentId: widget.currentUserId,
      studentName: widget.currentUserName,
      studentImageUrl: widget.currentUserImageUrl,
      mentorId: widget.mentorId,
      rating: rating,
      ratingCategory: _detectCategory(rating),
      comment: commentController.text.trim(),
      createdAt: DateTime.now(),
      updatedAt: null,
      likeCount: 0,
      dislikeCount: 0,
      likedBy: const [],
      dislikedBy: const [],
      isLikedByCurrentUser: false,
    );

    context.read<ReviewBloc>().add(AddReviewEvent(review));

    setState(() => isSubmitting = false);

    //  Success Popup
    _showSuccess("Review submitted successfully!");

    //  Close page after short delay
    Future.delayed(const Duration(milliseconds: 800), () {
     if (!mounted) return;
      Navigator.pop(context);
    });
  }

  //  Error Popup
  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // 💚 Success Popup
  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
