import 'package:flutter/material.dart';
import 'package:frontend/features/review/view_reviews_screen.dart';

class ReviewPreviewCard extends StatelessWidget {
  final String storeName;
  final List reviews;
  final bool isOwner;

  const ReviewPreviewCard({
    super.key,
    required this.storeName,
    required this.reviews,
    this.isOwner = false,
  });

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return const Center(
        child: Text("ยังไม่มีรีวิว", style: TextStyle(color: Colors.grey)),
      );
    }

    return Card(
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reviews[0]["user"] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(reviews[0]["comment"] ?? ''),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  builder: (_) => ViewReviewScreen(
                    storeName: storeName,
                    reviews: reviews,
                    isOwner: isOwner,
                  ),
                );
              },
              child: const Text(
                "ดูทั้งหมด",
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
