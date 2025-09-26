import 'package:flutter/material.dart';

class ViewReviewScreen extends StatefulWidget {
  final String storeName;
  final List<dynamic> reviews;
  final bool isOwner;

  const ViewReviewScreen({
    super.key,
    required this.storeName,
    required this.reviews,
    required this.isOwner,
  });

  @override
  State<ViewReviewScreen> createState() => _ViewReviewScreenState();
}

class _ViewReviewScreenState extends State<ViewReviewScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _mockReviews = [];

  @override
  void initState() {
    super.initState();
    _mockReviews = widget.reviews
        .map(
          (r) => {
            "user": r["user"].toString(),
            "comment": r["comment"].toString(),
          },
        )
        .toList();
  }

  void _addReview() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _mockReviews.add({
        "user": "คุณลูกค้า", // mock user
        "comment": _controller.text.trim(),
      });
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                "รีวิวร้านค้า",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const Divider(height: 1),

            // Review List
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: _mockReviews.length,
                itemBuilder: (context, index) {
                  final review = _mockReviews[index];
                  return ListTile(
                    title: Text(
                      review["user"] ?? "",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(review["comment"] ?? ""),
                  );
                },
              ),
            ),

            // Input only for non-owner
            if (!widget.isOwner)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: const Border(top: BorderSide(color: Colors.grey)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: "พิมพ์ข้อความ...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.blue),
                      onPressed: _addReview,
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
