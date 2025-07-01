import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/contact_model.dart';
import 'dart:async';
import 'dart:math';

class MessagePage extends StatefulWidget {
  final Contact contact;
  const MessagePage({super.key, required this.contact});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final List<Map<String, dynamic>> messages = [];
  final TextEditingController controller = TextEditingController();
  final random = Random();
  final scrollController = ScrollController();

  final List<String> textReplies = [
    "That's interesting!",
    "I'll get back to you.",
    "Sounds good.",
    "Can you explain more?",
    "Got it!",
    "Sure, no problem.",
    "Let's do that.",
    "Awesome!",
    "Thanks for sharing.",
    "I agree with you.",
  ];

  final List<String> imageReplies = [
    "Nice shot!",
    "Wow, beautiful!",
    "Where is this?",
    "Looks amazing!",
    "Love this pic!",
    "😍🔥📸",
    "Incredible!",
  ];

  void sendMessage() {
    if (controller.text.trim().isEmpty) return;

    setState(() {
      messages.add({
        "type": "text",
        "content": controller.text,
        "time": DateTime.now(),
        "from": "me",
      });
    });
    controller.clear();
    simulateReply(isImage: false);
    scrollToBottom();
  }

  Future<void> sendImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        messages.add({
          "type": "image",
          "content": bytes,
          "time": DateTime.now(),
          "from": "me",
        });
      });
      simulateReply(isImage: true);
      scrollToBottom();
    }
  }

  void simulateReply({required bool isImage}) {
    Future.delayed(const Duration(seconds: 1), () {
      final reply =
          isImage
              ? imageReplies[random.nextInt(imageReplies.length)]
              : textReplies[random.nextInt(textReplies.length)];
      setState(() {
        messages.add({
          "type": "text",
          "content": reply,
          "time": DateTime.now(),
          "from": "other",
        });
      });
      scrollToBottom();
    });
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with ${widget.contact.name}"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              reverse: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[messages.length - index - 1];
                final isMe = msg["from"] == "me";
                final time = msg["time"] as DateTime;
                final timeString =
                    "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                          isMe
                              ? Colors.deepPurple.shade100
                              : Colors.grey.shade300,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft:
                            isMe
                                ? const Radius.circular(16)
                                : const Radius.circular(0),
                        bottomRight:
                            isMe
                                ? const Radius.circular(0)
                                : const Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                      children: [
                        if (msg["type"] == "text") ...[
                          Text(msg["content"]),
                        ] else if (msg["type"] == "image") ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              msg["content"],
                              width: 160,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                        Text(
                          timeString,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: "Type your message...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.photo, color: Colors.deepPurple),
                    onPressed: sendImage,
                  ),
                  FilledButton(
                    onPressed: sendMessage,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                    ),
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
