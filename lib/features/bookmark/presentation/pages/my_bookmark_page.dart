import 'package:eduera_student/core/constants/colors.dart';
import 'package:eduera_student/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:eduera_student/features/bookmark/presentation/bloc/bookmark_event.dart';
import 'package:eduera_student/features/bookmark/presentation/bloc/bookmark_state.dart';
import 'package:eduera_student/features/bookmark/presentation/pages/widgets/remove_bookmark_dialog.dart';
import 'package:eduera_student/features/home/presentation/pages/course_detail_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyBookmarkPage extends StatefulWidget {
  const MyBookmarkPage({super.key});

  @override
  State<MyBookmarkPage> createState() => _MyBookmarkPageState();
}

class _MyBookmarkPageState extends State<MyBookmarkPage> {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  int selectedCategoryIndex = 0;
  List<String> categories = ["All"];

  @override
  void initState() {
    super.initState();
    context.read<BookmarkBloc>().add(LoadAllBookmarks(userId: currentUserId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        title: const Text(
          "My Bookmarks",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          // Uncomment if you want category tabs
          // _buildCategoryTabs(),
          const SizedBox(height: 8),
          Expanded(child: _buildBookmarkList()),
        ],
      ),
    );
  }

  /// 🔹 Bookmark List via Bloc
  Widget _buildBookmarkList() {
    return BlocBuilder<BookmarkBloc, BookmarkState>(
      builder: (context, state) {
        if (state is BookmarkLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is BookmarkListLoaded) {
          if (state.bookmarkedCourseIds.isEmpty) {
            return const Center(
              child: Text("No bookmarks yet.", style: TextStyle(fontSize: 20)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.bookmarkedCourseIds.length,
            itemBuilder: (context, index) {
              final courseId = state.bookmarkedCourseIds.elementAt(index);

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('courses')
                    .doc(courseId)
                    .get(),
                builder: (context, courseSnap) {
                  if (!courseSnap.hasData || !courseSnap.data!.exists) {
                    return const SizedBox.shrink();
                  }

                  final courseData =
                      courseSnap.data!.data() as Map<String, dynamic>;

                  return _buildCourseCard(courseData, courseId);
                },
              );
            },
          );
        }
        if (state is BookmarkError) {
          return Center(child: Text("Error: ${state.message}"));
        }
        return const SizedBox.shrink();
      },
    );
  }

  /// 🔹 Helpers for dynamic values
  Future<double> _getAverageRating(String courseId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('reviews')
        .where('courseId', isEqualTo: courseId)
        .get();

    if (snapshot.docs.isEmpty) return 0.0;

    final ratings = snapshot.docs.map((d) => (d['rating'] as num).toDouble());
    return ratings.reduce((a, b) => a + b) / ratings.length;
  }

  Future<int> _getEnrollmentCount(String courseId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('enrollments')
        .where('courseId', isEqualTo: courseId)
        .get();

    return snapshot.docs.length;
  }

  /// 🔹 Course Card
  Widget _buildCourseCard(Map<String, dynamic> course, String courseId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CourseDetailPage(courseId: courseId),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Row(
          children: [
            /// Thumbnail
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(course['thumbnailUrl']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),

            /// Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course['category'] ?? '',
                    style: const TextStyle(color: Colors.orange),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    course['title'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${(course['price'] as num?)?.toInt() ?? 899}/-",
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  /// Dynamic rating + enrollment
                  Row(
                    children: [
                      FutureBuilder<double>(
                        future: _getAverageRating(courseId),
                        builder: (context, snapshot) {
                          final rating = snapshot.data ?? 0.0;
                          return Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(width: 15),
                      Container(width: 1, height: 14, color: Colors.grey),
                      const SizedBox(width: 17),
                      FutureBuilder<int>(
                        future: _getEnrollmentCount(courseId),
                        builder: (context, snapshot) {
                          final count = snapshot.data ?? 0;
                          return Text(
                            "$count Std",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// Bookmark toggle
            BlocBuilder<BookmarkBloc, BookmarkState>(
              builder: (context, bState) {
                final isBookmarked =
                    bState is BookmarkListLoaded &&
                    bState.bookmarkedCourseIds.contains(courseId);

                return IconButton(
                  icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: isBookmarked ? Colors.blueAccent : Colors.grey,
                  ),
                  onPressed: () {
                    showRemoveBookmarkDialog(
                      context: context,
                      course: course,
                      onConfirm: () {
                        context.read<BookmarkBloc>().add(
                          ToggleBookmarkEvent(
                            userId: currentUserId,
                            courseId: courseId,
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
      ),
    );
  }
}
