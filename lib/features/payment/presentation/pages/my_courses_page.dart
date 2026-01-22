// presentation/pages/my_courses_page.dart
import 'package:eduera_student/core/constants/colors.dart';
import 'package:eduera_student/features/payment/presentation/bloc/enrollment/enrollment_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../bloc/enrollment/enrollment_event.dart';
import '../bloc/enrollment/enrollment_state.dart';
import 'widget/course_tab_view.dart';

class MyCoursesPage extends StatelessWidget {
  const MyCoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.school_outlined, size: 80, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Please log in to view your courses',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    context.read<EnrollmentBloc>().add(
      LoadEnrolledCoursesEvent(currentUser.uid),
    );

    return _MyCoursesPageContent();
  }
}

class _MyCoursesPageContent extends StatefulWidget {
  const _MyCoursesPageContent();

  @override
  State<_MyCoursesPageContent> createState() => _MyCoursesPageContentState();
}

class _MyCoursesPageContentState extends State<_MyCoursesPageContent> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryDark,
       
        title: const Text(
          'My Courses',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<EnrollmentBloc, EnrollmentState>(
        builder: (context, state) {
          if (state is EnrollmentLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EnrolledCoursesLoaded) {
            return Column(
              children: [
                // Search bar and tabs in white container
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      // Search bar
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      //   child: TextField(
                      //     decoration: InputDecoration(
                    
                      //       hintText: 'Search for ...',
                      //       hintStyle: TextStyle(color: Colors.grey[400]),
                      //       // prefixIcon: Icon(
                      //       //   Icons.search,
                      //       //   color: AppColors.background,
                      //       // ),
                      //       suffixIcon: Container(
                      //         margin: const EdgeInsets.all(4),
                      //         decoration: BoxDecoration(
                      //           color: const Color(0xFF2196F3),
                      //           borderRadius: BorderRadius.circular(10),
                      //         ),
                      //         child: const Icon(
                      //           Icons.search,
                      //           color: Colors.white,
                      //           size: 20,
                      //         ),
                      //       ),
                      //       filled: true,
                      //       fillColor: const Color(0xFFF5F5F5),
                      //       border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(12),
                      //         borderSide: BorderSide.none,
                      //       ),
                      //       contentPadding: const EdgeInsets.symmetric(
                      //         vertical: 14,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Tab buttons
                      
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: _TabButton(
                                label: 'Completed',
                                isSelected: _selectedTabIndex == 0,
                                onTap: () {
                                  setState(() {
                                    _selectedTabIndex = 0;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _TabButton(
                                label: 'Ongoing',
                                isSelected: _selectedTabIndex == 1,
                                onTap: () {
                                  setState(() {
                                    _selectedTabIndex = 1;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Course list
                Expanded(
                  child: CourseTabView(
                    status: _selectedTabIndex == 0 ? 'completed' : 'ongoing',
                    allCourses: state.courses,
                  ),
                ),
              ],
            );
          } else if (state is EnrollmentError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00897B) : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
