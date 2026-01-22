import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';

class StudentNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init(String studentId) async {
    // Ask permission
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    // Save token
    await _saveToken(studentId);

    // Listen for token refresh
    _messaging.onTokenRefresh.listen((newToken) {
      FirebaseDatabase.instance.ref("students/$studentId").update({
        "fcmToken": newToken,
      });
     // print("Token refreshed: $newToken");
    });

    // Foreground messages
    FirebaseMessaging.onMessage.listen((message) {
     // print("FOREGROUND: ${message.notification?.title}");
     // print("DATA: ${message.data}");
    });

    // Background tap
    FirebaseMessaging.onMessage.listen((message) {
      print("FOREGROUND: ${message.notification?.title}");
      print("DATA: ${message.data}");
    });
    
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final courseId = message.data["courseId"];
      if (courseId != null) {
        print("Tapped notification → Course: $courseId");
        // Navigation handled in main.dart via callback
      }
    });
  }

  Future<void> _saveToken(String studentId) async {
    final token = await _messaging.getToken();
    if (token != null) {
      await FirebaseDatabase.instance.ref("students/$studentId").update({
        "fcmToken": token,
      });
      print("Token saved: $token");
    }
  }

  Future<void> checkInitialMessage(Function(String) onCourseTap) async {
    final message = await _messaging.getInitialMessage();
    if (message != null) {
      final courseId = message.data["courseId"];
      if (courseId != null) onCourseTap(courseId);
    }
  }
}
