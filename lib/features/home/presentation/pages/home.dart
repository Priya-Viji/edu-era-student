import 'package:eduera_student/features/bookmark/presentation/pages/my_bookmark_page.dart';
import 'package:eduera_student/features/chat/presentation/inbox/inbox_bloc.dart';
import 'package:eduera_student/features/chat/presentation/inbox/inbox_event.dart';
import 'package:eduera_student/features/chat/presentation/pages/inbox_page.dart';
import 'package:eduera_student/features/home/presentation/pages/home_page.dart';
import 'package:eduera_student/features/payment/presentation/pages/my_courses_page.dart';
import 'package:eduera_student/features/profile/presentation/pages/profile_page.dart';
import 'package:eduera_student/injection_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   int _currentIndex = 0;
//   late final List<Widget> _pages;
//   late final String studentId;

//   @override
//   void initState() {
//     super.initState();
//     studentId = FirebaseAuth.instance.currentUser!.uid;
    
//     _pages = [
//       const HomePage(), // index 0
//       const MyCoursesPage(),

//      // FIX: Use InboxBloc + LoadInbox 
//      BlocProvider( create: (_) => sl<InboxBloc>()..add(LoadInbox(studentId)), child: InboxPage(studentId: studentId), ),

//       const MyBookmarkPage(),
//       const ProfilePage(), // index 3
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_currentIndex], // show selected page
//       bottomNavigationBar: CustomBottomNavBar(
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index; // update selected tab
//           });
//         },
//       ),
//     );
//   }
// }

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late TabController _tabController;
  late String studentId;

  @override
  void initState() {
    super.initState();
    studentId = FirebaseAuth.instance.currentUser!.uid;

    // 5 tabs
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MotionTabBar(
        labels: const ["Home", "Courses", "Inbox", "Bookmarks", "Profile"],
        icons: const [
          Icons.home,
          Icons.school,
          Icons.message,
          Icons.bookmark,
          Icons.person,
        ],
        initialSelectedTab: "Home", // REQUIRED
        tabSize: 50,
        tabBarHeight: 55,
        textStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        tabIconColor: Colors.grey,
        tabIconSelectedColor: Colors.green,
        tabSelectedColor: Colors.green[100],
        tabBarColor: Colors.white,
        onTabItemSelected: (int index) {
          setState(() {
            _tabController.index = index;
          });
        },
      ),
      body:TabBarView(
        controller: _tabController,
        children: <Widget>[
          const HomePage(),
          const MyCoursesPage(),
          BlocProvider(
            create: (_) => sl<InboxBloc>()..add(LoadInbox(studentId)),
            child: InboxPage(studentId: studentId),
          ),
          const MyBookmarkPage(),
          const ProfilePage(),
        ],
      ),
    );
  }
}
