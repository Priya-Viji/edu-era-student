import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_message.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Start watching messages
class ChatStarted extends ChatEvent {
  final String chatId;

  ChatStarted(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

// When new messages arrive
class MessagesUpdated extends ChatEvent {
  final List<ChatMessage> messages;

  MessagesUpdated(this.messages);

  @override
  List<Object?> get props => [messages];
}

// SEND MESSAGE EVENT
class SendTextMessage extends ChatEvent {
  final String chatId;
  final String senderId;
  final String receiverId;
  final String message; // ✅ MUST BE message

  SendTextMessage({
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.message,
  });

  @override
  List<Object?> get props => [chatId, senderId, receiverId, message];
}


// TYPING EVENT
class SetTypingEvent extends ChatEvent {
  final String chatId;
  final bool isStudentTyping; // ✅ MUST BE isStudentTyping
  final bool isMentorTyping; // ✅ MUST BE isMentorTyping

  SetTypingEvent({
    required this.chatId,
    required this.isStudentTyping,
    required this.isMentorTyping,
  });

  @override
  List<Object?> get props => [chatId, isStudentTyping, isMentorTyping];
}

// MARK READ EVENT
class MarkAllAsRead extends ChatEvent {
  final String chatId;
  final String userId;

  MarkAllAsRead({required this.chatId, required this.userId});

  @override
  List<Object?> get props => [chatId, userId];
}

// NEW: start editing a message (UI-level)
class StartEditingMessage extends ChatEvent {
  final String messageId;
  final String oldText;

  StartEditingMessage({required this.messageId, required this.oldText});
}


// NEW: cancel editing
class CancelEditingMessage extends ChatEvent {}

// NEW: confirm edit (save to Firestore)
class EditMessage extends ChatEvent {
  final String chatId;
  final String messageId;
  final String newText;

  EditMessage({
    required this.chatId,
    required this.messageId,
    required this.newText,
  });
}
class DeleteForEveryone extends ChatEvent {
  final String chatId;
  final String messageId;

  DeleteForEveryone({required this.chatId, required this.messageId});
}


class DeleteForMe extends ChatEvent {
  final String chatId;
  final String messageId;
  final String userId; 

  DeleteForMe({
    required this.chatId,
    required this.messageId,
    required this.userId,
  });
}