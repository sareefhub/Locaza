import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ChatDetailScreen extends StatefulWidget {
  final String chatId;
  final String currentUserId;
  final String otherUserId;
  final String? avatarUrl;

  const ChatDetailScreen({
    super.key,
    required this.chatId,
    required this.currentUserId,
    required this.otherUserId,
    this.avatarUrl,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> mockMessages = [
    {
      "text": "สวัสดีครับ สนใจสินค้านี้อยู่ไหม?",
      "senderId": "2",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 30)),
    },
    {
      "text": "ใช่ครับ อยากสอบถามรายละเอียดเพิ่ม",
      "senderId": "1",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 25)),
    },
    {
      "text": "ได้เลยครับ ของแท้ 100% ส่งฟรี",
      "senderId": "2",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 20)),
    },
  ];

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      mockMessages.add({
        "text": message,
        "senderId": widget.currentUserId,
        "timestamp": DateTime.now(),
      });
    });

    _messageController.clear();
    _scrollToBottom();
  }

  String formatDateHeader(DateTime date) {
    return DateFormat('d MMM yyyy', 'th').format(date);
  }

  String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F3F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFC9E1E6),
        elevation: 0,
        leading: IconButton(
          icon: Image.asset('assets/icons/angle-small-left.png', width: 24, height: 24),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.avatarUrl != null ? NetworkImage(widget.avatarUrl!) : null,
              child: widget.avatarUrl == null ? const Icon(Icons.person) : null,
            ),
            const SizedBox(width: 12),
            Text(
              widget.otherUserId,
              style: GoogleFonts.sarabun(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Color(0xFF062252)),
        titleTextStyle: GoogleFonts.sarabun(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF062252),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              itemCount: mockMessages.length,
              itemBuilder: (context, index) {
                final msg = mockMessages[index];
                final text = msg['text'];
                final senderId = msg['senderId'];
                final dateTime = msg['timestamp'] as DateTime;
                final isMe = senderId == widget.currentUserId;

                Widget messageBubble() {
                  return Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFFC9E1E6) : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(18),
                        topRight: const Radius.circular(18),
                        bottomLeft: Radius.circular(isMe ? 18 : 0),
                        bottomRight: Radius.circular(isMe ? 0 : 18),
                      ),
                    ),
                    child: Text(
                      text,
                      style: GoogleFonts.sarabun(fontSize: 16, color: const Color(0xFF062252)),
                    ),
                  );
                }

                return Column(
                  children: [
                    if (index == 0 ||
                        (mockMessages[index - 1]['timestamp'] as DateTime).day != dateTime.day)
                      Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC9E1E6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            formatDateHeader(dateTime),
                            style: GoogleFonts.sarabun(fontSize: 12, color: const Color(0xFF062252)),
                          ),
                        ),
                      ),
                    Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (!isMe) ...[
                            CircleAvatar(radius: 14, backgroundColor: Colors.grey[400]),
                            const SizedBox(width: 8),
                          ],
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              messageBubble(),
                              Padding(
                                padding: const EdgeInsets.only(top: 4, right: 4),
                                child: Text(
                                  formatTime(dateTime),
                                  style: GoogleFonts.sarabun(fontSize: 12, color: const Color(0xB3062252)),
                                ),
                              ),
                            ],
                          ),
                          if (isMe) ...[
                            const SizedBox(width: 8),
                            CircleAvatar(radius: 14, backgroundColor: Colors.grey[400]),
                          ],
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFC9E1E6),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'พิมพ์ข้อความ.....',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    child: IconButton(
                      icon: Image.asset('assets/icons/send.png', width: 24, height: 24),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
