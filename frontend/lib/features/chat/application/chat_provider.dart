import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../infrastructure/chat_api.dart';

final chatApiProvider = Provider<ChatApi>((ref) => ChatApi());

final chatroomsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final api = ref.watch(chatApiProvider);
  return api.getChatrooms();
});

final chatMessagesProvider = FutureProvider.family
    .autoDispose<List<Map<String, dynamic>>, int>((ref, chatroomId) async {
  final api = ref.watch(chatApiProvider);
  return api.getMessages(chatroomId);
});

final sendMessageProvider =
    FutureProvider.family.autoDispose<Map<String, dynamic>, Map<String, dynamic>>(
        (ref, params) async {
  final api = ref.watch(chatApiProvider);
  return api.sendMessage(
    chatroomId: params["chatroomId"],
    senderId: params["senderId"],
    content: params["content"],
    messageType: params["messageType"] ?? "text",
    imageUrls: params["imageUrls"],
  );
});

final uploadChatImageProvider =
    FutureProvider.family.autoDispose<String?, Map<String, dynamic>>(
        (ref, params) async {
  final api = ref.watch(chatApiProvider);
  final chatroomId = params["chatroomId"] as int;
  final file = params["file"] as File;
  return api.uploadChatImage(chatroomId, file);
});
