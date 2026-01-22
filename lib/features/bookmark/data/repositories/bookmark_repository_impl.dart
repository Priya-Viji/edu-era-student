import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/bookmark_repository.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  final FirebaseFirestore firestore;
  BookmarkRepositoryImpl(this.firestore);

  @override
  Future<bool> isBookmarked({
    required String userId,
    required String courseId,
  }) async {
    final doc = await firestore
        .collection('bookmarks')
        .doc('${userId}_$courseId')
        .get();
    return doc.exists;
  }

  @override
  Future<void> addBookmark({
    required String userId,
    required String courseId,
  }) async {
    await firestore.collection('bookmarks').doc('${userId}_$courseId').set({
      'userId': userId,
      'courseId': courseId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> removeBookmark({
    required String userId,
    required String courseId,
  }) async {
    await firestore.collection('bookmarks').doc('${userId}_$courseId').delete();
  }

  @override
  Future<List<String>> getBookmarkedCourseIds({required String userId}) async {
    final snap = await firestore
        .collection('bookmarks')
        .where('userId', isEqualTo: userId)
        .get();

    return snap.docs.map((doc) => doc['courseId'] as String).toList();
  }
}
