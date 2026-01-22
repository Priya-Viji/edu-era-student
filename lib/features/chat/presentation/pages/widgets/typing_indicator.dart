import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TypingIndicator extends StatelessWidget {
   final String conversationId;
  final bool isMentor;
  const TypingIndicator({  super.key,
    required this.conversationId,
    required this.isMentor,});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('conversations')
          .doc(conversationId)
          .snapshots(),
      builder: (_, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        final data = snapshot.data!.data() as Map<String, dynamic>;
        final typing = isMentor
            ? data['studentTyping'] ?? false
            : data['mentorTyping'] ?? false;

        if (!typing) return const SizedBox();
        return const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Typing...",
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        );
      },
    );
  }
}