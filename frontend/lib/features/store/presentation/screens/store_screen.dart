import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../review/view_reviews_screen.dart';

// Dummy store provider
final storeProvider = Provider<Map<String, dynamic>>((ref) {
  return {
    "id": "101",
    "name": "Name LastName",
    "rating": 4.9,
    "followers": 120,
    "avatar_url": "", // รองรับรูป avatar
    "reviews": [
      {
        "user": "user1",
        "comment": "รีวิวสินค้า: คุณภาพดีมาก ใช้งานง่ายและรวดเร็ว!",
      },
      {"user": "user2", "comment": "สินค้าน่ารัก บริการดีค่ะ"},
    ],
    "products": List.generate(6, (i) => {"id": "$i", "title": "สินค้า $i"}),
    "categories": ["ผักผลไม้", "เครื่องใช้", "เสื้อผ้า", "อุปกรณ์กีฬา"],
  };
});

class StoreScreen extends ConsumerStatefulWidget {
  final String storeId;
  final bool isOwner;
  final Map<String, dynamic>? seller;

  const StoreScreen({
    super.key,
    required this.storeId,
    this.isOwner = false,
    this.seller,
  });

  @override
  ConsumerState<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends ConsumerState<StoreScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = widget.seller ?? ref.watch(storeProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0F3F7),
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            'assets/icons/angle-small-left.png',
            width: 24,
            height: 24,
          ),
          onPressed: () => context.pop(),
        ),
        titleSpacing: 0,
        title: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: "Search for products, brands, or categories...",
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          // 🏪 ส่วนหัวของร้าน + รีวิว
          SliverToBoxAdapter(
            child: Column(
              children: [
                // 🏪 ส่วนหัวร้าน
                Container(
                  color: const Color(0xFFE0F3F7),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            (store?["avatar_url"] != null &&
                                (store?["avatar_url"] as String).isNotEmpty)
                            ? NetworkImage(store!["avatar_url"])
                            : null,
                        child:
                            (store?["avatar_url"] == null ||
                                (store?["avatar_url"] as String).isEmpty)
                            ? const Icon(Icons.person, size: 32)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              store?["name"] ?? "ร้านค้า",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 4),
                                Text("${store?["rating"] ?? 0}"),
                              ],
                            ),
                            Text(
                              "${store?["followers"] ?? 0} ผู้ติดตาม",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      if (!widget.isOwner)
                        Column(
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(70, 30),
                              ),
                              onPressed: () {},
                              child: const Text("ติดตาม"),
                            ),
                            const SizedBox(height: 4),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(70, 30),
                              ),
                              onPressed: () {},
                              child: const Text("แชท"),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

                // 💬 รีวิว
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child:
                      (store?["reviews"] != null &&
                          (store?["reviews"] as List).isNotEmpty)
                      ? Card(
                          color: Colors.grey[200],
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        (store?["reviews"][0]["user"] ?? '')
                                            as String,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        (store?["reviews"][0]["comment"] ?? '')
                                            as String,
                                      ),
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
                                        storeName: store?["name"] ?? "ร้านค้า",
                                        reviews: store?["reviews"] ?? [],
                                        isOwner: widget.isOwner,
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
                        )
                      : const Center(
                          child: Text(
                            "ยังไม่มีรีวิว",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                ),
              ],
            ),
          ),

          // 📑 TabBar fixed
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                tabs: const [
                  Tab(text: "รายการสินค้า"),
                  Tab(text: "หมวดหมู่"),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            // ✅ GridView
            GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: (store?["products"] as List?)?.length ?? 0,
              itemBuilder: (context, index) {
                final product = (store?["products"] as List)[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(child: Text(product["title"] ?? "สินค้า")),
                );
              },
            ),

            // ✅ ListView
            ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: (store?["categories"] as List?)?.length ?? 0,
              itemBuilder: (context, index) {
                final category = (store?["categories"] as List)[index];
                return Card(
                  child: ListTile(
                    title: Text(category ?? ''),
                    onTap: () {
                      // TODO: filter products by category
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// SliverPersistentHeader สำหรับ TabBar
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}
