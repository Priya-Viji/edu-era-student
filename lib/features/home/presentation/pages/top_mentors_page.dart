import 'package:eduera_student/core/constants/colors.dart';
import 'package:eduera_student/features/home/data/models/mentor_model.dart';
import 'package:eduera_student/features/home/presentation/bloc/mentor_bloc/mentor_bloc.dart';
import 'package:eduera_student/features/home/presentation/pages/mentor_course_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopMentorsPage extends StatefulWidget {
  const TopMentorsPage({super.key});

  @override
  State<TopMentorsPage> createState() => _TopMentorsPageState();
}

class _TopMentorsPageState extends State<TopMentorsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Top Mentors',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<MentorBloc, MentorState>(
        builder: (context, state) {
          if (state is MentorLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MentorsSuccess) {
            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: state.mentors.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final mentor = state.mentors[index];
                return _buildMentorCard(mentor);
              },
            );
          } else if (state is MentorError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(state.message, style: const TextStyle(fontSize: 16)),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildMentorCard(MentorModel mentor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MentorCourseListPage(mentorId: mentor.id, mentorName: mentor.name,),
          ),
        );
      },

      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    _getGradientColor(mentor.name)[0],
                    _getGradientColor(mentor.name)[1],
                  ],
                ),
              ),
              child: mentor.photoUrl != null && mentor.photoUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Image.network(
                        mentor.photoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            _buildAvatarText(mentor.name),
                      ),
                    )
                  : _buildAvatarText(mentor.name),
            ),
            const SizedBox(width: 16),
            // Mentor Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mentor.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1a1a1a),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mentor.expertise.isNotEmpty
                        ? mentor.expertise.join(', ')
                        : 'Expert Mentor',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Follow/Message Button
            // Container(
            //   padding: const EdgeInsets.all(8),
            //   decoration: BoxDecoration(
            //     color: const Color(0xFF2196F3).withOpacity(0.1),
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            //   child: const Icon(
            //     Icons.message_outlined,
            //     color: Color(0xFF2196F3),
            //     size: 20,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarText(String name) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.white,
        ),
      ),
    );
  }

  List<Color> _getGradientColor(String name) {
    // Generate consistent colors based on name
    final hash = name.hashCode % 5;
    switch (hash) {
      case 0:
        return [const Color(0xFF2196F3), const Color(0xFF1976D2)];
      case 1:
        return [const Color(0xFF4CAF50), const Color(0xFF388E3C)];
      case 2:
        return [const Color(0xFFFF9800), const Color(0xFFF57C00)];
      case 3:
        return [const Color(0xFF9C27B0), const Color(0xFF7B1FA2)];
      default:
        return [const Color(0xFFE91E63), const Color(0xFFC2185B)];
    }
  }
}
