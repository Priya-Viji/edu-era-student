import 'package:eduera_student/core/constants/colors.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primaryDark,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle("Welcome to EduEra"),
            SectionText(
              "Our e-learning platform is designed to help students discover, "
              "enroll, and study courses in their favorite categories. "
              "We believe learning should be simple, accessible, and guided.",
            ),

            SectionTitle("How It Works"),
            SectionText(
              "1. Search your favorite category.\n"
              "2. Explore courses tailored to your interests.\n"
              "3. Buy the course securely.\n"
              "4. Study at your own pace with interactive content.\n"
              "5. Ask questions directly to mentors whenever you need help.",
            ),

            SectionTitle("Mentor Support"),
            SectionText(
              "Our mentors are available to guide you through your learning journey. "
              "Whenever you have doubts, you can connect with a mentor for clear, "
              "personalized explanations.",
            ),

            SectionTitle("Our Mission"),
            SectionText(
              "We aim to empower students by providing high-quality courses, "
              "easy access to mentors, and a delightful learning experience.",
            ),

            SectionTitle("Why Choose Us"),
            SectionText(
              "Wide range of categories\n"
              "Affordable and secure course purchases\n"
              "Learn anytime, anywhere\n"
              "Dedicated mentor support\n"
              "Progress tracking and personalized recommendations",
            ),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color:  AppColors.primaryDark,
        ),
      ),
    );
  }
}

class SectionText extends StatelessWidget {
  final String text;
  const SectionText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontSize: 14, height: 1.5));
  }
}
