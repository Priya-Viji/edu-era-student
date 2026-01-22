import '../../domain/entities/inbox_item.dart';

abstract class InboxState {}

class InboxLoading extends InboxState {}

class InboxLoaded extends InboxState {
  final List<InboxItem> items;

  InboxLoaded(this.items);
}

class InboxError extends InboxState {
  final String message;

  InboxError(this.message);
}
