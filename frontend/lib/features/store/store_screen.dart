import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

class StoreScreen extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    // ใช้ ! เพื่อบังคับ non-null
    final store = seller ?? ref.watch(storeProvider)!;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue[50],
          elevation: 0,
          title: Text(
            store["name"] ?? "ร้านค้า",
            style: const TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // 🔎 Search bar
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search for products, brands, or categories...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // 🏪 Store Header
              Container(
                color: Colors.blue[50],
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          (store["avatar_url"] != null &&
                              (store["avatar_url"] as String).isNotEmpty)
                          ? NetworkImage(store["avatar_url"])
                          : null,
                      child:
                          (store["avatar_url"] == null ||
                              (store["avatar_url"] as String).isEmpty)
                          ? const Icon(Icons.store, size: 32)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            store["name"] ?? "ร้านค้า",
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
                              Text("${store["rating"] ?? 0}"),
                              const SizedBox(width: 8),
                              Text(
                                "${store["followers"] ?? 0} ผู้ติดตาม",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    if (!isOwner)
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text("ติดตาม"),
                          ),
                          const SizedBox(height: 4),
                          OutlinedButton(
                            onPressed: () {},
                            child: const Text("แชท"),
                          ),
                        ],
                      ),
                  ],
                ),
              ),

              // 💬 Review Section
              if (store["reviews"] != null &&
                  (store["reviews"] as List).isNotEmpty)
                Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (store["reviews"][0]["user"] ?? '') as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              (store["reviews"][0]["comment"] ?? '') as String,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // TODO: ไปหน้ารีวิวทั้งหมด
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

              // 📑 Tabs
              const TabBar(
                labelColor: Colors.black,
                tabs: [
                  Tab(text: "รายการสินค้า"),
                  Tab(text: "หมวดหมู่"),
                ],
              ),

              // 📦 Content
              Expanded(
                child: TabBarView(
                  children: [
                    // Product Grid
                    GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemCount: (store["products"] as List?)?.length ?? 0,
                      itemBuilder: (context, index) {
                        final product = (store["products"] as List)[index];
                        return GestureDetector(
                          onTap: () {
                            context.push('/product_details', extra: product);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(product["title"] ?? "สินค้า"),
                            ),
                          ),
                        );
                      },
                    ),

                    // Category Tab
                    ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: (store["categories"] as List?)?.length ?? 0,
                      itemBuilder: (context, index) {
                        final category = (store["categories"] as List)[index];
                        return Card(
                          child: ListTile(
                            title: Text(category ?? ''),
                            onTap: () {
                              // TODO: กรองสินค้าแยกตามหมวดหมู่
                            },
                          ),
                        );
                      },
                    ),
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
