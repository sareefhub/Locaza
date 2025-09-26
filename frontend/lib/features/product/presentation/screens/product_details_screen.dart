import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/config/api_config.dart';
import 'package:frontend/features/product/application/product_provider.dart';
import 'package:frontend/features/product/application/category_provider.dart';
import 'package:frontend/features/auth/application/user_provider.dart';

class ProductDetailsPage extends ConsumerWidget {
  final int productId;

  const ProductDetailsPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productByIdProvider(productId));
    final allProducts = ref.watch(productListProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text("Chat"),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.call_outlined),
                label: const Text("Call"),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: productState.when(
          data: (product) {
            if (product == null) {
              return const Center(child: Text("ไม่พบสินค้า"));
            }

            final rawImage = product['image_urls'];
            String image = '';
            if (rawImage is List && rawImage.isNotEmpty) {
              image = rawImage.first.toString();
            } else if (rawImage is String && rawImage.isNotEmpty) {
              image = rawImage;
            }

            final productDescription =
                (product['description'] != null && product['description'].toString().isNotEmpty)
                    ? product['description']
                    : 'ไม่มีรายละเอียดสินค้า';

            final categoryState = ref.watch(categoryListProvider);
            final categoryName = categoryState.maybeWhen(
              data: (categories) {
                return categories
                    .firstWhere(
                      (c) => c['id'] == product['category_id'],
                      orElse: () => {'name': ''},
                    )['name']
                    .toString();
              },
              orElse: () => '',
            );

            final sellerState = ref.watch(userByIdProvider(product['seller_id']));

            return sellerState.when(
              data: (seller) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          image.isNotEmpty
                              ? Image.network(
                                  ApiConfig.fixUrl(image),
                                  height: 250,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/images/placeholder.png',
                                  height: 250,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                          Positioned(
                            top: 16,
                            left: 8,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          const Positioned(
                            top: 16,
                            right: 8,
                            child: Icon(Icons.favorite_border),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '฿${product['price'] ?? ''}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            Text(product['title'] ?? '', style: const TextStyle(fontSize: 18)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                if (categoryName.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(categoryName),
                                  ),
                                const SizedBox(width: 8),
                                if (product['location'] != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(product['location']),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(productDescription),
                            TextButton(
                              onPressed: () {},
                              child: const Text("Read more"),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Colors.grey[300],
                                  backgroundImage: seller != null &&
                                          seller['avatar_url'] != null &&
                                          seller['avatar_url'].toString().isNotEmpty
                                      ? NetworkImage(ApiConfig.fixUrl(seller['avatar_url']))
                                      : null,
                                  child: (seller == null ||
                                          seller['avatar_url'] == null ||
                                          seller['avatar_url'].toString().isEmpty)
                                      ? const Icon(Icons.person, color: Colors.white)
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      seller != null ? seller['name'] ?? '' : '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 18),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'สินค้าที่คล้ายกัน',
                                  style: GoogleFonts.sarabun(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            allProducts.when(
                              data: (products) {
                                final similarProducts = products
                                    .where((p) =>
                                        p['category_id'] == product['category_id'] &&
                                        p['id'] != product['id'])
                                    .take(4)
                                    .toList();

                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: GridView.count(
                                    crossAxisCount: 2,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    childAspectRatio: 0.55,
                                    children: List.generate(similarProducts.length, (index) {
                                      final p = similarProducts[index];
                                      final rawImg = p['image_urls'];
                                      String img = '';
                                      if (rawImg is List && rawImg.isNotEmpty) {
                                        img = rawImg.first.toString();
                                      } else if (rawImg is String && rawImg.isNotEmpty) {
                                        img = rawImg;
                                      }
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  ProductDetailsPage(productId: p['id']),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(8),
                                                    child: img.isNotEmpty
                                                        ? Image.network(
                                                            ApiConfig.fixUrl(img),
                                                            height: 130,
                                                            width: double.infinity,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Image.asset(
                                                            'assets/images/placeholder.png',
                                                            height: 130,
                                                            width: double.infinity,
                                                            fit: BoxFit.cover,
                                                          ),
                                                  ),
                                                  const Positioned(
                                                    top: 4,
                                                    right: 4,
                                                    child: Icon(Icons.favorite_border),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                p['title'] ?? '',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                p['location'] ?? '',
                                                style: const TextStyle(fontSize: 12),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '฿${p['price'] ?? ''}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                );
                              },
                              loading: () =>
                                  const Center(child: CircularProgressIndicator()),
                              error: (err, _) => Center(child: Text("Error: $err")),
                            ),
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text("Error: $err")),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text("Error: $err")),
        ),
      ),
    );
  }
}
