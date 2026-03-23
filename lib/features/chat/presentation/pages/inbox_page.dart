import 'package:eduera_student/features/chat/presentation/inbox/inbox_bloc.dart';
import 'package:eduera_student/features/chat/presentation/inbox/inbox_event.dart';
import 'package:eduera_student/features/chat/presentation/inbox/inbox_state.dart';
import 'package:eduera_student/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/inbox_item.dart';
import '../../domain/usecases/ensure_chat_exists.dart';
import 'chat_page.dart';

class InboxPage extends StatefulWidget {
  final String studentId;

  const InboxPage({super.key, required this.studentId});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  String searchQuery = "";
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    context.read<InboxBloc>().add(LoadInbox(widget.studentId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey.shade900 : const Color(0xFFF5F7FA),

      // ------------------ APP BAR ------------------
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF43A047), Color(0xFF00ACC1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: isSearching ? _buildSearchField() : _buildTitle(),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) searchQuery = "";
              });
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      // ------------------ BODY ------------------
      body: BlocBuilder<InboxBloc, InboxState>(
        builder: (context, state) {
          if (state is InboxLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Color(0xFF667eea)),
              ),
            );
          }

          if (state is InboxError) {
            return _buildErrorState(state.message);
          }

          if (state is InboxLoaded) {
            final items = searchQuery.isEmpty
                ? state.items
                : state.items
                      .where(
                        (i) =>
                            i.mentorName.toLowerCase().contains(searchQuery) ||
                            i.lastMessage.toLowerCase().contains(searchQuery),
                      )
                      .toList();

            if (items.isEmpty) return _buildEmptyState();

            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: items.length,
              separatorBuilder: (_, _) => Divider(
                height: 1,
                thickness: 1,
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                indent: 88,
              ),
              itemBuilder: (context, index) {
                return _buildModernInboxTile(context, items[index], isDark);
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  // ------------------ TITLE ------------------
  Widget _buildTitle() {
    return const Row(
      children: [
       // Icon(Icons.chat, size: 24),
        SizedBox(width: 12),
        Text(
          "Chat With Mentors",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // ------------------ SEARCH FIELD ------------------
  Widget _buildSearchField() {
    return TextField(
      autofocus: true,
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        hintText: "Search mentors...",
        hintStyle: TextStyle(color: Colors.white70),
        border: InputBorder.none,
      ),
      onChanged: (value) {
        setState(() => searchQuery = value.toLowerCase());
      },
    );
  }

  // ------------------ INBOX TILE ------------------
  Widget _buildModernInboxTile(
    BuildContext context,
    InboxItem item,
    bool isDark,
  ) {
    final hasUnread = item.unreadCount > 0;

    return InkWell(
      onTap: () => _navigateToChat(context, item),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:isDark ? 0.2 : 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar with glow
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: hasUnread
                    ? const LinearGradient(
                        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
              ),
              child: CircleAvatar(
                radius: 28,
                backgroundImage: item.mentorAvatarUrl.isNotEmpty
                    ? NetworkImage(item.mentorAvatarUrl)
                    : null,
                backgroundColor: Colors.grey.shade300,
                child: item.mentorAvatarUrl.isEmpty
                    ? Icon(Icons.person, size: 30, color: Colors.grey.shade600)
                    : null,
              ),
            ),

            const SizedBox(width: 14),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + Time
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.mentorName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: hasUnread
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatTime(item.lastMessageAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: hasUnread
                              ? const Color(0xFF667eea)
                              : Colors.grey.shade500,
                          fontWeight: hasUnread
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Last message + unread badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.lastMessage.isNotEmpty
                              ? item.lastMessage
                              : "Start a conversation 💬",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: hasUnread
                                ? (isDark ? Colors.white70 : Colors.black87)
                                : Colors.grey.shade600,
                            fontWeight: hasUnread
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (hasUnread) ...[
                        const SizedBox(width: 10),
                        _buildUnreadBadge(item.unreadCount),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------ UNREAD BADGE ------------------
  Widget _buildUnreadBadge(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        count > 99 ? "99+" : count.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  // ------------------ EMPTY STATE ------------------
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF667eea).withValues(alpha: 0.1),
                  const Color(0xFF764ba2).withValues(alpha: 0.1),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_search_outlined,
              size: 64,
              color: Color(0xFF667eea),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "No mentors yet",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            "Connect with a mentor to start chatting",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ------------------ ERROR STATE ------------------
  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 64,
            color: Colors.red.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            "Something went wrong",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  // ------------------ NAVIGATE TO CHAT ------------------
  Future<void> _navigateToChat(BuildContext context, InboxItem item) async {
    final ensureChatExists = sl<EnsureChatExists>();

    String finalChatId = item.chatId;

    if (finalChatId.isEmpty) {
      finalChatId = await ensureChatExists(
        studentId: widget.studentId,
        mentorId: item.mentorId,
      );
    }

    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatPage(
          chatId: finalChatId,
          studentId: widget.studentId,
          mentorId: item.mentorId,
          mentorName: item.mentorName,
          mentorAvatarUrl: item.mentorAvatarUrl,
        ),
      ),
    );
  }

  // ------------------ TIME FORMATTER ------------------
  String _formatTime(DateTime? dt) {
    if (dt == null) return "";

    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inDays == 0) {
      final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      return "$hour:$minute $period";
    }

    if (diff.inDays == 1) return "Yesterday";

    if (diff.inDays < 7) {
      const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return weekdays[dt.weekday - 1];
    }

    return "${dt.day}/${dt.month}/${dt.year}";
  }
}
