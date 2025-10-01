import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../config/api_config.dart';

class ReviewScreen extends StatefulWidget {
  final String storeName;
  final Map<String, dynamic> product;
  final String reviewerId;
  final String revieweeId;
  final int saleTransactionId;

  const ReviewScreen({
    super.key,
    required this.storeName,
    required this.product,
    required this.reviewerId,
    required this.revieweeId,
    required this.saleTransactionId,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int _rating = 0;
  final TextEditingController _reviewController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Widget _buildStar(int index) {
    Color color;
    if (index < _rating) {
      if (_rating <= 2) {
        color = Colors.red;
      } else if (_rating == 3) {
        color = Colors.orange;
      } else {
        color = Colors.green;
      }
    } else {
      color = Colors.grey;
    }

    return IconButton(
      icon: Icon(
        index < _rating ? Icons.star : Icons.star_border,
        color: color,
        size: 40,
      ),
      onPressed: () {
        setState(() {
          _rating = index + 1;
        });
      },
    );
  }

  Future<void> _submitReview() async {
    if (_rating == 0 || _reviewController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาให้คะแนนและเขียนรีวิวก่อนส่ง')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse("${ApiConfig.baseUrl}/reviews/");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'sale_transaction_id': widget.saleTransactionId,
          'product_id': widget.product['id'],
          'reviewer_id': int.tryParse(widget.reviewerId),
          'reviewee_id': int.tryParse(widget.revieweeId),
          'rating': _rating,
          'comment': _reviewController.text,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ส่งรีวิวเรียบร้อยแล้ว')));
        setState(() {
          _rating = 0;
          _reviewController.clear();
        });
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('เกิดข้อผิดพลาดในการส่งรีวิว')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final productTitle = widget.product['title'] ?? 'ชื่อสินค้า';
    final productImageUrl =
        (widget.product['image_urls'] != null && (widget.product['image_urls'] as List).isNotEmpty)
            ? widget.product['image_urls'][0]
            : null;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('รีวิว', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 40,
              backgroundImage: productImageUrl != null ? NetworkImage(productImageUrl) : null,
              child: productImageUrl == null ? const Icon(Icons.store, size: 50) : null,
            ),
            const SizedBox(height: 12),
            Text(
              widget.storeName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(productTitle, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text('ให้คะแนนร้านค้า', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) => _buildStar(index)),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'เขียนข้อความรีวิวร้านค้า',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reviewController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'เขียนข้อความ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('ยืนยัน', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
