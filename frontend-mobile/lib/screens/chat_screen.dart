import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/controller/chat_controller.dart';
import 'package:myprojectshop/theme/theme.dart';
import 'package:intl/intl.dart';
import 'package:myprojectshop/widgets/app_drawer.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final ChatController controller = Get.find<ChatController>();
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppTheme.primaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Obx(
          () => Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Icon(
                  controller.isAiMode.value
                      ? Icons.smart_toy
                      : Icons.support_agent,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.isAiMode.value
                        ? "AI Assistant"
                        : "Technical Support",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    controller.isAiMode.value
                        ? "Powered by Gemini"
                        : "Online 24/7",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          // AI Toggle Switch
          Obx(
            () => Switch(
              value: controller.isAiMode.value,
              onChanged: (value) => controller.toggleAiMode(),
              activeColor: Colors.white,
              activeTrackColor: Colors.greenAccent,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.white.withOpacity(0.3),
            ),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isAiMode.value) {
                return _buildAiChatList();
              } else {
                return _buildFirestoreChatList();
              }
            }),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildAiChatList() {
    return Obx(() {
      if (controller.aiMessages.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.smart_toy, size: 64, color: Colors.grey[300]),
              SizedBox(height: 16),
              Text(
                "Ask me anything about fashion! 👗",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount:
            controller.aiMessages.length +
            (controller.isAiLoading.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == controller.aiMessages.length) {
            return Center(child: CircularProgressIndicator());
          }

          final msg = controller.aiMessages[index];
          return _buildMessageBubble(
            message: msg['text'],
            isMe: msg['isMe'],
            time: DateFormat('hh:mm a').format(msg['time']),
            senderName: msg['isMe'] ? "Me" : "Gemini AI",
            isAi: !msg['isMe'],
          );
        },
      );
    });
  }

  Widget _buildFirestoreChatList() {
    return StreamBuilder<QuerySnapshot>(
      stream: controller.getMessages(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return Center(child: Text("How can we help you today? 🛠️"));
        }

        return ListView.builder(
          reverse: true,
          padding: EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final isMe = data['senderId'] == controller.currentUserId;

            String time = '';
            if (data['createdAt'] != null) {
              final Timestamp timestamp = data['createdAt'];
              time = DateFormat('hh:mm a').format(timestamp.toDate());
            }

            return _buildMessageBubble(
              message: data['text'] ?? '',
              isMe: isMe,
              time: time,
              senderName: data['senderName'] ?? 'Unknown',
            );
          },
        );
      },
    );
  }

  Widget _buildMessageBubble({
    required String message,
    required bool isMe,
    required String time,
    required String senderName,
    bool isAi = false,
  }) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        constraints: BoxConstraints(maxWidth: Get.width * 0.85),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isAi)
                      Icon(Icons.smart_toy, size: 12, color: Colors.purple),
                    if (isAi) SizedBox(width: 4),
                    Text(
                      senderName,
                      style: TextStyle(
                        fontSize: 10,
                        color: isAi ? Colors.purple : Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color:
                    isMe
                        ? AppTheme.primaryColor
                        : (isAi ? Colors.purple[50] : Colors.white),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: isMe ? Radius.circular(20) : Radius.zero,
                  bottomRight: isMe ? Radius.zero : Radius.circular(20),
                ),
                border:
                    isAi
                        ? Border.all(color: Colors.purple.withOpacity(0.2))
                        : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      color: isMe ? Colors.white70 : Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: Obx(
              () => CircleAvatar(
                radius: 22,
                backgroundColor:
                    controller.isAiMode.value
                        ? Colors.purple
                        : AppTheme.primaryColor,
                child: Icon(
                  controller.isAiMode.value ? Icons.auto_awesome : Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (controller.isAiMode.value) {
      controller.sendAiMessage(_messageController.text);
    } else {
      controller.sendMessage(_messageController.text);
    }
    _messageController.clear();
  }
}
