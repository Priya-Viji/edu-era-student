import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ChatRemoteDataSource {
  Stream<QuerySnapshot> watchStudentInbox(String studentId);
  Stream<QuerySnapshot> watchMessages(String chatId);

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String message, 
  });

  Future<String> ensureChatExists({
    required String studentId,
    required String mentorId,
  });

  Future<void> setTyping({
    required String chatId,
    required bool isStudentTyping, 
    required bool isMentorTyping, 
  });

  Future<void> markMessagesAsRead({
    required String chatId,
    required String userId,
  });

  Future<void> deleteMessageForEveryone({
    required String chatId,
    required String messageId,
  });

  Future<void> deleteMessageForMe({
    required String chatId,
    required String messageId,
    required String userId,
  });
}



class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore firestore;

  ChatRemoteDataSourceImpl(this.firestore);

  @override
  Stream<QuerySnapshot> watchStudentInbox(String studentId) {
    return firestore
        .collection('chats')
        .where('studentId', isEqualTo: studentId)
        .orderBy('lastMessageAt', descending: true)
        .snapshots();
  }

  @override
  Stream<QuerySnapshot> watchMessages(String chatId) {
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt')
        .snapshots();
  }

  @override
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String message, 
  }) async {
    final messageRef = firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc();

    await messageRef.set({
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message, 
      'sentAt': FieldValue.serverTimestamp(),
      'createdAt': DateTime.now(),
      'isRead': false,
    });

    await firestore.collection('chats').doc(chatId).update({
      'lastMessage': message, 
      'lastMessageAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<String> ensureChatExists({
    required String studentId,
    required String mentorId,
  }) async {
    final query = await firestore
        .collection('chats')
        .where('studentId', isEqualTo: studentId)
        .where('mentorId', isEqualTo: mentorId)
        .get();

    if (query.docs.isNotEmpty) {
      return query.docs.first.id;
    }

    final mentorDoc = await firestore
        .collection('mentor_profiles')
        .doc(mentorId)
        .get();
    final data = mentorDoc.data() ?? {};
    final mentorName = data['name'] ?? 'Unknown Mentor';
    final mentorAvatarUrl = data['profilePic'] ?? '';

    final studentDoc=await firestore.collection('students').doc(studentId).get();
    final studentData=studentDoc.data() ??{};
    final studentName= studentData['name'] ?? 'Unknow Student';
    final studentAvatarUrl = studentData['profileImageUrl'] ?? '';

    final docRef = await firestore.collection('chats').add({
      'studentId': studentId,
      'studentName':studentName,
      'studentAvatarUrl' :studentAvatarUrl,
      'mentorId': mentorId,
      'mentorName': mentorName,
      'mentorAvatarUrl': mentorAvatarUrl,
      'lastMessage': null,
      'lastMessageAt': FieldValue.serverTimestamp(),
      'isStudentTyping': false,
      'isMentorTyping': false,
    });

    return docRef.id;
  }

  @override
  Future<void> setTyping({
    required String chatId,
    required bool isStudentTyping, 
    required bool isMentorTyping, 
  }) async {
    await firestore.collection('chats').doc(chatId).update({
      'isStudentTyping': isStudentTyping,
      'isMentorTyping': isMentorTyping,
    });
  }

  @override
  Future<void> markMessagesAsRead({
    required String chatId,
    required String userId,
  }) async {
    final unreadMessages = await firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('receiverId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    for (var doc in unreadMessages.docs) {
      await doc.reference.update({'isRead': true});
    }
  }

  @override
  Future<void> deleteMessageForEveryone({
    required String chatId,
    required String messageId,
  }) async {
    final ref = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId);

    await ref.update({'deletedForEveryone': true});
  }

  @override
  Future<void> deleteMessageForMe({
    required String chatId,
    required String messageId,
    required String userId,
  }) async {
    final ref = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId);

    await ref.update({
      'deletedFor': FieldValue.arrayUnion([userId]),
    });
  }

}
