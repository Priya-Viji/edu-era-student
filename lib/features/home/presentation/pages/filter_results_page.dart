import 'package:eduera_student/features/home/presentation/bloc/course_bloc.dart';
import 'package:eduera_student/features/home/presentation/bloc/course_event.dart';
import 'package:eduera_student/features/home/presentation/bloc/course_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilteredResultsPage extends StatefulWidget {
  final Map<String, dynamic> filters;

  const FilteredResultsPage({super.key, required this.filters});

  @override
  State<FilteredResultsPage> createState() => _FilteredResultsPageState();
}

class _FilteredResultsPageState extends State<FilteredResultsPage> {
  @override
  void initState() {
    super.initState();
    context.read<CourseBloc>().add(
      FilterCoursesEvent(
        categories: widget.filters['categories'], 
        levels: widget.filters['levels'], 
        isFree: widget.filters['isFree'],
        rating: widget.filters['rating'],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Filtered Results")),
      body: BlocBuilder<CourseBloc, CourseState>(
        builder: (context, state) {
          if (state is CourseLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CourseLoaded) {
              if (state.courses.isEmpty) {
              return const Center(
                child: Text(
                  'No results Matches.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Results for your filters',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.courses.length,
                    itemBuilder: (_, index) {
                      final course = state.courses[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: Image.network(
                            course.thumbnailUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                          title: Text(course.title),
                          subtitle: Text(
                            '${course.category} • ₹${course.price} • ${course.rating} ★',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          if (state is CourseError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
