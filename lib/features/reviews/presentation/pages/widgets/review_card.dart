import 'package:eduera_student/features/reviews/domain/entities/review.dart';
import 'package:eduera_student/features/reviews/presentation/bloc/review_bloc.dart';
import 'package:eduera_student/features/reviews/presentation/bloc/review_event.dart';
import 'package:eduera_student/features/reviews/presentation/pages/edit_review_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewCard extends StatefulWidget {
  final Review review;
  final String currentUserId;

  const ReviewCard({
    super.key,
    required this.review,
    required this.currentUserId,
  });

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfoRow(),
            const SizedBox(height: 12),
            _buildCommentSection(),
            const SizedBox(height: 8),
            if (widget.review.updatedAt != null) _buildEditedLabel(),
            const SizedBox(height: 8),
            _buildLikeDislikeRow(context),
            const SizedBox(height: 12),
            if (widget.review.studentId == widget.currentUserId)
              _buildOwnerActions(context),
          ],
        ),
      ),
    );
  }

  /// ⭐ User Info Row
  Widget _buildUserInfoRow() {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundImage: widget.review.studentImageUrl.isNotEmpty
              ? NetworkImage(widget.review.studentImageUrl)
              : null,
          child: widget.review.studentImageUrl.isEmpty
              ? const Icon(Icons.person)
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            widget.review.studentName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          "${widget.review.rating} ★",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  /// ⭐ Comment with Show More / Show Less
  Widget _buildCommentSection() {
    final comment = widget.review.comment;
    final isLong = comment.length > 50;
    final displayText = _expanded || !isLong
        ? comment
        : comment.substring(0, 50);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(displayText, style: const TextStyle(fontSize: 15)),
        if (isLong)
          TextButton(
            onPressed: () => setState(() => _expanded = !_expanded),
            child: Text(
              _expanded ? "Show less" : "Show more",
              style: const TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  /// ⭐ Edited Label
  Widget _buildEditedLabel() {
    return const Text(
      "Edited",
      style: TextStyle(
        fontSize: 12,
        color: Colors.grey,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  /// ⭐ Like / Dislike Row
  Widget _buildLikeDislikeRow(BuildContext context) {
    return Row(
      children: [
        _buildLikeButton(context),
        const SizedBox(width: 24),
        _buildDislikeButton(context),
        const Spacer(),
        _buildDateSection(),
      ],
    );
  }

  Widget _buildLikeButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<ReviewBloc>().add(
          ToggleLikeEvent(
            reviewId: widget.review.id,
            currentUserId: widget.currentUserId,
          ),
        );
      },
      child: Row(
        children: [
          Icon(
            Icons.thumb_up,
            size: 20,
            color: widget.review.likedBy.contains(widget.currentUserId)
                ? Colors.green
                : Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(widget.review.likeCount.toString()),
        ],
      ),
    );
  }

  Widget _buildDislikeButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<ReviewBloc>().add(
          ToggleDislikeEvent(
            reviewId: widget.review.id,
            currentUserId: widget.currentUserId,
          ),
        );
      },
      child: Row(
        children: [
          Icon(
            Icons.thumb_down,
            size: 20,
            color: widget.review.dislikedBy.contains(widget.currentUserId)
                ? Colors.red
                : Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(widget.review.dislikeCount.toString()),
        ],
      ),
    );
  }

  /// ⭐ Date Section
  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          _formatDate(widget.review.createdAt),
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        if (widget.review.updatedAt != null)
          Text(
            "Updated: ${_formatDate(widget.review.updatedAt!)}",
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
      ],
    );
  }

  /// ⭐ Owner Actions
  Widget _buildOwnerActions(BuildContext context) {
    return Row(
      children: [
        TextButton.icon(
          onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditReviewPage(review: widget.review),
              ),
            );
          },
          icon: const Icon(Icons.edit, size: 18),
          label: const Text("Edit"),
        ),
        TextButton.icon(
          onPressed: () => _confirmDelete(context),
          icon: const Icon(Icons.delete, size: 18, color: Colors.red),
          label: const Text("Delete", style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  /// ⭐ Delete Confirmation Dialog
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Review"),
        content: const Text("Are you sure you want to delete this review?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ReviewBloc>().add(
                DeleteReviewEvent(
                  reviewId: widget.review.id,
                  courseId: widget.review.courseId,
                  currentUserId: widget.currentUserId,
                ),
              );
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// ⭐ Format date
  String _formatDate(DateTime date) {
    return "${date.day} ${_monthName(date.month)} ${date.year}";
  }

  String _monthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[month - 1];
  }
}
