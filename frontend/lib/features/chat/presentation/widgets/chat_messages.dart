import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

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
      DateFormat('d MMM yyyy', 'th').format(date);

  String formatTime(DateTime time) => DateFormat('HH:mm').format(time);

  bool _isLastMessageFromSender(int index) {
    if (index == messages.length - 1) return true;
    final currentSender = messages[index]['senderId'] as String;
    final nextSender = messages[index + 1]['senderId'] as String;
    return currentSender != nextSender;
  }

  void _openImageViewer(
    BuildContext context,
    List<XFile> images,
    int initialIndex,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ImageViewerScreen(images: images, initialIndex: initialIndex),
      ),
    );
  }

  int _calculateCrossAxisCount(int length) {
    if (length == 1) return 1;
    if (length == 2) return 2;
    if (length == 4) return 2;
    return 3; // 3,5,6+
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        final text = msg['text'] as String?;
        final images = msg['images'] as List<XFile>?;
        final senderId = msg['senderId'] as String;
        final dateTime = msg['createdAt'] as DateTime;
        final isMe = senderId == currentUserId;
        final showAvatar = !isMe && _isLastMessageFromSender(index);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Date Header
            if (index == 0 ||
                (messages[index - 1]['createdAt'] as DateTime).day !=
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

            // Message Block
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: isMe
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                // Avatar
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

                // Message Content
                Flexible(
                  child: Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                    children: [
                      // Text Message
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

                      // Image Grid
                      if (images != null && images.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Row(
                            mainAxisAlignment: isMe
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // สำหรับ isMe อยู่ซ้ายของ Grid
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

                              // Grid รูปภาพ
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
                                        (gridWidth -
                                            spacing * (crossAxisCount - 1)) /
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
                                          return GestureDetector(
                                            onTap: () => _openImageViewer(
                                              context,
                                              images,
                                              imgIndex,
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Image.file(
                                                File(images[imgIndex].path),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),

                              // สำหรับผู้ใช้คนอื่น เวลาอยู่ขวาของ Grid
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

// Fullscreen Image Viewer with swipe & pinch-zoom
class ImageViewerScreen extends StatefulWidget {
  final List<XFile> images;
  final int initialIndex;

  const ImageViewerScreen({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  late PageController _pageController;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '${currentIndex + 1}/${widget.images.length}',
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.images.length,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return InteractiveViewer(
            child: Center(
              child: Image.file(
                File(widget.images[index].path),
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
    );
  }
}
