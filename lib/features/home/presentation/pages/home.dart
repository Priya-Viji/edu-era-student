import 'package:eduera_student/features/bookmark/presentation/pages/my_bookmark_page.dart';
import 'package:eduera_student/features/chat/presentation/inbox/inbox_bloc.dart';
import 'package:eduera_student/features/chat/presentation/inbox/inbox_event.dart';
import 'package:eduera_student/features/chat/presentation/pages/inbox_page.dart';
import 'package:eduera_student/features/home/presentation/pages/home_page.dart';
import 'package:eduera_student/features/payment/presentation/pages/my_courses_page.dart';
import 'package:eduera_student/features/profile/presentation/pages/profile_page.dart';
import 'package:eduera_student/features/widgets/bottom_nav_bar.dart';
import 'package:eduera_student/injection_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  late final List<Widget> _pages;
  late final String studentId;

  @override
  void initState() {
    super.initState();
    studentId = FirebaseAuth.instance.currentUser!.uid;
    
    _pages = [
      const HomePage(), // index 0
      const MyCoursesPage(),

     // FIX: Use InboxBloc + LoadInbox 
     BlocProvider( create: (_) => sl<InboxBloc>()..add(LoadInbox(studentId)), child: InboxPage(studentId: studentId), ),

      const MyBookmarkPage(),
      const ProfilePage(), // index 3
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // show selected page
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // update selected tab
          });
        },
      ),
    );
  }
}
