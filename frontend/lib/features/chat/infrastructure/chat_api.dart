import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../../../config/api_config.dart';

class ChatApi {
  final String chatroomUrl = "${ApiConfig.baseUrl}/chatrooms/";
  final String messageUrl = "${ApiConfig.baseUrl}/messages/";
  final String uploadChatUrl = "${ApiConfig.baseUrl}/upload/chat/";

  Future<List<Map<String, dynamic>>> getChatrooms() async {
    final url = Uri.parse(chatroomUrl);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception("Failed to load chatrooms");
    }
  }

  Future<List<Map<String, dynamic>>> getMessages(int chatroomId) async {
    final url = Uri.parse("${messageUrl}$chatroomId");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception("Failed to load messages");
    }
  }

  Future<Map<String, dynamic>> sendMessage({
    required int chatroomId,
    required int senderId,
    String? content,
    String messageType = "text",
    List<String>? imageUrls,
  }) async {
    final url = Uri.parse(messageUrl);
    final body = {
      "chatroom_id": chatroomId,
      "sender_id": senderId,
      "content": content,
      "message_type": messageType,
    };
    if (imageUrls != null && imageUrls.isNotEmpty) {
      body["image_urls"] = imageUrls;
    }
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to send message");
    }
  }

  Future<String?> uploadChatImage(int chatroomId, File file) async {
    final url = Uri.parse("$uploadChatUrl$chatroomId");
    final request = http.MultipartRequest("POST", url);
    request.files.add(
      await http.MultipartFile.fromPath(
        "file",
        file.path,
        contentType: MediaType("image", "jpeg"),
      ),
    );
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["image_url"] as String?;
    } else {
      throw Exception(
        "Upload chat image failed: ${response.statusCode} ${response.body}",
      );
    }
  }
}

Future<String> createOrGetChatroom({
  required int currentUserId,
  required int sellerId,
  required int productId,
}) async {
  final api = ChatApi();

  // เรียก API เพื่อเช็คว่ามี chatroom ระหว่าง user กับ seller สำหรับ product นี้หรือยัง
  final chatrooms = await api.getChatrooms();

  // หา chatroom ที่ตรงกับ user, seller และ product
  final existing = chatrooms.firstWhere(
    (chat) =>
        (chat['buyer_id'] == currentUserId &&
            chat['seller_id'] == sellerId &&
            chat['product_id'] == productId) ||
        (chat['buyer_id'] == sellerId &&
            chat['seller_id'] == currentUserId &&
            chat['product_id'] == productId),
    orElse: () => {},
  );

  if (existing.isNotEmpty) {
    // มี chatroom อยู่แล้ว → return chatroomId
    return existing['id'].toString();
  } else {
    // ยังไม่มี → สร้าง chatroom ใหม่ผ่าน API
    final url = Uri.parse("${ApiConfig.baseUrl}/chatrooms/");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "buyer_id": currentUserId,
        "seller_id": sellerId,
        "product_id": productId,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['id'].toString();
    } else {
      throw Exception("Failed to create chatroom: ${response.statusCode}");
    }
  }
}
