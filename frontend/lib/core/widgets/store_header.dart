import 'package:flutter/material.dart';

class StoreHeader extends StatelessWidget {
  final Map<String, dynamic> store;
  final bool isOwner;

  const StoreHeader({super.key, required this.store, this.isOwner = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE0F3F7),
      padding: const EdgeInsets.all(20),
      child: Row(
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
                ? const Icon(Icons.person, size: 32)
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
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text("${store["rating"] ?? 0}"),
                  ],
                ),
                Text(
                  "${store["followers"] ?? 0} ผู้ติดตาม",
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          if (!isOwner)
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
    );
  }
}
