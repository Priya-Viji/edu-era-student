import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';

class StudentNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Call this when student logs in
  Future<void> saveToken(String studentId) async {
    final token = await _messaging.getToken();
    if (token != null) {
      await FirebaseDatabase.instance.ref("students/$studentId").update({
        "fcmToken": token,
      });
    }

    // Listen for token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      FirebaseDatabase.instance.ref("students/$studentId").update({
        "fcmToken": newToken,
      });
    });
  }

  /// Foreground message listener
  void listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
     //print("Foreground Notification: ${message.notification?.title}");
    });
  }

  /// When app is opened from background by tapping notification
  void listenBackgroundTap(Function(String courseId) onCourseTap) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final courseId = message.data["courseId"];
      if (courseId != null) {
        onCourseTap(courseId);
      }
    });
  }

  /// When app is opened from terminated state by tapping notification
  Future<void> checkInitialMessage(
    Function(String courseId) onCourseTap,
  ) async {
    final message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      final courseId = message.data["courseId"];
      if (courseId != null) {
        onCourseTap(courseId);
      }
    }
  }
}
