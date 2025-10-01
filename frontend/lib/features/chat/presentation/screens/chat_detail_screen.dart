import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/features/chat/infrastructure/chat_api.dart';
import '../widgets/chat_header.dart';
import '../widgets/chat_messages.dart';
import '../widgets/chat_input.dart';

class ChatDetailScreen extends StatefulWidget {
  final String chatId;
  final String currentUserId;
  final String otherUserId;
  final String otherUserName;
  final String? otherUserAvatar;
  final Map<String, dynamic> product;
  final bool fromProductDetail;

  const ChatDetailScreen({
    super.key,
    required this.chatId,
    required this.currentUserId,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserAvatar,
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
  final ChatApi _chatApi = ChatApi();

  List<Map<String, dynamic>> messages = [];

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

  Future<void> _loadMessages() async {
    try {
      final data = await _chatApi.getMessages(int.parse(widget.chatId));
      setState(() {
        messages = data;
      });
      _scrollToBottom();
    } catch (e) {
      debugPrint("Error loading messages: $e");
    }
  }

  Future<void> _sendMessage(
    String text,
    List<Map<String, dynamic>> images,
  ) async {
    try {
      List<String> uploadedUrls = [];
      for (var img in images) {
        final file = File(img["path"]);
        final url = await _chatApi.uploadChatImage(
          int.parse(widget.chatId),
          file,
        );
        if (url != null) uploadedUrls.add(url);
      }
      final newMessage = await _chatApi.sendMessage(
        chatroomId: int.parse(widget.chatId),
        senderId: int.parse(widget.currentUserId),
        content: text,
        messageType: uploadedUrls.isNotEmpty ? "image" : "text",
        imageUrls: uploadedUrls,
      );
      setState(() {
        messages.add(newMessage);
      });
      _scrollToBottom();
    } catch (e) {
      debugPrint("Error sending message: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    final status = widget.product['status'] ?? "available";
    if (status == "sold") {
      isSold = true;
    } else if (status == "purchased" || status == "reviewed") {
      isSold = true;
      isPurchased = true;
    }
    _loadMessages();
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
          otherUserName: widget.otherUserName,
          otherUserAvatar: widget.otherUserAvatar,
          onStatusChanged: (newStatus) {
            setState(() {
              if (newStatus == "reserved") {
                isSold = false;
                isPurchased = false;
              } else if (newStatus == "purchased") {
                isSold = true;
                isPurchased = false;
              } else if (newStatus == "reviewed") {
                isSold = true;
                isPurchased = true;
              } else if (newStatus == "sold") {
                isSold = true;
              }
            });
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatMessages(
              scrollController: _scrollController,
              messages: messages,
              currentUserId: widget.currentUserId,
            ),
          ),
          ChatInput(
            messageController: _messageController,
            onSend: (text, images) {
              _sendMessage(text, images);
              _messageController.clear();
            },
          ),
        ],
      ),
    );
  }
}
