abstract class InboxEvent {}

class LoadInbox extends InboxEvent {
  final String studentId;
  LoadInbox(this.studentId);
}

class InboxUpdated extends InboxEvent {
  final List inbox; // List<ChatThread> or List<InboxItem>
  InboxUpdated(this.inbox);
}
