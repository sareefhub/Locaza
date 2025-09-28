import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../config/api_config.dart';

class ChatMessages extends StatelessWidget {
  final ScrollController scrollController;
  final List<Map<String, dynamic>> messages;
  final String currentUserId;

  const ChatMessages({
    super.key,
    required this.scrollController,
    required this.messages,
    required this.currentUserId,
  });

  String formatDateHeader(DateTime date) =>
      DateFormat('d MMM yyyy', 'th').format(date.toLocal());

  String formatTime(DateTime time) =>
      DateFormat('HH:mm').format(time.toLocal());

  bool _isLastMessageFromSender(int index) {
    if (index == messages.length - 1) return true;
    final currentSender = messages[index]['sender_id'].toString();
    final nextSender = messages[index + 1]['sender_id'].toString();
    return currentSender != nextSender;
  }

  int _calculateCrossAxisCount(int length) {
    if (length == 1) return 1;
    if (length == 2) return 2;
    if (length == 4) return 2;
    return 3;
  }

  String _resolveImageUrl(String path) {
    if (path.startsWith('http')) return path;
    return "${ApiConfig.baseUrl.replaceAll('/api/v1', '')}$path";
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        final text = msg['content'] as String?;
        final images = msg['image_urls'] as List<dynamic>?;
        final senderId = msg['sender_id'].toString();
        final dateTime = DateTime.parse(msg['created_at']).toLocal();
        final isMe = senderId == currentUserId.toString();
        final showAvatar = !isMe && _isLastMessageFromSender(index);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (index == 0 ||
                DateTime.parse(messages[index - 1]['created_at'])
                        .toLocal()
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (!isMe && showAvatar)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.grey[400],
                      backgroundImage: const AssetImage(
                        "assets/sellers-image/sea.jpg",
                      ),
                    ),
                  )
                else if (!isMe)
                  const SizedBox(width: 36),
                Flexible(
                  child: Column(
                    crossAxisAlignment:
                        isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                    children: [
                      if (text != null && text.isNotEmpty)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (isMe)
                              Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: Text(
                                  formatTime(dateTime),
                                  style: GoogleFonts.sarabun(
                                    fontSize: 12,
                                    color: const Color(0xB3062252),
                                  ),
                                ),
                              ),
                            Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.65,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 14,
                              ),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? const Color(0xFFC9E1E6)
                                    : Colors.white,
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
                            ),
                            if (!isMe)
                              Padding(
                                padding: const EdgeInsets.only(left: 6),
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
                      if (images != null && images.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Row(
                            mainAxisAlignment: isMe
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (isMe)
                                Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Text(
                                    formatTime(dateTime),
                                    style: GoogleFonts.sarabun(
                                      fontSize: 12,
                                      color: const Color(0xB3062252),
                                    ),
                                  ),
                                ),
                              Flexible(
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    int crossAxisCount =
                                        _calculateCrossAxisCount(images.length);
                                    int rowCount =
                                        (images.length / crossAxisCount).ceil();
                                    double spacing = 6;
                                    double gridWidth =
                                        constraints.maxWidth * 2 / 3;
                                    double itemWidth =
                                        (gridWidth - spacing * (crossAxisCount - 1)) /
                                            crossAxisCount;
                                    double gridHeight =
                                        itemWidth * rowCount +
                                            spacing * (rowCount - 1);

                                    return SizedBox(
                                      width: gridWidth,
                                      height: gridHeight,
                                      child: GridView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: images.length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: crossAxisCount,
                                          mainAxisSpacing: spacing,
                                          crossAxisSpacing: spacing,
                                          childAspectRatio: 1,
                                        ),
                                        itemBuilder: (context, imgIndex) {
                                          final resolvedUrl = _resolveImageUrl(images[imgIndex] as String);
                                          return ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image.network(
                                              resolvedUrl,
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                              if (!isMe)
                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
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
                        ),
                      const SizedBox(height: 2),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
          ],
        );
      },
    );
  }
}
