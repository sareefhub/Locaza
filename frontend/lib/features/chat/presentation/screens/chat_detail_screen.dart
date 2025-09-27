import 'package:flutter/material.dart';

import '../widgets/chat_header.dart';
import '../widgets/chat_messages.dart';
import '../widgets/chat_input.dart';

class ChatDetailScreen extends StatefulWidget {
  final String chatId;
  final String currentUserId;
  final String otherUserId;
  final Map<String, dynamic> product;
  final bool fromProductDetail;

  const ChatDetailScreen({
    super.key,
    required this.chatId,
    required this.currentUserId,
    required this.otherUserId,
    required this.product,
    required this.fromProductDetail,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  bool isSold = false;
  bool isPurchased = false;

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> mockMessages = [];

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F3F7),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: ChatHeader(
          product: widget.product,
          currentUserId: widget.currentUserId,
          isSold: isSold,
          isPurchased: isPurchased,
          onSoldChanged: (val) => setState(() => isSold = val),
          onPurchasedChanged: (val) => setState(() => isPurchased = val),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatMessages(
              scrollController: _scrollController,
              messages: mockMessages,
              currentUserId: widget.currentUserId,
            ),
          ),
          ChatInput(
            messageController: _messageController,
            onSend: (text, images) {
              setState(() {
                mockMessages.add({
                  "id": "m${mockMessages.length + 1}",
                  "text": text,
                  "images": images,
                  "senderId": widget.currentUserId,
                  "receiverId": widget.otherUserId,
                  "createdAt": DateTime.now(),
                });
              });
              _scrollToBottom();
            },
          ),
        ],
      ),
    );
  }
}
