final List<Map<String, dynamic>> dummyMessages = [
  // Chatroom 1: current user 103 เป็น buyer
  {
    "id": 1,
    "chatroom_id": 1,
    "sender_id": 103, // current user เป็น buyer
    "content": "สวัสดีครับ สนใจสินค้านี้ครับ",
    "message_type": "text",
    "is_read": true,
    "created_at": DateTime.now().subtract(const Duration(hours: 5)),
  },
  {
    "id": 2,
    "chatroom_id": 1,
    "sender_id": 101, // seller
    "content": "ได้เลยครับ สินค้ายังอยู่ครับ",
    "message_type": "text",
    "is_read": true,
    "created_at": DateTime.now().subtract(
      const Duration(hours: 4, minutes: 45),
    ),
  },

  // Chatroom 2: current user 103 เป็น buyer
  {
    "id": 3,
    "chatroom_id": 2,
    "sender_id": 103, // current user เป็น buyer
    "content": "สวัสดีครับ สนใจสินค้านี้ครับ",
    "message_type": "text",
    "is_read": false,
    "created_at": DateTime.now().subtract(const Duration(hours: 2)),
  },
  {
    "id": 4,
    "chatroom_id": 2,
    "sender_id": 102, // seller
    "content": "มีครับ ตอนนี้ลด 10%",
    "message_type": "text",
    "is_read": false,
    "created_at": DateTime.now().subtract(
      const Duration(hours: 1, minutes: 50),
    ),
  },

  // Chatroom 3: current user 103 เป็น seller
  {
    "id": 5,
    "chatroom_id": 3,
    "sender_id": 104, // buyer
    "content": "ของยังมีไหมครับ?",
    "message_type": "text",
    "is_read": false,
    "created_at": DateTime.now().subtract(const Duration(minutes: 50)),
  },
  {
    "id": 6,
    "chatroom_id": 3,
    "sender_id": 103, // current user เป็น seller
    "content": "มีครับ พร้อมส่งวันนี้",
    "message_type": "text",
    "is_read": false,
    "created_at": DateTime.now().subtract(const Duration(minutes: 45)),
  },
];
