import 'package:eduera_student/core/constants/colors.dart';
import 'package:eduera_student/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:eduera_student/features/bookmark/presentation/bloc/bookmark_event.dart';
import 'package:eduera_student/features/bookmark/presentation/bloc/bookmark_state.dart';
import 'package:eduera_student/features/home/presentation/bloc/category/category_bloc.dart';
import 'package:eduera_student/features/home/presentation/bloc/course_bloc.dart';
import 'package:eduera_student/features/home/presentation/bloc/course_event.dart';
import 'package:eduera_student/features/home/presentation/bloc/course_state.dart';
import 'package:eduera_student/features/home/presentation/pages/course_detail_page.dart';
import 'package:eduera_student/features/home/presentation/pages/widgets/course_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularCoursesPage extends StatefulWidget {
  const PopularCoursesPage({super.key});

  @override
  State<PopularCoursesPage> createState() => _PopularCoursesPageState();
}

class _PopularCoursesPageState extends State<PopularCoursesPage> {
  String? selectedCategory;
  bool showSearch = false;
  String searchQuery = '';

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(LoadCategoriesEvent());
    context.read<CourseBloc>().add(LoadCoursesEvent());

    final userId = FirebaseAuth.instance.currentUser!.uid;
    context.read<BookmarkBloc>().add(LoadAllBookmarks(userId: userId));
  }

  void _toggleSearch() {
    setState(() => showSearch = !showSearch);

    if (!showSearch) {
      _searchController.clear();
      // when closing search, reload all courses
      context.read<CourseBloc>().add(LoadCoursesEvent());
    }
  }

  void _onSearchChanged(String query) {
    setState(() => searchQuery = query);
    context.read<CourseBloc>().add(SearchCoursesEvent(query));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        title: const Text(
          "All Courses",
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(showSearch ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Search bar (animated)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: showSearch
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search courses...",
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: _onSearchChanged,
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // Category chips
          // BlocBuilder<CategoryBloc, CategoryState>(
          //   builder: (context, state) {
          //     if (state is CategoryLoading) {
          //       return const Padding(
          //         padding: EdgeInsets.all(16),
          //         child: CircularProgressIndicator(),
          //       );
          //     }

          //     if (state is CategoryLoaded) {
          //       return SizedBox(
          //         height: 50,
          //         child: ListView.separated(
          //           padding: const EdgeInsets.symmetric(horizontal: 16),
          //           scrollDirection: Axis.horizontal,
          //           itemCount: state.categories.length,
          //           separatorBuilder: (_, _) => const SizedBox(width: 10),
          //           itemBuilder: (_, index) {
          //             final cat = state.categories[index];
          //             final isSelected = selectedCategory == cat.name;

          //             return ChoiceChip(
          //               label: Text(cat.name),
          //               selected: isSelected,
          //               selectedColor: Colors.green,
          //               labelStyle: TextStyle(
          //                 color: isSelected ? Colors.white : Colors.black,
          //                 fontWeight: FontWeight.w600,
          //               ),
          //               onSelected: (val) {
          //                 setState(() {
          //                   selectedCategory = val ? cat.name : null;
          //                 });
          //                 context.read<CourseBloc>().add(
          //                   val
          //                       ? LoadCoursesByCategoryEvent(cat.name)
          //                       : LoadCoursesEvent(),
          //                 );
          //               },
          //             );
          //           },
          //         ),
          //       );
          //     }

          //     return const SizedBox.shrink();
          //   },
          // ),

        //  const SizedBox(height: 10),

          // Course list
          Expanded(
            child: BlocBuilder<CourseBloc, CourseState>(
              builder: (context, courseState) {
                if (courseState is CourseLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (courseState is CourseLoaded) {
                  if (courseState.courses.isEmpty) {
                    return const Center(child: Text("No courses found."));
                  }

                  return BlocBuilder<BookmarkBloc, BookmarkState>(
                    builder: (context, bookmarkState) {
                      final bookmarkedIds = bookmarkState is BookmarkListLoaded
                          ? bookmarkState.bookmarkedCourseIds
                          : <String>{};

                      return ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: courseState.courses.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (_, index) {
                          final course = courseState.courses[index];
                          final isBookmarked = bookmarkedIds.contains(
                            course.id,
                          );
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
                              isBookmarked: isBookmarked,
                              horizontal: false,
                            ),
                          );
                        },
                      );
                    },
                  );
                }

                if (courseState is CourseError) {
                  return Center(child: Text("Error: ${courseState.message}"));
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
