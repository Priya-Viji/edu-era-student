import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/review_bloc.dart';
import '../bloc/review_event.dart';
import '../bloc/review_state.dart';
import 'widgets/review_card.dart';
import 'write_review_page.dart';

class ReviewsListPage extends StatefulWidget {
  final String courseId;
  final String courseTitle;
  final String category;
  final String courseImageUrl;
  final String currentUserId;
  final String currentUserName;
  final String currentUserImageUrl;
  final String mentorId;

  const ReviewsListPage({
    super.key,
    required this.courseId,
    required this.courseTitle,
    required this.category,
    required this.courseImageUrl,
    required this.currentUserId,
    required this.currentUserName,
    required this.currentUserImageUrl,
    required this.mentorId
  });
  
  bool get isEnrolled => false;

  @override
  State<ReviewsListPage> createState() => _ReviewsListPageState();
}

class _ReviewsListPageState extends State<ReviewsListPage> {
  late ScrollController _scrollController;
  String sortBy = "newest";

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    // Lazy loading listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<ReviewBloc>().add(
          LoadMoreReviews(
            courseId: widget.courseId,
            currentUserId: widget.currentUserId,
          ),
        );
      }
    });

    // Load first page
    context.read<ReviewBloc>().add(
      LoadReviews(
        courseId: widget.courseId,
        currentUserId: widget.currentUserId,
        
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reviews")),
      body: BlocBuilder<ReviewBloc, ReviewState>(
        builder: (context, state) {
          if (state is ReviewLoading || state is ReviewInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ReviewError) {
            return Center(child: Text(state.message));
          }

          if (state is ReviewLoaded) {
            return Column(
              children: [
                const SizedBox(height: 16),

                /// ⭐ Average Rating
                Text(
                  "${state.averageRating.toStringAsFixed(1)} ★",
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Based on ${state.totalReviews} Reviews",
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 16),

                // /// ⭐ Sorting Dropdown
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 16),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       DropdownButton<String>(
                //         value: sortBy,
                //         items: const [
                //           DropdownMenuItem(
                //             value: "newest",
                //             child: Text("Newest"),
                //           ),
                //           DropdownMenuItem(
                //             value: "rating",
                //             child: Text("Highest Rating"),
                //           ),
                //         ],
                //        onChanged: (value) {
                //           if (value != null) {
                //             setState(() => sortBy = value);

                //          context.read<ReviewBloc>().add(
                //               ChangeSortOrder(
                //                 sortBy: value,
                //                 currentUserId: widget.currentUserId,
                //               ),
                //             );

                //           }
                //         },

                //       ),
                //     ],
                //   ),
                // ),

                const SizedBox(height: 8),

                /// ⭐ Filter Chips
                _buildFilterChips(context),

                const SizedBox(height: 8),

                /// ⭐ Review List + Lazy Loading
             Expanded(
  child: ListView.builder(
    controller: _scrollController,
    itemCount: state.reviews.length + 1, // +1 for loader
    itemBuilder: (context, index) {
      if (index == state.reviews.length) {
        return state.hasMore
            ? const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              )
            : const SizedBox.shrink();
      }

      final review = state.reviews[index];
      return ReviewCard(
        review: review,
        currentUserId: widget.currentUserId,
      );
    },
  ),
),

/// ⭐ Current User Review Stream
StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
      .collection('reviews')
      .where('courseId', isEqualTo: widget.courseId)   // ✅ use widget.courseId
      .where('studentId', isEqualTo: widget.currentUserId) // ✅ use widget.currentUserId
      .snapshots(),
  builder: (context, snapshot) {
    final hasWrittenReview = (snapshot.data?.docs ?? []).isNotEmpty;

    if (widget.isEnrolled && !hasWrittenReview) {   // ✅ use widget.isEnrolled
      return Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WriteReviewPage(
                    courseId: widget.courseId,
                    courseTitle: widget.courseTitle,
                    category: widget.category,
                    courseImageUrl: widget.courseImageUrl,
                    currentUserId: widget.currentUserId,
                    currentUserName: widget.currentUserName,
                    currentUserImageUrl: widget.currentUserImageUrl,
                    mentorId: widget.mentorId,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.edit),
            label: const Text("Write a Review"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  },
),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  } 

  /// ⭐ Filter Chips
  Widget _buildFilterChips(BuildContext context) {
    final filters = ["Excellent", "Good", "Average", "Below Average"];
String? selectedFilter;

    return Wrap(
      spacing: 8,
      children: filters.map((filter) {
        return ChoiceChip(
          label: Text(filter),
        selected: selectedFilter == filter,
          onSelected: (_) {
            setState(() => selectedFilter = filter);

            context.read<ReviewBloc>().add(
              LoadReviews(
                courseId: widget.courseId,
                currentUserId: widget.currentUserId,
                filter: filter,
              ),
            );
          }

        );
      }).toList(),
    );
  }
}
