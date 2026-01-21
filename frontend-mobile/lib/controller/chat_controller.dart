import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/controller/auth_controller.dart';
import 'package:myprojectshop/service/gemini_service.dart';

class ChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthController _authController = Get.find<AuthController>();
  final GeminiService _geminiService = GeminiService();

  // AI Mode State
  final RxBool isAiMode = false.obs;
  final RxList<Map<String, dynamic>> aiMessages = <Map<String, dynamic>>[].obs;
  final RxBool isAiLoading = false.obs;

  void toggleAiMode() {
    isAiMode.value = !isAiMode.value;
  }

  Future<void> sendAiMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add User Message
    aiMessages.add({'text': text, 'isMe': true, 'time': DateTime.now()});

    isAiLoading.value = true;

    // Get AI Response
    final response = await _geminiService.sendMessage(text);

    isAiLoading.value = false;

    // Add AI Response
    aiMessages.add({'text': response, 'isMe': false, 'time': DateTime.now()});
  }

  // Observable list of messages
  // RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;

  // Collection reference
  CollectionReference get _chatsCollection {
    final userId = _authController.currentUser.value?.id;
    if (userId == null) {
      throw Exception("User not logged in");
    }
    return _firestore.collection('chats').doc(userId).collection('messages');
  }

  // Send Message
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final user = _authController.currentUser.value;
    if (user == null) return;

    try {
      await _chatsCollection.add({
        'text': text,
        'senderId': user.id,
        'senderName': user.username ?? 'User',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Update the main chat document with last message info for Admin List
      await _firestore.collection('chats').doc(user.id).set({
        'lastMessage': text,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'userName': user.username ?? 'User',
        'userEmail': user.email ?? '',
        'userId': user.id,
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error sending message: $e");
      Get.snackbar('Error', 'Failed to send message');
    }
  }

  // Get Messages Stream
  Stream<QuerySnapshot> getMessages() {
    try {
      return _chatsCollection
          .orderBy('createdAt', descending: true)
          .snapshots();
    } catch (e) {
      return Stream.empty();
    }
  }

  // Get Current User ID
  String? get currentUserId => _authController.currentUser.value?.id;
}
