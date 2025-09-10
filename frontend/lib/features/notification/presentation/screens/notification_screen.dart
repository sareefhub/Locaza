import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/navigation.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        "title": "สินค้าใหม่มาแล้ว!",
        "body": "ลองดูสินค้าใหม่ที่คุณอาจสนใจ",
        "time": "10 นาทีที่แล้ว",
        "imageUrl": null,
      },
      {
        "title": "ส่วนลดพิเศษ",
        "body": "รับส่วนลด 20% วันนี้เท่านั้น",
        "time": "2 ชั่วโมงที่แล้ว",
        "imageUrl": null,
      },
    ];

    return Scaffold(
      appBar: _buildAppBar(),
      body: notifications.isEmpty
          ? Center(
              child: Text(
                'ยังไม่มีการแจ้งเตือน',
                style: GoogleFonts.sarabun(),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final n = notifications[index];
                return _NotificationCard(
                  title: n["title"]!,
                  subtitle: n["body"]!,
                  timeText: n["time"]!,
                  imageUrl: n["imageUrl"],
                  onTap: () {},
                );
              },
            ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFE0F3F7),
      centerTitle: true,
      elevation: 0,
      title: Text(
        'แจ้งเตือน',
        style: GoogleFonts.sarabun(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 8),
          child: Icon(Icons.notifications_outlined, color: Colors.black),
        ),
      ],
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.title,
    required this.subtitle,
    required this.timeText,
    this.imageUrl,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String timeText;
  final String? imageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFE6E6E6),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ImagePlaceholder(imageUrl: imageUrl),
              const SizedBox(width: 12),
              Expanded(
                child: _Texts(
                  title: title,
                  subtitle: subtitle,
                  timeText: timeText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({this.imageUrl});
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final border = BorderRadius.circular(8);
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: border,
        child: Image.asset(
          imageUrl!,
          width: 52,
          height: 52,
          fit: BoxFit.cover,
        ),
      );
    }
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: border,
      ),
      child: const Icon(Icons.image_outlined, color: Colors.black54),
    );
  }
}

class _Texts extends StatelessWidget {
  const _Texts({
    required this.title,
    required this.subtitle,
    required this.timeText,
  });

  final String title;
  final String subtitle;
  final String timeText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.sarabun(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.sarabun(fontSize: 13, color: Colors.black87),
        ),
        const SizedBox(height: 4),
        Text(
          timeText,
          style: GoogleFonts.sarabun(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }
}
