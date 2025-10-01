final List<Map<String, dynamic>> dummyChatrooms = [
  // Chatroom 1: current user 103 เป็น buyer
  {
    "id": 1,
    "buyer_id": 103,
    "seller_id": 101,
    "product_id": 1, // มะม่วงออร์แกนิก
    "created_at": DateTime.now().subtract(const Duration(days: 1)),
  },
  // Chatroom 2: current user 103 เป็น buyer
  {
    "id": 2,
    "buyer_id": 103,
    "seller_id": 102,
    "product_id": 2, // ตะกร้าสานไม้ไผ่
    "created_at": DateTime.now().subtract(const Duration(hours: 12)),
  },
  // Chatroom 3: current user 103 เป็น seller
  {
    "id": 3,
    "buyer_id": 104,
    "seller_id": 103,
    "product_id": 3, // ขวดนมเด็ก
    "created_at": DateTime.now().subtract(const Duration(hours: 3)),
  },
];
