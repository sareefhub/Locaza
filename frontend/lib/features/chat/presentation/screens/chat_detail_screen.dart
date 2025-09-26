import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// นำเข้า dummy data
import 'package:frontend/data/dummy_users.dart';

class ChatDetailScreen extends StatefulWidget {
  final String chatId;
  final String currentUserId;
  final String otherUserId;
  final Map<String, dynamic> product;
  final bool fromProductDetail; // true = มาจาก ProductDetail

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
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool isSold = false; // ผู้ขายยืนยันการขาย
  bool isPurchased = false; // ผู้ซื้อยืนยันการซื้อ

  List<Map<String, dynamic>> mockMessages = [
    {
      "id": "m1",
      "text": "สวัสดีครับ สนใจสินค้านี้อยู่ไหม?",
      "senderId": "2",
      "receiverId": "1",
      "createdAt": DateTime.now().subtract(const Duration(minutes: 30)),
    },
    {
      "id": "m2",
      "text": "ใช่ครับ อยากสอบถามรายละเอียดเพิ่ม",
      "senderId": "1",
      "receiverId": "2",
      "createdAt": DateTime.now().subtract(const Duration(minutes: 25)),
    },
    {
      "id": "m3",
      "text": "ได้เลยครับ ของแท้ 100% ส่งฟรี",
      "senderId": "2",
      "receiverId": "1",
      "createdAt": DateTime.now().subtract(const Duration(minutes: 20)),
    },
  ];

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

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      mockMessages.add({
        "id": "m${mockMessages.length + 1}",
        "text": message,
        "senderId": widget.currentUserId,
        "receiverId": widget.otherUserId,
        "createdAt": DateTime.now(),
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
  void initState() {
    super.initState();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final productTitle = widget.product['title'] ?? 'ชื่อสินค้า';
    final productImageUrl =
        (widget.product['image_urls'] != null &&
            (widget.product['image_urls'] as List).isNotEmpty)
        ? widget.product['image_urls'][0]
        : null;

    final sellerId = widget.product['seller_id'];
    final seller = dummyUsers.firstWhere(
      (user) => user['id'] == sellerId,
      orElse: () => {'name': 'ผู้ขายไม่ทราบชื่อ', 'avatar_url': null},
    );
    final sellerName = seller['name'];
    final sellerAvatar = seller['avatar_url'];

    final isOwner = widget.currentUserId == sellerId.toString();

    String actionButtonText() {
      if (isOwner) return "ขาย";
      if (!isSold) return "ซื้อ"; // ยังกดไม่ได้
      return isPurchased ? "รีวิว" : "ซื้อ";
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE0F3F7),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AppBar(
          backgroundColor: const Color(0xFFC9E1E6),
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Image.asset(
                          'assets/icons/angle-small-left.png',
                          width: 24,
                          height: 24,
                        ),
                        onPressed: () => context.pop(),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.grey[400],
                        backgroundImage: sellerAvatar != null
                            ? AssetImage(sellerAvatar)
                            : null,
                        child: sellerAvatar == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        sellerName,
                        style: GoogleFonts.sarabun(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF062252),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                          image: productImageUrl != null
                              ? DecorationImage(
                                  image: AssetImage(productImageUrl),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: productImageUrl == null
                            ? const Icon(Icons.image, color: Colors.grey)
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          productTitle,
                          style: GoogleFonts.sarabun(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF062252),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isOwner
                              ? const Color(0xFFE0AFAF)
                              : (!isSold
                                    ? Colors.grey
                                    : const Color(0xFF62B9E8)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: InkWell(
                          onTap: () async {
                            if (isOwner) {
                              // ผู้ขายยืนยันการขาย
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("ยืนยันการขาย"),
                                  content: const Text(
                                    "คุณต้องการยืนยันการขายสินค้านี้หรือไม่?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text("ยกเลิก"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text("ยืนยัน"),
                                    ),
                                  ],
                                ),
                              );
                              if (confirmed == true) {
                                setState(() {
                                  isSold = true;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("ขายสินค้าสำเร็จ"),
                                  ),
                                );
                              }
                            } else if (!isOwner && isSold && !isPurchased) {
                              // ผู้ซื้อยืนยันการซื้อ
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("ยืนยันการซื้อ"),
                                  content: const Text(
                                    "คุณต้องการยืนยันการซื้อสินค้านี้หรือไม่?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text("ยกเลิก"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text("ยืนยัน"),
                                    ),
                                  ],
                                ),
                              );
                              if (confirmed == true) {
                                setState(() {
                                  isPurchased = true;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("ซื้อสินค้าสำเร็จ"),
                                  ),
                                );
                              }
                            } else if (!isOwner && isPurchased) {
                              // ไปหน้ารีวิว
                              context.push(
                                '/review',
                                extra: {
                                  'storeName': sellerName,
                                  'product': widget.product,
                                  'revieweeId': sellerId,
                                  'reviewerId': widget.currentUserId,
                                },
                              );
                            }
                          },
                          child: Text(
                            actionButtonText(),
                            style: GoogleFonts.sarabun(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
                final text = msg['text'] as String;
                final senderId = msg['senderId'] as String;
                final dateTime = msg['createdAt'] as DateTime;
                final isMe = senderId == widget.currentUserId;

                Widget messageBubble() {
                  return Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.65,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 14,
                    ),
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
                      style: GoogleFonts.sarabun(
                        fontSize: 16,
                        color: const Color(0xFF062252),
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    if (index == 0 ||
                        (mockMessages[index - 1]['createdAt'] as DateTime)
                                .day !=
                            dateTime.day)
                      Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC9E1E6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            formatDateHeader(dateTime),
                            style: GoogleFonts.sarabun(
                              fontSize: 12,
                              color: const Color(0xFF062252),
                            ),
                          ),
                        ),
                      ),
                    Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (!isMe) ...[
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.grey[400],
                            ),
                            const SizedBox(width: 8),
                          ],
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              messageBubble(),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 4,
                                  right: 4,
                                ),
                                child: Text(
                                  formatTime(dateTime),
                                  style: GoogleFonts.sarabun(
                                    fontSize: 12,
                                    color: const Color(0xB3062252),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (isMe) ...[
                            const SizedBox(width: 8),
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.grey[400],
                            ),
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
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: const Color(0xFF062252),
                    child: IconButton(
                      icon: Image.asset(
                        'assets/icons/send.png',
                        width: 22,
                        height: 22,
                        color: Colors.white,
                      ),
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
