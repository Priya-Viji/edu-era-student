import 'package:eduera_student/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> pages = [
    {
      'image': 'assets/images/onboarding_1.jpg',
      'title': 'Welcome to EDUERA',
      'desc':
          'Start your learning journey with confidence. EDUERA helps you grow, step by step.',
    },
    {
      'image': 'assets/images/onboarding_2.jpg',
      'title': 'Learn Your Way',
      'desc':
          'Pick your path and learn at your own speed. Short lessons, easy tools, and clear progress.',
    },
    {
      'image': 'assets/images/onboarding_3.jpg',
      'title': 'Support That Lifts You Up',
      'desc':
          'Get help from mentors and guides. Ask questions, stay motivated, and keep moving forward.',
    },
  ];

  void _onNext() {
    if (currentIndex < pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onSkip() {
    _pageController.jumpToPage(pages.length - 1);
  }

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            onPageChanged: (index) => setState(() => currentIndex = index),
            itemBuilder: (_, index) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                   Container(
                          height: 300,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.15),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      pages[index]['image']!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Text(
                  pages[index]['title']!,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    pages[index]['desc']!,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: currentIndex == pages.length - 1
                ? ElevatedButton(
                    onPressed: _finishOnboarding,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // button color
                      minimumSize: const Size.fromHeight(55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(onPressed: _onSkip, child: const Text('SKIP')),
                      Row(
                        children: List.generate(
                          pages.length,
                          (index) => Container(
                            margin: const EdgeInsets.all(4),
                            width: currentIndex == index ? 12 : 8,
                            height: currentIndex == index ? 12 : 8,
                            decoration: BoxDecoration(
                              color: currentIndex == index
                                  ? Colors.green
                                  : Colors.grey.shade400,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      TextButton(onPressed: _onNext, child: const Text('NEXT')),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
