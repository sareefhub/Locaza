import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductDetailsPage extends ConsumerStatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  ConsumerState<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends ConsumerState<ProductDetailsPage> {
  late Map<String, dynamic> product;
  List<Map<String, dynamic>> similarProducts = [];

  @override
  void initState() {
    super.initState();
    product = widget.product;

    similarProducts = [
      {
        "id": "2",
        "name": "ทุเรียนหมอนทอง",
        "category": "ผลไม้",
        "price": "฿500",
        "image": "assets/images/placeholder.png",
        "sellerName": "ร้านผลไม้ B",
        "sellerImage": "assets/images/placeholder_seller.png",
      },
      {
        "id": "3",
        "name": "มังคุด",
        "category": "ผลไม้",
        "price": "฿150",
        "image": "assets/images/placeholder.png",
        "sellerName": "ร้านผลไม้ C",
        "sellerImage": "assets/images/placeholder_seller.png",
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    final String productDescription =
        (product['description'] != null && product['description'].toString().isNotEmpty)
            ? product['description'].toString()
            : 'ไม่มีรายละเอียดสินค้า';

    final bool isFavorite = false;
    const double favoriteIconSize = 25;

    return Scaffold(
      backgroundColor: const Color(0xFFE0F3F7),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  GoRouter.of(context).push('/login');
                },
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text("Chat"),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  GoRouter.of(context).push('/login');
                },
                icon: const Icon(Icons.call_outlined),
                label: const Text("Call"),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Image.asset(
                    product['image'],
                    height: 290,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 16,
                    left: 8,
                    child: IconButton(
                      icon: Image.asset(
                        'assets/icons/angle-small-left.png',
                        width: 24,
                        height: 24,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 8,
                    child: Container(
                      width: favoriteIconSize + 8,
                      height: favoriteIconSize + 8,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        padding: const EdgeInsets.all(4),
                        iconSize: favoriteIconSize,
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.white,
                        ),
                        onPressed: () {
                          GoRouter.of(context).push('/login');
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product['price'],
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                    Text(product['name'], style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(200, 209, 233, 242),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(product['category']),
                    ),
                    const SizedBox(height: 16),
                    Text(productDescription),
                    TextButton(
                      onPressed: () {},
                      child: const Text("Read more"),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: AssetImage(product['sellerImage']),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['sellerName'] ?? 'ไม่ทราบชื่อผู้ขาย',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      GoRouter.of(context).push('/login');
                                    },
                                    icon: const Icon(Icons.chat),
                                    label: const Text("Chat"),
                                  ),
                                  const SizedBox(width: 8),
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      GoRouter.of(context).push('/login');
                                    },
                                    icon: const Icon(Icons.call),
                                    label: const Text("Call"),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (similarProducts.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'สินค้าใกล้เคียง',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 0.55,
                            ),
                            itemCount: similarProducts.length,
                            itemBuilder: (context, index) {
                              final sp = similarProducts[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.grey[200],
                                    ),
                                    child: Center(
                                      child: Text("รูปภาพ",
                                          style: TextStyle(
                                              color: Colors.grey[600])),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(sp['name'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(sp['price'],
                                      style:
                                          const TextStyle(color: Colors.green)),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
