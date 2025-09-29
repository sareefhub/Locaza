import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/config/api_config.dart';
import 'package:frontend/features/product/application/product_provider.dart';
import 'package:frontend/features/product/application/category_provider.dart';
import 'package:frontend/features/auth/application/user_provider.dart';
import 'package:frontend/core/widgets/product_card.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:frontend/utils/user_session.dart';
import 'package:frontend/features/favorite/application/favorite_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/features/chat/infrastructure/chat_api.dart';

class ProductDetailsPage extends ConsumerStatefulWidget {
  final int productId;

  const ProductDetailsPage({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends ConsumerState<ProductDetailsPage> {
  bool showFullDescription = false;

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productByIdProvider(widget.productId));
    final allProducts = ref.watch(productListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFE0F3F7),
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
                (product['description'] != null &&
                    product['description'].toString().isNotEmpty)
                ? product['description'].toString()
                : 'ไม่มีรายละเอียดสินค้า';

            final hasLongDescription =
                productDescription.split('\n').length > 2 ||
                productDescription.length > 100;

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

            final sellerState = ref.watch(
              userByIdProvider(product['seller_id']),
            );

            return sellerState.when(
              data: (seller) => SingleChildScrollView(
                child: Column(
                  children: [
                    _buildProductImageSection(image, seller, product),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProductTitleSection(product, categoryName),
                          const SizedBox(height: 16),
                          const Divider(color: Colors.grey, thickness: 1),
                          const SizedBox(height: 8),
                          _buildProductDescriptionSection(
                            productDescription,
                            hasLongDescription,
                          ),
                          const SizedBox(height: 18),
                          _buildSellerChatSection(product, seller),
                          const SizedBox(height: 18),
                          _buildSimilarProductsSection(allProducts, product),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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

  Widget _buildProductImageSection(
    String image,
    Map<String, dynamic>? seller,
    Map<String, dynamic> product,
  ) {
    return Stack(
      children: [
        ClipRRect(
          child: image.isNotEmpty
              ? Image.network(
                  ApiConfig.fixUrl(image),
                  height: 310,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  'assets/products-image/placeholder_product.png',
                  height: 310,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
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
          right: 16,
          child: Consumer(
            builder: (context, ref, _) {
              final notifier = ref.read(favoriteProvider.notifier);
              final favoriteState = ref.watch(favoriteProvider);
              final userId = int.tryParse(UserSession.id ?? '');
              final isFavorite = userId != null
                  ? favoriteState.any(
                      (item) =>
                          item['product_id'] == product['id'] &&
                          item['user_id'] == userId,
                    )
                  : false;

              return Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.white,
                  ),
                  onPressed: () {
                    if (userId == null) return;
                    if (isFavorite) {
                      notifier.removeFavorite(product['id'], userId);
                    } else {
                      notifier.addFavorite(product, userId);
                    }
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductTitleSection(
    Map<String, dynamic> product,
    String categoryName,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '฿${product['price'] ?? ''}',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF315EB2),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          product['title'] ?? '',
          style: GoogleFonts.sarabun(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            if (categoryName.isNotEmpty) _buildCategoryTag(categoryName),
            const SizedBox(width: 8),
            if (product['location'] != null)
              _buildLocationTag(product['location']),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryTag(String categoryName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFC9E1E6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.category, size: 14, color: Colors.grey),
          const SizedBox(width: 4),
          Text(categoryName, style: GoogleFonts.sarabun(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildLocationTag(String location) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFC9E1E6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, size: 14, color: Colors.grey),
          const SizedBox(width: 4),
          Text(location, style: GoogleFonts.sarabun(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildProductDescriptionSection(
    String description,
    bool hasLongDescription,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'รายละเอียดสินค้า',
          style: GoogleFonts.sarabun(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          maxLines: showFullDescription ? null : 2,
          overflow: showFullDescription
              ? TextOverflow.visible
              : TextOverflow.ellipsis,
          style: GoogleFonts.sarabun(fontSize: 14),
        ),
        if (hasLongDescription)
          TextButton(
            onPressed: () {
              setState(() {
                showFullDescription = !showFullDescription;
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  showFullDescription
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 16,
                  color: const Color(0xFF315EB2),
                ),
                const SizedBox(width: 4),
                Text(
                  showFullDescription ? "ดูน้อยลง" : "อ่านเพิ่มเติม",
                  style: GoogleFonts.sarabun(
                    fontSize: 14,
                    color: const Color(0xFF315EB2),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSellerChatSection(
    Map<String, dynamic> product,
    Map<String, dynamic>? seller,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey[300],
            backgroundImage:
                seller != null &&
                    seller['avatar_url'] != null &&
                    seller['avatar_url'].toString().isNotEmpty
                ? NetworkImage(ApiConfig.fixUrl(seller['avatar_url']))
                : null,
            child:
                (seller == null ||
                    seller['avatar_url'] == null ||
                    seller['avatar_url'].toString().isEmpty)
                ? const Icon(Icons.person, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  seller != null ? seller['name'] ?? '' : '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      if (seller == null) return;

                      final productData = {
                        "seller_id": seller['id'],
                        "title": product['title'],
                        "image_urls": (product['image_urls'] is List)
                            ? (product['image_urls'] as List)
                                  .map((img) => ApiConfig.fixUrl(img))
                                  .toList()
                            : [ApiConfig.fixUrl(product['image_urls'] ?? '')],
                        "price": product['price'],
                      };

                      String chatroomId = await createOrGetChatroom(
                        currentUserId: int.parse(UserSession.id ?? '0'),
                        sellerId: seller['id'],
                        productId: product['id'],
                      );

                      context.push(
                        '/chat_detail',
                        extra: {
                          'chatId': chatroomId,
                          'currentUserId': UserSession.id,
                          'otherUserId': seller['id'].toString(),
                          'otherUserName': seller['name'],
                          'otherUserAvatar': seller['avatar_url'],
                          'product': productData,
                          'fromProductDetail': true,
                        },
                      );
                    },
                    icon: const Icon(Icons.chat, color: Color(0xFF315EB2)),
                    label: Text(
                      "แชต",
                      style: GoogleFonts.sarabun(
                        color: const Color(0xFF315EB2),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF315EB2)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarProductsSection(
    AsyncValue<List<Map<String, dynamic>>> allProducts,
    Map<String, dynamic> product,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
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
                .where(
                  (p) =>
                      p['category_id'] == product['category_id'] &&
                      p['id'] != product['id'] &&
                      ((p['status'] ?? '').toString().toLowerCase() ==
                              'available' ||
                          (p['status'] ?? '').toString().toLowerCase() ==
                              'posted' ||
                          (p['status'] ?? '').toString().toLowerCase() ==
                              'published'),
                )
                .take(4)
                .toList();

            return ResponsiveBuilder(
              builder: (context, sizingInfo) {
                final screenWidth = sizingInfo.screenSize.width;

                int crossAxisCount;
                if (screenWidth >= 1600) {
                  crossAxisCount = 6;
                } else if (screenWidth >= 1300) {
                  crossAxisCount = 5;
                } else if (screenWidth >= 1000) {
                  crossAxisCount = 4;
                } else if (screenWidth >= 600) {
                  crossAxisCount = 3;
                } else {
                  crossAxisCount = 2;
                }

                double horizontalPadding = 16;
                double spacing = 12 * (crossAxisCount - 1);
                double cardWidth =
                    (screenWidth - horizontalPadding * 2 - spacing) /
                    crossAxisCount;
                double cardHeight = cardWidth * 0.8 + 120;
                double childAspectRatio = cardWidth / cardHeight;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: childAspectRatio,
                  ),
                  itemCount: similarProducts.length,
                  itemBuilder: (context, index) {
                    final p = similarProducts[index];
                    return ProductCard(product: p);
                  },
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text("Error: $err")),
        ),
      ],
    );
  }
}
