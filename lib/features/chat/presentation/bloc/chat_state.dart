// features/chat/presentation/bloc/chat_state.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_message.dart';

abstract class ChatState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatMessage> messages;

  // typing support (already used by your UI)
  final bool isTyping;

  // message editing
  final String? editingMessageId;
  final String? editingOldText;

  ChatLoaded({
    required this.messages,
    this.isTyping = false,
    this.editingMessageId,
    this.editingOldText,
  });

  ChatLoaded copyWith({
    List<ChatMessage>? messages,
    bool? isTyping,
    String? editingMessageId,
    String? editingOldText,
    bool clearEditing = false,
  }) {
    return ChatLoaded(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      editingMessageId: clearEditing ? null : (editingMessageId ?? this.editingMessageId),
      editingOldText: clearEditing ? null : (editingOldText ?? this.editingOldText),
    );
  }

  @override
  List<Object?> get props => [messages, isTyping, editingMessageId, editingOldText];
}

class ChatError extends ChatState {
  final String message;

  ChatError(this.message);

  @override
  List<Object?> get props => [message];
}
