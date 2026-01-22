import 'package:eduera_student/app_routes.dart';
import 'package:eduera_student/features/auth/domain/usecases/sign_in.dart';
import 'package:eduera_student/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:eduera_student/features/auth/domain/usecases/sign_up.dart';
import 'package:eduera_student/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:eduera_student/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:eduera_student/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:eduera_student/features/chat/presentation/inbox/inbox_bloc.dart';
import 'package:eduera_student/features/home/data/repositories/home_repository.dart';
import 'package:eduera_student/features/home/presentation/bloc/category/category_bloc.dart';
import 'package:eduera_student/features/home/presentation/bloc/course_bloc.dart';
import 'package:eduera_student/features/home/presentation/bloc/course_event.dart';
import 'package:eduera_student/features/home/presentation/bloc/mentor_bloc/mentor_bloc.dart';
import 'package:eduera_student/features/intro/splash_screen.dart';
import 'package:eduera_student/features/payment/presentation/bloc/enrollment/enrollment_bloc.dart';
import 'package:eduera_student/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:eduera_student/features/payment/presentation/bloc/course_progress_bloc/lesson_progress_bloc.dart';
import 'package:eduera_student/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:eduera_student/features/reviews/presentation/bloc/review_bloc.dart';
import 'package:eduera_student/injection_container.dart';
import 'package:eduera_student/services/student_notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/theme_bloc.dart';

// Top-level background handler
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
 // print("BACKGROUND MESSAGE: ${message.notification?.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await init(); // Dependency Injection

  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _notificationService = StudentNotificationService();

  @override
  void initState() {
    super.initState();
    _initializeNotificationsIfLoggedIn();
  }

  Future<void> _initializeNotificationsIfLoggedIn() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await _notificationService.init(user.uid);

      await _notificationService.checkInitialMessage((courseId) {
        Navigator.pushNamed(context, "/courseDetails", arguments: courseId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) =>
              AuthBloc(sl<SignIn>(), sl<SignUp>(), sl<SignInWithGoogle>()),
        ),
        BlocProvider<CourseBloc>(
          create: (_) => sl<CourseBloc>()..add(LoadCoursesEvent()),
        ),
        BlocProvider<CategoryBloc>(
          create: (_) =>
              CategoryBloc(sl<HomeRepository>())..add(LoadCategoriesEvent()),
        ),
        BlocProvider<MentorBloc>(
          create: (_) => MentorBloc(sl())..add(LoadMentorsEvent()),
        ),
        BlocProvider<PaymentBloc>(create: (_) => sl<PaymentBloc>()),
        BlocProvider<EnrollmentBloc>(create: (_) => sl<EnrollmentBloc>()),
        BlocProvider<ReviewBloc>(create: (_) => sl<ReviewBloc>()),
        BlocProvider<BookmarkBloc>(create: (_) => sl<BookmarkBloc>()),
        BlocProvider<ProfileBloc>(create: (_) => sl<ProfileBloc>()),
        BlocProvider<ThemeBloc>(create: (_) => sl<ThemeBloc>()),
         BlocProvider<ChatBloc>(create: (_) => sl<ChatBloc>()),
        BlocProvider<InboxBloc>(create: (_) => sl<InboxBloc>()),
        BlocProvider(create: (_) => sl<LessonProgressBloc>()),
      ],

      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'EduEra',
            debugShowCheckedModeBanner: false,
            home: const SplashScreen(),
            routes: AppRoutes.getRoutes(),
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          );
        },
      ),
    );
  }
}
