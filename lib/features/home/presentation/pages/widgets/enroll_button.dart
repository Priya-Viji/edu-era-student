import 'package:eduera_student/core/constants/config.dart';
import 'package:eduera_student/core/constants/course_detail_colors.dart';
import 'package:eduera_student/features/home/domain/entities/course_entity.dart';
import 'package:eduera_student/features/payment/presentation/pages/checkout_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class EnrollButton extends StatelessWidget {
  final CourseEntity course;

  const EnrollButton({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            final user = FirebaseAuth.instance.currentUser;
            final email = user?.email ?? '';
            final phone = user?.phoneNumber ?? '';
            final int priceInPaise = (course.price * 100).toInt();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CheckoutPage(
                  courseId: course.id,
                  priceInPaise: priceInPaise,
                  courseName: course.title,
                  userEmail: email,
                  userContact: phone,
                  mentortId: course.mentorId,
                  razorpayKey: AppConfig.razorpayKey,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: CourseDetailColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Enroll Now',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
