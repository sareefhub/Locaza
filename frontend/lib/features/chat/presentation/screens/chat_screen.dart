import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/core/widgets/navigation.dart';
import 'package:go_router/go_router.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;

  const ChatScreen({super.key, required this.currentUserId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchText = '';

  final List<Map<String, dynamic>> mockChats = [
    {
      "id": "1",
      "userName": "สมชาย",
      "avatarUrl": null,
      "lastMessage": "สวัสดีครับ สนใจสินค้านี้อยู่ใช่ไหม?",
      "timeLabel": "10.45",
    },
    {
      "id": "2",
      "userName": "แม่หญิง",
      "avatarUrl": null,
      "lastMessage": "ได้รับของแล้ว ขอบคุณมากค่ะ",
      "timeLabel": "เมื่อวาน",
    },
    {
      "id": "3",
      "userName": "Baby Shop",
      "avatarUrl": null,
      "lastMessage": "โปรโมชั่นพิเศษสำหรับคุณ",
      "timeLabel": "2/09",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredChats = searchText.isEmpty
        ? mockChats
        : mockChats
              .where(
                (chat) => chat['userName'].toString().toLowerCase().contains(
                  searchText,
                ),
              )
              .toList();

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
      body: Column(
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
            child: filteredChats.isEmpty
                ? Center(
                    child: Text(
                      'ยังไม่มีข้อความ',
                      style: GoogleFonts.sarabun(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12.0),
                    itemCount: filteredChats.length,
                    itemBuilder: (context, index) {
                      final chat = filteredChats[index];
                      return InkWell(
                        onTap: () {
                          // ไปยังหน้า ChatDetailScreen
                          context.push(
                            '/chat_detail/:chatId/:currentUserId/:otherUserId',
                          );
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
                                backgroundImage: chat['avatarUrl'] != null
                                    ? NetworkImage(chat['avatarUrl'])
                                    : null,
                                child: chat['avatarUrl'] == null
                                    ? const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      )
                                    : null,
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
                                            chat['userName'],
                                            style: GoogleFonts.sarabun(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          chat['timeLabel'],
                                          style: GoogleFonts.sarabun(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      chat['lastMessage'],
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
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }
}
