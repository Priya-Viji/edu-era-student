import 'package:eduera_student/features/chat/presentation/pages/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';

class ChatPage extends StatefulWidget {
  final String chatId;
  final String studentId;
  final String mentorId;
  final String mentorName;
  final String mentorAvatarUrl;

  const ChatPage({
    super.key,
    required this.chatId,
    required this.studentId,
    required this.mentorId,
    required this.mentorName,
    required this.mentorAvatarUrl,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool showSearchBar = false;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(ChatStarted(widget.chatId));
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFEFEFEF),

      // ------------------ APP BAR ------------------
      appBar: AppBar(
        backgroundColor: const Color(0xFF128C7E),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        titleSpacing: 0,
        title: showSearchBar
            ? TextField(
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() => searchQuery = value.toLowerCase());
                },
              )
            : Row(
                children: [
                  CircleAvatar(
                    backgroundImage: widget.mentorAvatarUrl.isNotEmpty
                        ? NetworkImage(widget.mentorAvatarUrl)
                        : null,
                    child: widget.mentorAvatarUrl.isEmpty
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.mentorName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
        actions: [
          IconButton(
            icon: Icon(
              showSearchBar ? Icons.close : Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                showSearchBar = !showSearchBar;
                searchQuery = "";
              });
            },
          ),
        ],
      ),

      // ------------------ BODY ------------------
      body: Column(
        children: [
          // EDITING BANNER
          BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              if (state is ChatLoaded && state.editingMessageId != null) {
                _controller.text = state.editingOldText ?? "";
                _controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: _controller.text.length),
                );

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  color: Colors.orange.shade100,
                  child: Row(
                    children: [
                      const Icon(Icons.edit, size: 18, color: Colors.orange),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Editing: ${state.editingOldText}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () {
                          context.read<ChatBloc>().add(CancelEditingMessage());
                          _controller.clear();
                        },
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // ------------------ MESSAGE LIST ------------------
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                if (state is ChatLoaded) _scrollToBottom();
              },
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ChatLoaded) {
                  final filtered = state.messages
                      .where(
                        (m) => m.message.toLowerCase().contains(searchQuery),
                      )
                      .toList()
                    ..sort((a, b) => a.sentAt.compareTo(b.sentAt)); // oldest → newest

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final msg = filtered[index];
                      final isMe = msg.senderId == widget.studentId;

                      // ------------------ DATE SEPARATOR ------------------
                      bool showDateHeader = false;
                      if (index == 0) {
                        showDateHeader = true;
                      } else {
                        final prev = filtered[index - 1].sentAt;
                        final curr = filtered[index].sentAt;
                        if (prev.day != curr.day ||
                            prev.month != curr.month ||
                            prev.year != curr.year) {
                          showDateHeader = true;
                        }
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (showDateHeader) _buildDateSeparator(msg.sentAt),

                          MessageBubble(
                            msg: msg,
                            isMe: isMe,
                            onEdit: () {
                              context.read<ChatBloc>().add(
                                StartEditingMessage(
                                  messageId: msg.id,
                                  oldText: msg.message,
                                ),
                              );
                            },
                            onDelete: (deleteOption) {
                              if (deleteOption == DeleteOption.forEveryone) {
                                context.read<ChatBloc>().add(
                                  DeleteForEveryone(
                                    chatId: widget.chatId,
                                    messageId: msg.id,
                                  ),
                                );
                              } else {
                                context.read<ChatBloc>().add(
                                  DeleteForMe(
                                    chatId: widget.chatId,
                                    messageId: msg.id,
                                    userId: widget.studentId,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),

          // ------------------ INPUT BAR ------------------
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Message",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    final text = _controller.text.trim();
                    if (text.isEmpty) return;

                    final state = context.read<ChatBloc>().state;

                    if (state is ChatLoaded && state.editingMessageId != null) {
                      context.read<ChatBloc>().add(
                        EditMessage(
                          chatId: widget.chatId,
                          messageId: state.editingMessageId!,
                          newText: text,
                        ),
                      );
                    } else {
                      context.read<ChatBloc>().add(
                        SendTextMessage(
                          chatId: widget.chatId,
                          senderId: widget.studentId,
                          receiverId: widget.mentorId,
                          message: text,
                        ),
                      );
                    }

                    _controller.clear();
                  },
                  child: const CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xFF128C7E),
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------ DATE SEPARATOR WIDGET ------------------
  Widget _buildDateSeparator(DateTime date) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          _formatDate(date),
          style: const TextStyle(fontSize: 12, color: Colors.black87),
        ),
      ),
    );
  }

    String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;

    if (diff == 0) return "Today";
    if (diff == 1) return "Yesterday";

    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }


}
