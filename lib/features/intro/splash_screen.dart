import 'package:eduera_student/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    // Fade animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 4));

    final pref = await SharedPreferences.getInstance();
    final seenOnboarding = pref.getBool('seenOnboarding') ?? false;

    if (!mounted) return;
    FirebaseAuth.instance.authStateChanges().first.then((user) {
      if (!mounted) return;
      if (user != null) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else if (seenOnboarding) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double titleSize = screenWidth * 0.12; // Responsive title
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            // colors: [
            //   Color(0xFF4C6EF5), // Indigo Blue
            //   Color(0xFF7950F2), // Soft Purple
            // ],
colors: [Color(0xFF43A047), Color(0xFF00ACC1)]

          ),
        ),
        child: FadeTransition(
          opacity: _fade,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'EduEra',
                style: GoogleFonts.bitter(
                  fontSize: titleSize.clamp(70, 80),
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              // Tagline
              Text(
                'Learn • Grow • Succeed',
                style: GoogleFonts.tangerine(
                  fontSize: 35,
                  color: Colors.white.withValues(alpha: 0.85),
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.8,
                ),
              ),

              const SizedBox(height: 60),

              // Progress Indicator
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
