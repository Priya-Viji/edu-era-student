import 'package:eduera_student/core/constants/colors.dart';
import 'package:eduera_student/features/profile/presentation/pages/widgets/section_title.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
        backgroundColor:  AppColors.primaryDark,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle("1. Information We Collect"),
            SectionText(
              "We may collect your name, email, progress reports, and usage statistics.",
            ),

            SectionTitle("2. How We Use Information"),
            SectionText(
              "Data is used to improve learning experiences, track progress, and provide support.",
            ),

            SectionTitle("3. Data Sharing"),
            SectionText(
              "We do not sell or share your data with third parties except as required by law.",
            ),

            SectionTitle("4. Security"),
            SectionText(
              "We implement reasonable measures to protect your data from unauthorized access.",
            ),

            SectionTitle("5. Children’s Privacy"),
            SectionText(
              "This app is intended for students with proper authorization. Parental consent may be required.",
            ),

            SectionTitle("6. Changes to Policy"),
            SectionText("We may update this Privacy Policy from time to time."),
          ],
        ),
      ),
    );
  }
}
