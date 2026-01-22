import 'package:eduera_student/core/constants/colors.dart';
import 'package:eduera_student/features/profile/presentation/pages/widgets/section_title.dart';
import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms & Conditions", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primaryDark,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle("1. Acceptance of Terms"),
            SectionText(
              "By using this application, you agree to be bound by these Terms and Conditions.",
            ),

            SectionTitle("2. Eligibility"),
            SectionText(
              "Users must be registered students or authorized individuals.",
            ),

            SectionTitle("3. User Accounts"),
            SectionText(
              "You are responsible for maintaining the confidentiality of your login credentials.",
            ),

            SectionTitle("4. Use of the Application"),
            SectionText(
              "The app is provided for educational purposes only. Misuse is prohibited.",
            ),

            SectionTitle("5. Intellectual Property"),
            SectionText(
              "All content and code are the property of [Your App Name].",
            ),

            SectionTitle("6. Privacy"),
            SectionText(
              "We collect and process personal data in accordance with our Privacy Policy.",
            ),

            SectionTitle("7. Payments"),
            SectionText(
              "Subscription fees or course payments must be made through authorized channels.",
            ),

            SectionTitle("8. Limitation of Liability"),
            SectionText(
              "The app is provided 'as is' without warranties of any kind.",
            ),

            SectionTitle("9. Termination"),
            SectionText(
              "We reserve the right to suspend or terminate accounts that violate these Terms.",
            ),

            SectionTitle("10. Governing Law"),
            SectionText(
              "These Terms are governed by the laws of [Your Country/Region].",
            ),

            SectionTitle("11. Changes to Terms"),
            SectionText("We may update these Terms from time to time."),
          ],
        ),
      ),
    );
  }
}
