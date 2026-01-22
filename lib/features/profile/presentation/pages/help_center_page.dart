import 'package:eduera_student/core/constants/colors.dart';
import 'package:eduera_student/features/profile/presentation/pages/widgets/section_title.dart';
import 'package:flutter/material.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help Center", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primaryDark,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle("Getting Started"),
            SectionText(
              "Learn how to create an account, search for courses, and start learning quickly.",
            ),

            SectionTitle("Course Access & Learning"),
            SectionText(
              "Steps to access purchased courses, resume progress, and complete assignments.",
            ),

            SectionTitle("Mentor Support"),
            SectionText(
              "Ask questions to mentors, understand response times, and follow communication guidelines.",
            ),

            SectionTitle("Payments & Subscriptions"),
            SectionText(
              "Information about payment methods, refunds, and subscription renewals.",
            ),

            SectionTitle("Technical Support"),
            SectionText(
              "Troubleshoot login issues, video playback problems, and app updates.",
            ),

            SectionTitle("Policies & Safety"),
            SectionText(
              "Review our Terms & Conditions, Privacy Policy, and student code of conduct.",
            ),

            SectionTitle("Contact Us"),
            SectionText(
              "Reach out via email or in-app chat for further assistance.",
            ),


          ],
        ),
      ),
    );
  }
}
