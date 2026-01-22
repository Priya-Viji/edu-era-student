import 'package:eduera_student/features/home/presentation/bloc/mentor_bloc/mentor_bloc.dart';
import 'package:eduera_student/features/home/presentation/pages/course_detail_page.dart';
import 'package:eduera_student/features/home/presentation/pages/mentor_course_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduera_student/features/home/presentation/bloc/course_bloc.dart';
import 'package:eduera_student/features/home/presentation/bloc/course_event.dart';
import 'package:eduera_student/features/home/presentation/bloc/course_state.dart';
import 'package:eduera_student/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:eduera_student/features/bookmark/presentation/bloc/bookmark_state.dart';
import 'package:eduera_student/features/home/presentation/pages/widgets/course_card.dart';
import 'package:eduera_student/features/home/presentation/pages/filter_page.dart';

class SearchResultsPage extends StatefulWidget {
  final Map<String, dynamic>? filters;
  const SearchResultsPage({super.key, this.filters});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String query = '';
  int selectedTab = 0;
  bool _hasActiveFilters = false;
  final FocusNode _searchFocusNode = FocusNode();
  Map<String, dynamic>? _currentFilters;


  @override
  void initState() {
    super.initState();
    _currentFilters = widget.filters;

    if (_currentFilters != null) {
      context.read<CourseBloc>().add(
        FilterCoursesEvent(
          categories: _currentFilters!['categories'],
          levels: _currentFilters!['levels'],
          isFree: _currentFilters!['isFree'],
          rating: widget.filters!['rating'],
        ),
      );
    } else {
      context.read<CourseBloc>().add(LoadCoursesEvent());
    }
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    setState(() => query = value);
    context.read<CourseBloc>().add(SearchCoursesEvent(value));
  }

  void _openFilter() async {
   final filters = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FilterPage(
          initialCategories: widget.filters?['categories'] ?? [],
          initialLevels: widget.filters?['levels'] ?? [],
          initialIsFree: widget.filters?['isFree'],
          initialRating: widget.filters?['rating'],
        ),
      ),
    );


    if (filters != null && mounted) {
      setState(() {
        _currentFilters = filters;
        _hasActiveFilters =
            filters['categories']?.isNotEmpty == true ||
            filters['levels']?.isNotEmpty == true ||
            filters['isFree'] != null ||
            filters['rating'] != null;
      });

      context.read<CourseBloc>().add(
        FilterCoursesEvent(
          categories: filters['categories'],
          levels: filters['levels'],
          isFree: filters['isFree'],
          rating: filters['rating'],
        ),
      );
    }
  }

  void _clearSearch() {
    _controller.clear();
    setState(() => query = '');
    context.read<CourseBloc>().add(LoadCoursesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildModernHeader(),
              _buildTabBar(),
              if (_hasActiveFilters) _buildActiveFiltersChip(),
              if (query.isNotEmpty) _buildSearchQuery(),
              Expanded(
                child: selectedTab == 0
                    ? _buildCourseResults()
                    : _buildMentorResults(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 16, 16),
            child: Row(
              children: [
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Hero(
                    tag: 'search_bar',
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF10B981).withValues(alpha: 0.08),
                              const Color(0xFF059669).withValues(alpha: 0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _searchFocusNode.hasFocus
                                ? const Color(0xFF10B981)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            Icon(
                              Icons.search_rounded,
                              color: const Color(0xFF10B981),
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                focusNode: _searchFocusNode,
                                autofocus: true,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1A1A1A),
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Search for courses...',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true,
                                ),
                                onChanged: _onSearch,
                              ),
                            ),
                            if (query.isNotEmpty)
                              GestureDetector(
                                onTap: _clearSearch,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close_rounded,
                                    size: 16,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ),
                            const SizedBox(width: 12),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _buildFilterButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: _openFilter,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: _hasActiveFilters
                  ? const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF059669)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: _hasActiveFilters ? null : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(14),
              boxShadow: _hasActiveFilters
                  ? [
                      BoxShadow(
                        color: const Color(0xFF10B981).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              Icons.tune_rounded,
              color: _hasActiveFilters ? Colors.white : const Color(0xFF6B7280),
              size: 22,
            ),
          ),
        ),
        if (_hasActiveFilters)
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
                ),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Center(
                child: Icon(Icons.check, size: 12, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _buildModernTab("Courses", 0, Icons.school_rounded),
          _buildModernTab("Mentors", 1, Icons.people_rounded),
        ],
      ),
    );
  }

  Widget _buildModernTab(String label, int index, IconData icon) {
    final isSelected = selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF10B981).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.white : const Color(0xFF6B7280),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveFiltersChip() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFFFEF3C7), const Color(0xFFFDE68A)],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFBBF24), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.filter_alt_rounded,
                size: 16,
                color: Color(0xFFF59E0B),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Filters applied',
              style: TextStyle(
                color: Color(0xFF92400E),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                setState(() => _hasActiveFilters = false);
                context.read<CourseBloc>().add(LoadCoursesEvent());
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Clear all',
                  style: TextStyle(
                    color: Color(0xFFF59E0B),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchQuery() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.search_rounded,
              size: 16,
              color: Color(0xFF10B981),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                children: [
                  const TextSpan(text: 'Results for '),
                  TextSpan(
                    text: '"$query"',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseResults() {
    return BlocBuilder<CourseBloc, CourseState>(
      builder: (context, state) {
        if (state is CourseLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF059669)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 3,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Finding the best courses...',
                  style: TextStyle(
                    color: Color(0xFF1A1A1A),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This won\'t take long',
                  style: TextStyle(color: Colors.grey[500], fontSize: 14),
                ),
              ],
            ),
          );
        }

        if (state is CourseLoaded) {
          final courses = state.courses;

          if (courses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF10B981).withValues(alpha: 0.1),
                          const Color(0xFF059669).withValues(alpha: 0.05),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.search_off_rounded,
                      size: 72,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'No courses found',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Text(
                      'Try adjusting your search or filters to find what you\'re looking for',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[500],
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return BlocBuilder<BookmarkBloc, BookmarkState>(
            builder: (context, bookmarkState) {
              final bookmarkedIds = bookmarkState is BookmarkListLoaded
                  ? bookmarkState.bookmarkedCourseIds
                  : <String>{};

              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF10B981), Color(0xFF059669)],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${courses.length} ${courses.length == 1 ? 'course' : 'courses'}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Spacer(),
                          // Container(
                          //   padding: const EdgeInsets.symmetric(
                          //     horizontal: 12,
                          //     vertical: 6,
                          //   ),
                          //   decoration: BoxDecoration(
                          //     color: Colors.white,
                          //     borderRadius: BorderRadius.circular(8),
                          //     border: Border.all(
                          //       color: const Color(0xFFE5E7EB),
                          //     ),
                          //   ),
                          // child: Row(
                          //   children: [
                          //     Icon(
                          //       Icons.swap_vert_rounded,
                          //       size: 16,
                          //       color: Colors.grey[600],
                          //     ),
                          //     const SizedBox(width: 6),
                          //     Text(
                          //       'Sort',
                          //       style: TextStyle(
                          //         fontSize: 13,
                          //         fontWeight: FontWeight.w600,
                          //         color: Colors.grey[700],
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          //   ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final course = courses[index];
                        final isBookmarked = bookmarkedIds.contains(course.id);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: Duration(
                              milliseconds: 400 + (index * 60),
                            ),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, child) {
                              return Transform.translate(
                                offset: Offset(0, 30 * (1 - value)),
                                child: Opacity(
                                  opacity: value,
                                  child: Transform.scale(
                                    scale: 0.95 + (0.05 * value),
                                    child: child,
                                  ),
                                ),
                              );
                            },
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        CourseDetailPage(courseId: course.id),
                                  ),
                                );
                              },
                              child: CourseCard(
                                course: course,
                                isBookmarked: isBookmarked,
                                horizontal: false,
                              ),
                            ),
                          ),
                        );
                      }, childCount: courses.length),
                    ),
                  ),
                ],
              );
            },
          );
        }

        if (state is CourseError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFEF4444).withValues(alpha: 0.1),
                        const Color(0xFFDC2626).withValues(alpha: 0.05),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error_outline_rounded,
                    size: 72,
                    color: Color(0xFFEF4444),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Oops! Something went wrong',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[500],
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<CourseBloc>().add(LoadCoursesEvent());
                  },
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                  label: const Text(
                    'Try Again',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildMentorResults() {
    return BlocBuilder<MentorBloc, MentorState>(
      builder: (context, state) {
        if (state is MentorLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MentorsSuccess) {
          if (state.mentors.isEmpty) {
            return const Center(child: Text('No mentors found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            itemCount: state.mentors.length,
            itemBuilder: (context, index) {
              final mentor = state.mentors[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildMentorRowCard(
                  mentorId: mentor.id,
                  name: mentor.name,
                  photoUrl: mentor.photoUrl,
                  jobTitle: mentor.jobTitle,
                ),
              );
            },
          );
        }

        if (state is MentorError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildMentorRowCard({
    required String mentorId,
    required String name,
    String? photoUrl,
    String? jobTitle,
  }) {
    final hasPhoto = photoUrl != null && photoUrl.isNotEmpty;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                MentorCourseListPage(mentorId: mentorId, mentorName: name),
          ),
        );
      },
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
            child: hasPhoto
                ? ClipOval(
                    child: Image.network(
                      photoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          const Icon(Icons.person, color: Colors.grey),
                    ),
                  )
                : Center(
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  jobTitle ?? '',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


