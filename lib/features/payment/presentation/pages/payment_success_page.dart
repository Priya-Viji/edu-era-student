// import 'package:eduera_student/core/constants/colors.dart';
// import 'package:eduera_student/features/payment/domain/entities/enroll_entity.dart';
// import 'package:eduera_student/features/payment/presentation/bloc/enrollment/enrollment_bloc.dart';
// import 'package:eduera_student/features/payment/presentation/bloc/enrollment/enrollment_event.dart';
// import 'package:eduera_student/features/payment/presentation/pages/my_courses_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class PaymentSuccessPage extends StatefulWidget {
//   final String courseId;
//   final String courseName;
//   final String transactionId;
//   final double coursePrice;
//   final String mentorId;

//   const PaymentSuccessPage({
//     super.key,
//     required this.courseId,
//     required this.courseName,
//     required this.coursePrice,
//     required this.transactionId,
//     required this.mentorId,
//   });

//   @override
//   State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
// }

// class _PaymentSuccessPageState extends State<PaymentSuccessPage> {
//   @override
//   void initState() {
//     super.initState();
//     _saveEnrollment();
//   }

//  Future<void> _saveEnrollment() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;

//     final enrollment = EnrollEntity(
//       studentId: user.uid,
//       mentorId: widget.mentorId,
//       courseId: widget.courseId,
//       courseTitle: widget.courseName,
//       status: 'ongoing',
//       plan: '1 Year',
//       price: widget.coursePrice,
//       paymentId: widget.transactionId,
//       enrolledAt: DateTime.now(),
//       completedSubLessons: const [],
//       isCourseCompleted: false,
//     );

//     context.read<EnrollmentBloc>().add(SaveEnrollmentEvent(enrollment));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Payment Success')),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Icon(Icons.check_circle, size: 100, color: Colors.blueAccent),
//               const SizedBox(height: 24),
//               const Text(
//                 'Payment Successful!',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 'Course: ${widget.courseName}',
//                 style: const TextStyle(fontSize: 18),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'Transaction ID: ${widget.transactionId}',
//                 style: const TextStyle(fontSize: 14, color: Colors.grey),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (_) => const MyCoursesPage()),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blueAccent,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 32,
//                     vertical: 12,
//                   ),
//                 ),
//                 child: const Text(
//                   'Go to MyCourse',
//                   style: TextStyle(fontSize: 16, color: AppColors.background),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:eduera_student/features/payment/presentation/pages/e_receipt_page.dart';
import 'package:flutter/material.dart';
import 'package:eduera_student/core/constants/colors.dart';
import 'package:eduera_student/features/payment/domain/entities/enroll_entity.dart';
import 'package:eduera_student/features/payment/presentation/bloc/enrollment/enrollment_bloc.dart';
import 'package:eduera_student/features/payment/presentation/bloc/enrollment/enrollment_event.dart';
import 'package:eduera_student/features/payment/presentation/pages/my_courses_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentSuccessPage extends StatefulWidget {
  final String courseId;
  final String courseName;
  final String transactionId;
  final double coursePrice;
  final String mentorId;

  const PaymentSuccessPage({
    super.key,
    required this.courseId,
    required this.courseName,
    required this.coursePrice,
    required this.transactionId,
    required this.mentorId,
  });

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage> {
  @override
  void initState() {
    super.initState();
    _saveEnrollment();
  }

  Future<void> _saveEnrollment() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final enrollment = EnrollEntity(
      studentId: user.uid,
      mentorId: widget.mentorId,
      courseId: widget.courseId,
      courseTitle: widget.courseName,
      status: 'ongoing',
      plan: '1 Year',
      price: widget.coursePrice,
      paymentId: widget.transactionId,
      enrolledAt: DateTime.now(),
      completedSubLessons: const [],
      isCourseCompleted: false,
    );

    context.read<EnrollmentBloc>().add(SaveEnrollmentEvent(enrollment));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.verified, size: 100, color: Colors.green),
              const SizedBox(height: 24),
              const Text(
                'Congratulations!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Your payment was successful.\nYou’ve unlocked a new course!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              Text(
                'Course: ${widget.courseName}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Transaction ID: ${widget.transactionId}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MyCoursesPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Watch the Course',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EReceiptPage(
                        name: 'Alex',
                        email: 'alexrexall@gmail.com',
                        course: widget.courseName,
                        category: 'Web Development',
                        transactionId: widget.transactionId,
                        price: widget.coursePrice,
                        date: DateTime(2023, 11, 20, 15, 45),
                        barcodeNumber1: '25234567',
                        barcodeNumber2: '28646345',
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.blueAccent),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'E-Receipt',
                  style: TextStyle(fontSize: 16, color: Colors.blueAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
