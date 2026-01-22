import 'package:eduera_student/features/payment/domain/repositories/enroll_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'inbox_event.dart';
import 'inbox_state.dart';
import '../../domain/entities/inbox_item.dart';

class InboxBloc extends Bloc<InboxEvent, InboxState> {
  final EnrollRepository enrollmentRepo;
  final FirebaseFirestore firestore;

  InboxBloc({required this.enrollmentRepo, required this.firestore})
    : super(InboxLoading()) {
    on<LoadInbox>(_onLoadInbox);
  }

  Future<void> _onLoadInbox(
    LoadInbox event,
    Emitter<InboxState> emit,
  ) async {
    emit(InboxLoading());

    try {
      // 1. Fetch enrollments
      final enrollments = await enrollmentRepo.getEnrolledCourses(
        event.studentId,
      );

      final List<InboxItem> items = [];

      for (var enroll in enrollments) {
        // 2. Fetch mentor profile
        final mentorDoc = await firestore
            .collection('mentor_profiles')
            .doc(enroll.mentorId)
            .get();

        final mentor = mentorDoc.data() ?? {};

        // 3. Check if chat exists
        final chatQuery = await firestore
            .collection('chats')
            .where('studentId', isEqualTo: event.studentId)
            .where('mentorId', isEqualTo: enroll.mentorId)
            .get();

        String chatId = '';
        String lastMessage = '';
        DateTime? lastMessageAt;
        int unreadCount = 0;

        if (chatQuery.docs.isNotEmpty) {
          final chat = chatQuery.docs.first;
          chatId = chat.id;
          lastMessage = chat['lastMessage'] ?? '';
          lastMessageAt = (chat['lastMessageAt'] as Timestamp?)?.toDate();

          // unread count
          final unreadQuery = await firestore
              .collection('chats')
              .doc(chatId)
              .collection('messages')
              .where('receiverId', isEqualTo: event.studentId)
              .where('isRead', isEqualTo: false)
              .get();

          unreadCount = unreadQuery.docs.length;
        }

        // 4. Add to inbox list
        items.add(
          InboxItem(
            chatId: chatId,
            mentorId: enroll.mentorId,
            mentorName: mentor['name'] ?? 'Unknown Mentor',
            mentorAvatarUrl: mentor['profilePic'] ?? '',
            lastMessage: lastMessage,
            lastMessageAt: lastMessageAt,
            unreadCount: unreadCount,
          ),
        );
      }

      emit(InboxLoaded(items));
    } catch (e) {
      emit(InboxError(e.toString()));
    }
  }
}
