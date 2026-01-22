import 'package:eduera_student/core/constants/course_detail_sizes.dart';
import 'package:eduera_student/features/home/domain/entities/course_entity.dart';
import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final CourseEntity course;

  const HeaderSection({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: CourseDetailSizes.headerHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            child: Image.network(
              course.thumbnailUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: Colors.grey[300],
                child: const Icon(Icons.image, size: 80, color: Colors.grey),
              ),
            ),
          ),
        ),
      
        // Positioned(
        //   bottom: 20,
        //   right: 20,
        //   child: Container(
        //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        //     decoration: BoxDecoration(
        //       color: Colors.black87,
        //       borderRadius: BorderRadius.circular(20),
        //     ),
        //     child: Row(
        //       children: [
        //         const Icon(Icons.star, color: Colors.amber, size: 16),
        //         const SizedBox(width: 4),
        //         Text(
        //           course.rating.toStringAsFixed(1),
        //           style: const TextStyle(
        //             color: Colors.white,
        //             fontWeight: FontWeight.bold,
        //             fontSize: 14,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
