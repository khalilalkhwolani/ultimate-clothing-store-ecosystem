import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/controller/auth_controller.dart';

class NotificationModel {
  final String? id;
  final String userId;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final String createdAt;

  NotificationModel({
    this.id,
    required this.userId,
    required this.title,
    required this.message,
    this.type = 'general',
    this.isRead = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'message': message,
      'type': type,
      'isRead': isRead,
      'createdAt': createdAt,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id']?.toString(),
      userId: map['userId']?.toString() ?? '',
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      type: map['type'] ?? 'general',
      isRead: map['isRead'] == true,
      createdAt: map['createdAt'] ?? '',
    );
  }
}

class NotificationController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxInt unreadCount = 0.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Bind stream if user is already logged in
    final userId = Get.find<AuthController>().currentUserId;
    if (userId != null) {
      bindNotificationsStream(userId);
    }
  }

  void bindNotificationsStream(String userId) {
    isLoading.value = true;
    try {
      final stream = _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return NotificationModel.fromMap(data);
            }).toList();
          });

      notifications.bindStream(stream);

      // Listen to changes to update unread count
      ever(notifications, (_) => updateUnreadCount());
    } catch (e) {
      print("Error binding notifications stream: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void updateUnreadCount() {
    unreadCount.value = notifications.where((n) => !n.isRead).length;
  }

  Future<void> markAsRead(String id, String userId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .doc(id)
          .update({'isRead': true});

      final index = notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        final n = notifications[index];
        notifications[index] = NotificationModel(
          id: n.id,
          userId: n.userId,
          title: n.title,
          message: n.message,
          type: n.type,
          isRead: true,
          createdAt: n.createdAt,
        );
        updateUnreadCount();
      }
    } catch (e) {
      print("Error marking as read: $e");
    }
  }

  Future<void> markAllAsRead(String userId) async {
    try {
      final batch = _firestore.batch();
      final unreadDocs =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('notifications')
              .where('isRead', isEqualTo: false)
              .get();

      for (var doc in unreadDocs.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      await batch.commit();
      // Stream will update automatically
      // await fetchNotifications(userId);
    } catch (e) {
      print("Error marking all as read: $e");
    }
  }

  Future<void> deleteNotification(String id, String userId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .doc(id)
          .delete();

      notifications.removeWhere((n) => n.id == id);
      updateUnreadCount();
    } catch (e) {
      print("Error deleting notification: $e");
    }
  }

  Future<void> addNotification(
    String userId,
    String title,
    String message, {
    String type = 'general',
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .add({
            'userId': userId,
            'title': title,
            'message': message,
            'type': type,
            'isRead': false,
            'createdAt': DateTime.now().toIso8601String(),
          });
      // Optionally fetch notifications if needed, but usually this is called from background or other user actions
      // If called from the same user, we might want to refresh
      // await fetchNotifications(userId);
    } catch (e) {
      print("Error adding notification: $e");
    }
  }
}
