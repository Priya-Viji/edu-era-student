import 'package:eduera_student/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:eduera_student/features/auth/presentation/pages/login_page.dart';
import 'package:eduera_student/features/auth/presentation/pages/signup_page.dart';
import 'package:eduera_student/features/home/presentation/pages/home.dart';
import 'package:eduera_student/features/home/presentation/pages/home_page.dart';
import 'package:eduera_student/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';

import 'features/intro/onboarding_screen.dart';
import 'features/intro/splash_screen.dart'; 

class AppRoutes {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String dashboard = '/dashboard';

  static const String profile = '/profile';
  static const String coursesDetails = '/course_details';
  static const String mentor = '/mentor_details';
  static const String youtubeplayer='/youtube_player';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      onboarding: (context) => const OnboardingScreen(),
      login:(context) => const LoginPage(),
      signup:(context) => const SignupPage(),
      forgotPassword:(context) => const ForgotPasswordPage(),
      home:(context) => const Home(),
      //youtubeplayer:(context) => const YoutubePlayerPage(url: '',),
      profile:(context) => const ProfilePage(),
      dashboard:(context) => const HomePage(),
      //coursesDetails:(context) => const CourseDetailPage(),
    };
  }
}