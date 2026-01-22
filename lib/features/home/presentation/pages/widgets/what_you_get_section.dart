import 'package:flutter/material.dart';
import 'package:eduera_student/features/home/domain/entities/course_entity.dart';

class WhatYouGetSection extends StatelessWidget {
  final CourseEntity course;

  const WhatYouGetSection({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final items = [
      _BenefitItem(
        Icons.play_circle_outline,
        '${course.lessons.length} Lessons',
      ),
      _BenefitItem(Icons.devices, 'Access Mobile, Desktop & TV'),
      _BenefitItem(Icons.school_outlined, course.level),
      _BenefitItem(Icons.lock_clock, '1 Year Access'),
      _BenefitItem(
        Icons.workspace_premium_outlined,
        'Certificate of Completion',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "What You'll Get",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Column(children: items.map((item) => _buildItem(item)).toList()),
      ],
    );
  }

  Widget _buildItem(_BenefitItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(item.icon, size: 20, color: Colors.blueAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item.label,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

class _BenefitItem {
  final IconData icon;
  final String label;

  _BenefitItem(this.icon, this.label);
}
