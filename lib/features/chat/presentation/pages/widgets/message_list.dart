// import 'package:eduera_student/features/chat/presentation/bloc/chat_bloc.dart';
// import 'package:eduera_student/features/chat/presentation/bloc/chat_state.dart';
// import 'package:eduera_student/features/chat/presentation/pages/widgets/message_bubble.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class MessageList extends StatelessWidget {
//     final ScrollController scrollController;
//   final String currentUserId;
//   const MessageList({ super.key,
//     required this.scrollController,
//     required this.currentUserId,});

//   @override
//   Widget build(BuildContext context) {
   
//     return BlocBuilder<ChatBloc, ChatState>(
//       builder: (_, state) {
//         if (state is ChatLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (state is ChatLoaded) {
//           final messages = state.messages.reversed.toList();
//           return ListView.builder(
//             controller: scrollController,
//             padding: const EdgeInsets.all(10),
//             itemCount: messages.length,
//             itemBuilder: (_, index) {
//               final msg = messages[index];
//               final isMe = msg.senderId == currentUserId;
//               return MessageBubble(message: msg, isMe: isMe);
//             },
//           );
//         }
//         return const SizedBox();
//       },
//     );
//   }
// }
