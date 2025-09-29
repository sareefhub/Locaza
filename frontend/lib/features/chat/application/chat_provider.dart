import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../infrastructure/chat_api.dart';
import 'package:frontend/utils/user_session.dart';

final chatApiProvider = Provider<ChatApi>((ref) => ChatApi());

/// คืน currentUserId จาก session
final currentUserIdProvider = Provider<String>((ref) {
  return UserSession.id ?? '';
});

/// คืนรายการ chatrooms ของผู้ใช้ปัจจุบัน พร้อม other_user_avatar และ last_message
final chatroomsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
      final api = ref.watch(chatApiProvider);
      final currentUserId = ref.watch(currentUserIdProvider);

      // ดึง chatrooms ทั้งหมดจาก backend
      final allChatrooms = await api.getChatrooms();

      // กรองเฉพาะ chatrooms ของ currentUserId
      final userChatrooms = allChatrooms
          .where((chat) {
            return chat['buyer_id'].toString() == currentUserId ||
                chat['seller_id'].toString() == currentUserId;
          })
          .map((chat) {
            final isCurrentUserBuyer =
                chat['buyer_id'].toString() == currentUserId;

            // ข้อมูลผู้ใช้คู่สนทนา
            final otherUserId = isCurrentUserBuyer
                ? chat['seller_id']
                : chat['buyer_id'];
            final otherUserName = isCurrentUserBuyer
                ? chat['seller_name']
                : chat['buyer_name'];
            final otherUserAvatar = isCurrentUserBuyer
                ? chat['seller_avatar']
                : chat['buyer_avatar'];

            // ข้อความล่าสุด
            final lastMessageData =
                chat['messages'] != null && chat['messages'].isNotEmpty
                ? chat['messages'].last
                : null;
            final lastMessage = lastMessageData != null
                ? lastMessageData['content']
                : '';
            final lastMessageTime = lastMessageData != null
                ? lastMessageData['created_at']
                : chat['updated_at'];

            return {
              'id': chat['id'],
              'buyer_id': chat['buyer_id'],
              'seller_id': chat['seller_id'],
              'buyer_name': chat['buyer_name'],
              'seller_name': chat['seller_name'],
              'product_title': chat['product_title'],
              'product_price': chat['product_price'],
              'product_images': chat['product_images'],
              'other_user_id': otherUserId,
              'other_user_name': otherUserName,
              'other_user_avatar': otherUserAvatar,
              'last_message': lastMessage,
              'last_message_time': lastMessageTime,
            };
          })
          .toList();

      return userChatrooms;
    });

/// คืนข้อความทั้งหมดใน chatroom
final chatMessagesProvider = FutureProvider.family
    .autoDispose<List<Map<String, dynamic>>, int>((ref, chatroomId) async {
      final api = ref.watch(chatApiProvider);
      return api.getMessages(chatroomId);
    });

/// ส่งข้อความ
final sendMessageProvider = FutureProvider.family
    .autoDispose<Map<String, dynamic>, Map<String, dynamic>>((
      ref,
      params,
    ) async {
      final api = ref.watch(chatApiProvider);
      return api.sendMessage(
        chatroomId: params["chatroomId"],
        senderId: params["senderId"],
        content: params["content"],
        messageType: params["messageType"] ?? "text",
        imageUrls: params["imageUrls"],
      );
    });

/// อัปโหลดรูปภาพใน chat
final uploadChatImageProvider = FutureProvider.family
    .autoDispose<String?, Map<String, dynamic>>((ref, params) async {
      final api = ref.watch(chatApiProvider);
      final chatroomId = params["chatroomId"] as int;
      final file = params["file"] as File;
      return api.uploadChatImage(chatroomId, file);
    });
