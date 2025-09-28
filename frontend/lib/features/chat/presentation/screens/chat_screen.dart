import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/core/widgets/navigation.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../config/api_config.dart';
import '../../application/chat_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String currentUserId;

  const ChatScreen({super.key, required this.currentUserId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchText = '';

  String formatDate(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '';
    try {
      final date = DateTime.parse(isoString).toLocal();
      final now = DateTime.now();
      final diff = now.difference(date);
      if (diff.inDays == 0) {
        return DateFormat.Hm().format(date);
      } else if (diff.inDays == 1) {
        return "เมื่อวาน";
      } else {
        return DateFormat("d/M").format(date);
      }
    } catch (e) {
      return isoString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatroomsAsync = ref.watch(chatroomsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: const Color(0xFFE0F3F7),
          elevation: 0,
          centerTitle: true,
          title: Text(
            'ข้อความ',
            style: GoogleFonts.sarabun(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(chatroomsProvider);
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: GoogleFonts.sarabun(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onChanged: (val) {
                    setState(() {
                      searchText = val.trim().toLowerCase();
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: chatroomsAsync.when(
                data: (chatrooms) {
                  final filteredChats = searchText.isEmpty
                      ? chatrooms
                      : chatrooms
                          .where(
                            (chat) =>
                                (chat['buyer_name'] ?? '')
                                    .toString()
                                    .toLowerCase()
                                    .contains(searchText) ||
                                (chat['seller_name'] ?? '')
                                    .toString()
                                    .toLowerCase()
                                    .contains(searchText),
                          )
                          .toList();
                  if (filteredChats.isEmpty) {
                    return Center(
                      child: Text(
                        'ยังไม่มีข้อความ',
                        style: GoogleFonts.sarabun(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(12.0),
                    itemCount: filteredChats.length,
                    itemBuilder: (context, index) {
                      final chat = filteredChats[index];
                      final otherUserName =
                          chat['buyer_id'].toString() == widget.currentUserId
                              ? chat['seller_name']
                              : chat['buyer_name'];
                      final lastMessage = chat['last_message'];
                      final lastMessageTime = chat['last_message_time'];
                      return InkWell(
                        onTap: () async {
                          await context.push('/chat_detail', extra: {
                            'chatId': chat['id'].toString(),
                            'currentUserId': widget.currentUserId,
                            'otherUserId':
                                chat['buyer_id'].toString() == widget.currentUserId
                                    ? chat['seller_id'].toString()
                                    : chat['buyer_id'].toString(),
                            'otherUserName': otherUserName,
                            'product': {
                              "seller_id": chat['seller_id'],
                              "title": chat['product_title'],
                              "image_urls": (chat['product_images'] as List<dynamic>?)
                                      ?.map((img) => ApiConfig.fixUrl(img))
                                      .toList() ??
                                  [],
                              "price": chat['product_price']
                            },
                            'fromProductDetail': false,
                          });
                          ref.invalidate(chatroomsProvider);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.grey.shade400,
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            otherUserName ?? '',
                                            style: GoogleFonts.sarabun(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          formatDate(
                                            lastMessageTime ?? chat['created_at'],
                                          ),
                                          style: GoogleFonts.sarabun(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      (lastMessage == null ||
                                              lastMessage.isEmpty)
                                          ? 'เริ่มการสนทนา...'
                                          : lastMessage,
                                      style: GoogleFonts.sarabun(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (err, _) => Center(
                  child: Text(
                    'Error: $err',
                    style: GoogleFonts.sarabun(color: Colors.red),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }
}
