import 'package:eduera_student/core/constants/colors.dart';
import 'package:eduera_student/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'payment_success_page.dart';

class CheckoutPage extends StatelessWidget {
  final int priceInPaise;
  final String courseName;
  final String userEmail;
  final String userContact;
  final String razorpayKey;
  final String mentortId;

  const CheckoutPage({
    super.key,
    required this.priceInPaise,
    required this.courseName,
    required this.userEmail,
    required this.userContact,
    required this.razorpayKey,
    required this.courseId,
    required this.mentortId,
  });
  
  final String courseId;

  @override
  Widget build(BuildContext context) {
    final priceInRupees = priceInPaise / 100;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Checkout',style: TextStyle(color: AppColors.background),),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: AppColors.background),
        elevation: 0,
      ),
      body: BlocConsumer<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state.status == PaymentStatus.success) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => PaymentSuccessPage(
                  courseId: courseId,
                  courseName: state.courseName ?? courseName,
                  coursePrice: priceInRupees,
                  transactionId: state.paymentId ?? '',
                  mentorId: mentortId,
                ),
              ),
            );
          }

          if (state.status == PaymentStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error ?? 'Payment failed'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Price Card
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 32,
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'You are purchasing',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        courseName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '₹$priceInRupees',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Proceed Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: state.status == PaymentStatus.creatingOrder
                        ? null
                        : () {
                            context.read<PaymentBloc>().add(
                              PaymentStartRequested(
                                key: razorpayKey,
                                amountInPaise: priceInPaise,
                                currency: 'INR',
                                receipt:
                                    'rcpt_${DateTime.now().millisecondsSinceEpoch}',
                                name: 'EduEra',
                                description: 'Buy $courseName',
                                prefillEmail: userEmail,
                                prefillContact: userContact,
                                notes: {'course': courseName},
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blueAccent,
                      elevation: 5,
                      shadowColor: Colors.blueAccent,
                    ),
                    child: state.status == PaymentStatus.creatingOrder
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Proceed to Pay',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
