import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduera_student/features/chat/domain/usecases/delete_message_for_everyone.dart';
import 'package:eduera_student/features/chat/domain/usecases/delete_message_for_me.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/usecases/watch_messages.dart';
import '../../domain/usecases/send_message.dart';
import '../../domain/usecases/set_typing.dart';
import '../../domain/usecases/mark_messages_as_read.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final WatchMessages watchMessages;
  final SendMessage sendMessage;
  final SetTyping setTyping;
  final MarkMessagesAsRead markMessagesAsRead;
  final DeleteMessageForEveryone deleteMessageForEveryone;
  final DeleteMessageForMe deleteMessageForMe;

  StreamSubscription<List<ChatMessage>>? _messagesSub;

  ChatBloc({
    required this.watchMessages,
    required this.sendMessage,
    required this.setTyping,
    required this.markMessagesAsRead,
    required this.deleteMessageForEveryone,
    required this.deleteMessageForMe,
  }) : super(ChatInitial()) {
    on<ChatStarted>(_onChatStarted);
    on<MessagesUpdated>(_onMessagesUpdated);
    on<SendTextMessage>(_onSendTextMessage);
    on<SetTypingEvent>(_onSetTyping);
    on<MarkAllAsRead>(_onMarkAllAsRead);
    on<StartEditingMessage>(_onStartEditingMessage);
    on<CancelEditingMessage>(_onCancelEditingMessage);
    on<EditMessage>(_onEditMessage);

    // delete
    on<DeleteForEveryone>(_onDeleteForEveryone);
    on<DeleteForMe>(_onDeleteForMe);
  }

  Future<void> _onChatStarted(
    ChatStarted event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());

    await _messagesSub?.cancel();
    _messagesSub = watchMessages(event.chatId).listen(
      (messages) {
        // print("MESSAGES RECEIVED: $messages");
        add(MessagesUpdated(messages));
      },
      onError: (e) {
        // print("ERROR IN STREAM: $e");
        emit(ChatError(e.toString()));
      },
    );
  }

  void _onMessagesUpdated(MessagesUpdated event, Emitter<ChatState> emit) {
    final sorted = [...event.messages]
      ..sort((a, b) => a.sentAt.compareTo(b.sentAt));

    if (state is ChatLoaded) {
      emit((state as ChatLoaded).copyWith(messages: sorted));
    } else {
      emit(ChatLoaded(messages: sorted));
    }
  }

  Future<void> _onSendTextMessage(
    SendTextMessage event,
    Emitter<ChatState> emit,
  ) async {
    await sendMessage(
      chatId: event.chatId,
      senderId: event.senderId,
      receiverId: event.receiverId,
      message: event.message,
    );
  }

  Future<void> _onSetTyping(
    SetTypingEvent event,
    Emitter<ChatState> emit,
  ) async {
    await setTyping(
      chatId: event.chatId,
      isStudentTyping: event.isStudentTyping,
      isMentorTyping: event.isMentorTyping,
    );
  }

  Future<void> _onMarkAllAsRead(
    MarkAllAsRead event,
    Emitter<ChatState> emit,
  ) async {
    await markMessagesAsRead(chatId: event.chatId, userId: event.userId);
  }

  // ------------------- START EDITING -------------------
  void _onStartEditingMessage(
    StartEditingMessage event,
    Emitter<ChatState> emit,
  ) {
    if (state is! ChatLoaded) return;

    emit(
      (state as ChatLoaded).copyWith(
        editingMessageId: event.messageId,
        editingOldText: event.oldText,
      ),
    );
  }

  // ------------------- CANCEL EDITING -------------------
  void _onCancelEditingMessage(
    CancelEditingMessage event,
    Emitter<ChatState> emit,
  ) {
    if (state is! ChatLoaded) return;

    emit(
      (state as ChatLoaded).copyWith(clearEditing: true),
    );
  }

  // ------------------- CONFIRM EDIT -------------------
  Future<void> _onEditMessage(
    EditMessage event,
    Emitter<ChatState> emit,
  ) async {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(event.chatId)
        .collection('messages')
        .doc(event.messageId)
        .update({'message': event.newText, 'edited': true});

    if (state is ChatLoaded) {
      emit(
        (state as ChatLoaded).copyWith(clearEditing: true),
      );
    }
  }

  // ------------------- DELETE FOR EVERYONE -------------------
  Future<void> _onDeleteForEveryone(
    DeleteForEveryone event,
    Emitter<ChatState> emit,
  ) async {
    await deleteMessageForEveryone(
      chatId: event.chatId,
      messageId: event.messageId,
    );
  }

  // ------------------- DELETE FOR ME -------------------
  Future<void> _onDeleteForMe(
    DeleteForMe event,
    Emitter<ChatState> emit,
  ) async {
    await deleteMessageForMe(
      chatId: event.chatId,
      messageId: event.messageId,
      userId: event.userId,
    );
  }

  @override
  Future<void> close() {
    _messagesSub?.cancel();
    return super.close();
  }
}
