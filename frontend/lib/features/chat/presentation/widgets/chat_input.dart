import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatInput extends StatefulWidget {
  final TextEditingController messageController;
  final Function(String text, List<XFile> images) onSend;

  const ChatInput({
    super.key,
    required this.messageController,
    required this.onSend,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedImages = [];

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages = images;
      });
    }
  }

  void _sendMessage() {
    final text = widget.messageController.text.trim();
    if (text.isEmpty && _selectedImages.isEmpty) return;

    widget.onSend(text, _selectedImages);

    widget.messageController.clear();
    setState(() => _selectedImages = []);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            IconButton(
              icon: ImageIcon(AssetImage('assets/icons/picture.png'), size: 30),
              onPressed: _pickImages,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFC9E1E6),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: widget.messageController,
                  decoration: const InputDecoration(
                    hintText: 'พิมพ์ข้อความ.....',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: const Color(0xFF062252),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
