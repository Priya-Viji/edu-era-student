import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduera_student/features/payment/data/model/enroll_model.dart';

abstract class EnrollRemoteDataSource {
  Future<void> saveEnrollment(EnrollModel model);
  Future<bool> isEnrolled(String studentId, String courseId);
  Future<List<EnrollModel>> getEnrolledCourses(String studentId);

  // Progress tracking
  Future<void> markSublessonCompleted({
    required String studentId,
    required String courseId,
    required String sublessonId,
  });

  Stream<List<String>> watchCompletedSublessons({
    required String studentId,
    required String courseId,
  });

  Future<void> markCourseCompleted({
    required String studentId,
    required String courseId,
  });
}

class EnrollRemoteDataSourceImpl implements EnrollRemoteDataSource {
  final FirebaseFirestore firestore;
  EnrollRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> saveEnrollment(EnrollModel enrollment) async {
    final enrollmentId = "${enrollment.studentId}_${enrollment.courseId}";

    await firestore
        .collection('enrollments')
        .doc(enrollmentId)
        .set(enrollment.toMap(), SetOptions(merge: true));
  }

  @override
  Future<bool> isEnrolled(String studentId, String courseId) async {
    final enrollmentId = "${studentId}_$courseId";

    final doc = await firestore
        .collection('enrollments')
        .doc(enrollmentId)
        .get();

    return doc.exists;
  }

  @override
  Future<List<EnrollModel>> getEnrolledCourses(String studentId) async {
    final snapshot = await firestore
        .collection('enrollments')
        .where('studentId', isEqualTo: studentId)
        .get();

    return snapshot.docs.map((doc) => EnrollModel.fromMap(doc.data())).toList();
  }

  // -----------------------------
  // PROGRESS TRACKING
  // -----------------------------

  @override
  Future<void> markSublessonCompleted({
    required String studentId,
    required String courseId,
    required String sublessonId,
  }) async {
    final ref = firestore
        .collection("enrollments")
        .doc("${studentId}_$courseId");

    await firestore.runTransaction((tx) async {
      final snap = await tx.get(ref);
      final data = snap.data() ?? {};

      final list = List<String>.from(data["completedSubLessons"] ?? []);

      if (!list.contains(sublessonId)) {
        list.add(sublessonId);
      }

      tx.set(ref, {"completedSubLessons": list}, SetOptions(merge: true));
    });
  }

  @override
  Stream<List<String>> watchCompletedSublessons({
    required String studentId,
    required String courseId,
  }) {
    return firestore
        .collection("enrollments")
        .doc("${studentId}_$courseId")
        .snapshots()
        .map((snap) {
          final data = snap.data();
          if (data == null) return <String>[];
          return List<String>.from(data["completedSubLessons"] ?? []);
        });
  }

@override
  Future<void> markCourseCompleted({
    required String studentId,
    required String courseId,
  }) async {
    await firestore.collection("enrollments").doc("${studentId}_$courseId").set(
      {
        "isCourseCompleted": true,
        "status": "completed", // update status here
      },
      SetOptions(merge: true),
    );
  }

}
