import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/widgets/navigation.dart';

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final List<Map<String, dynamic>> posts = [
    {
      "id": "1",
      "name": "มะม่วงน้ำดอกไม้",
      "description": "สดใหม่จากสวน",
      "state": "post",
      "createdAt": DateTime.now(),
    },
    {
      "id": "2",
      "name": "ทุเรียนหมอนทอง",
      "description": "เนื้อแน่น หวานมัน",
      "state": "draft",
      "createdAt": DateTime.now().subtract(const Duration(days: 1)),
    },
  ];

  Future<bool?> _showDeleteConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('ยืนยันการลบ', style: GoogleFonts.sarabun(fontWeight: FontWeight.bold)),
        content: Text('คุณต้องการลบโพสต์นี้หรือไม่?', style: GoogleFonts.sarabun()),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text('ยกเลิก', style: GoogleFonts.sarabun())),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text('ลบ', style: GoogleFonts.sarabun(color: Colors.red))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0F3F7),
        title: Text('โพสต์', style: GoogleFonts.sarabun(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () => GoRouter.of(context).push('/postform'),
          ),
        ],
        elevation: 0,
      ),
      body: posts.isEmpty
          ? Center(child: Text('ยังไม่มีโพสต์', style: GoogleFonts.sarabun()))
          : ListView.builder(
              itemCount: posts.length,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (context, index) {
                final post = posts[index];
                final name = post['name'] as String;
                final description = post['description'] as String;
                final status = (post['state'] as String).capitalize();
                final createdAt = post['createdAt'] as DateTime;
                final postId = post['id'] as String;

                return GestureDetector(
                  onTap: () => GoRouter.of(context).push('/postedit/$postId'),
                  child: _buildPostItem(context, name, description, status, createdAt, postId),
                );
              },
            ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildPostItem(BuildContext context, String name, String description, String status, DateTime createdAt, String postId) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.image, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(name, style: GoogleFonts.sarabun(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.sarabun(fontSize: 13, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildStatusLabel(status),
                      const SizedBox(width: 8),
                      Text(
                        "${createdAt.day}/${createdAt.month}/${createdAt.year}",
                        style: GoogleFonts.sarabun(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.black54),
              onSelected: (value) async {
                if (value == 'edit') {
                  GoRouter.of(context).push('/postedit/$postId');
                } else if (value == 'delete') {
                  final confirmed = await _showDeleteConfirmationDialog();
                  if (confirmed == true) {
                    setState(() {
                      posts.removeWhere((p) => p['id'] == postId);
                    });
                  }
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<String>(
                  value: 'edit',
                  child: Row(
                    children: [
                      const Icon(Icons.edit, size: 18),
                      const SizedBox(width: 8),
                      Text('แก้ไข', style: GoogleFonts.sarabun()),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                      const SizedBox(width: 8),
                      Text('ลบโพสต์', style: GoogleFonts.sarabun(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusLabel(String status) {
    Color bgColor;
    const Color borderColor = Color(0xFF062252);

    switch (status) {
      case 'Post':
        bgColor = const Color(0xFFB9E8C9);
        break;
      case 'Draft':
        bgColor = Colors.white;
        break;
      default:
        bgColor = const Color(0xFFDCEFF3);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Text(status, style: GoogleFonts.sarabun(fontSize: 12, color: Colors.black)),
    );
  }
}
