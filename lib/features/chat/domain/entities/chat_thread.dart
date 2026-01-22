class ChatThread {
  final String chatId; // Firestore doc ID: studentId_mentorId
  final String studentId;
  final String studentName;
  final String studentAvatarUrl;
  final String mentorId;
  final String mentorName;
  final String mentorAvatarUrl;
  final String? lastMessage;
  final DateTime? lastMessageAt;

  ChatThread({
    required this.chatId,
    required this.studentId,
    required this.studentName,
    required this.studentAvatarUrl,
    required this.mentorId,
    required this.mentorName,
    required this.mentorAvatarUrl,
    this.lastMessage,
    this.lastMessageAt,
  });
}
