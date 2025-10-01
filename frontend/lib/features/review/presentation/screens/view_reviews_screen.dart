import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../config/api_config.dart';

class ViewReviewScreen extends StatefulWidget {
  final String storeName;
  final String revieweeId;
  final bool isOwner;

  const ViewReviewScreen({
    super.key,
    required this.storeName,
    required this.revieweeId,
    required this.isOwner,
  });

  @override
  State<ViewReviewScreen> createState() => _ViewReviewScreenState();
}

class _ViewReviewScreenState extends State<ViewReviewScreen> {
  late Future<List<dynamic>> _reviewsFuture;

  Future<List<dynamic>> _fetchReviews() async {
    final url = Uri.parse("${ApiConfig.baseUrl}/reviews/?reviewee_id=${widget.revieweeId}");
    final res = await http.get(url);
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Failed to load reviews");
    }
  }

  @override
  void initState() {
    super.initState();
    _reviewsFuture = _fetchReviews();
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
            Container(
              padding: const EdgeInsets.all(16),
              child: const Text(
                "รีวิวร้านค้า",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _reviewsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("ยังไม่มีรีวิว"));
                  }
                  final reviews = snapshot.data!;
                  return ListView.builder(
                    controller: scrollController,
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      return ListTile(
                        title: Text(
                          "User ${review['reviewer_id']}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(review['comment'] ?? ''),
                        trailing: Text("⭐ ${review['rating']}"),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
