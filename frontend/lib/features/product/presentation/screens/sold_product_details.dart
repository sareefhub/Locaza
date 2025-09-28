import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/features/favorite/application/favorite_provider.dart';
import 'package:frontend/utils/user_session.dart';
import 'package:frontend/routing/routes.dart';
import 'package:frontend/config/api_config.dart';
import 'package:frontend/features/product/application/product_provider.dart';
import 'package:frontend/features/auth/application/user_provider.dart';

class SoldProductDetailsPage extends ConsumerStatefulWidget {
  final Map<String, dynamic> product;

  const SoldProductDetailsPage({super.key, required this.product});

  @override
  ConsumerState<SoldProductDetailsPage> createState() =>
      _SoldProductDetailsPageState();
}

class _SoldProductDetailsPageState
    extends ConsumerState<SoldProductDetailsPage> {
  late Map<String, dynamic> product;
  bool showFullDescription = false;

  @override
  void initState() {
    super.initState();
    product = widget.product;
  }

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productByIdProvider(product['id']));
    return productAsync.when(
      data: (apiProduct) {
        if (apiProduct != null) {
          product = apiProduct;
        }
        final imageUrls = product['image_urls'] as List<dynamic>? ?? [];
        final image = imageUrls.isNotEmpty ? ApiConfig.fixUrl(imageUrls[0].toString()) : '';

        final sellerState = ref.watch(userByIdProvider(product['seller_id']));

        final productDescription =
            (product['description'] != null &&
                    product['description'].toString().isNotEmpty)
                ? product['description'].toString()
                : 'ไม่มีรายละเอียดสินค้า';

        final hasLongDescription =
            productDescription.split('\n').length > 2 ||
                productDescription.length > 100;

        final favoriteState = ref.watch(favoriteProvider);
        final isFavorite = favoriteState.any(
          (item) => item['product_id'] == product['id'],
        );

        final notifier = ref.read(favoriteProvider.notifier);

        return sellerState.when(
          data: (seller) {
            return Scaffold(
              backgroundColor: const Color(0xFFE0F3F7),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            child: image.isNotEmpty
                                ? Image.network(
                                    image,
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
                              onPressed: () => context.pop(),
                            ),
                          ),
                          Positioned(
                            top: 16,
                            right: 16,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                padding: const EdgeInsets.all(8),
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : Colors.white,
                                  size: 24,
                                ),
                                onPressed: () {
                                  final userId = UserSession.id != null
                                      ? int.parse(UserSession.id!)
                                      : 101;
                                  if (isFavorite) {
                                    notifier.removeFavorite(
                                      product['id'],
                                      userId,
                                    );
                                  } else {
                                    notifier.addFavorite(product, userId);
                                  }
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
                            Text(
                              'ขายแล้ว',
                              style: GoogleFonts.sarabun(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF315EB2),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product['title'] ?? '',
                              style: GoogleFonts.sarabun(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                if (product['location'] != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFC9E1E6),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          size: 14,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          product['location'],
                                          style: GoogleFonts.sarabun(
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Divider(color: Colors.grey, thickness: 1),
                            const SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'รายละเอียดสินค้า',
                                  style: GoogleFonts.sarabun(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  productDescription,
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
                                        showFullDescription =
                                            !showFullDescription;
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
                                          showFullDescription
                                              ? "ดูน้อยลง"
                                              : "อ่านเพิ่มเติม",
                                          style: GoogleFonts.sarabun(
                                            fontSize: 14,
                                            color: const Color(0xFF315EB2),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
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
                                    backgroundImage: seller != null &&
                                            seller['avatar_url'] != null
                                        ? NetworkImage(
                                            ApiConfig.fixUrl(
                                                seller['avatar_url']),
                                          )
                                        : null,
                                    child: (seller == null ||
                                            seller['avatar_url'] == null)
                                        ? const Icon(Icons.person,
                                            color: Colors.white)
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          seller != null
                                              ? seller['name'] ?? ''
                                              : 'ไม่ทราบชื่อผู้ขาย',
                                          style: GoogleFonts.sarabun(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        SizedBox(
                                          width: double.infinity,
                                          child: OutlinedButton.icon(
                                            onPressed: () {
                                              final chatId =
                                                  'chat_${product['id']}_${UserSession.id ?? '1'}_${product['seller_id']}';
                                              GoRouter.of(context).push(
                                                AppRoutes.chatDetail
                                                    .replaceAll(':chatId',
                                                        chatId)
                                                    .replaceAll(
                                                      ':currentUserId',
                                                      UserSession.id ?? '1',
                                                    )
                                                    .replaceAll(
                                                      ':otherUserId',
                                                      product['seller_id']
                                                          .toString(),
                                                    ),
                                                extra: {'product': product},
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.chat,
                                              color: Color(0xFF315EB2),
                                            ),
                                            label: Text(
                                              "แชต",
                                              style: GoogleFonts.sarabun(
                                                color: const Color(0xFF315EB2),
                                              ),
                                            ),
                                            style: OutlinedButton.styleFrom(
                                              side: const BorderSide(
                                                color: Color(0xFF315EB2),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (err, _) => Scaffold(
            body: Center(child: Text("Error: $err")),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        body: Center(child: Text("Error: $err")),
      ),
    );
  }
}
