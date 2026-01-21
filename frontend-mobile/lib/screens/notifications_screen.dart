import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/l10n/l10n_extension.dart';
import 'package:myprojectshop/controller/auth_controller.dart';
import 'package:myprojectshop/controller/notification_controller.dart';
import 'package:myprojectshop/theme/theme.dart';
import 'package:intl/intl.dart';
import 'package:myprojectshop/widgets/custom_app_bar.dart';

class NotificationsScreen extends StatelessWidget {
  final NotificationController notificationController =
      Get.find<NotificationController>();
  final AuthController authController = Get.find<AuthController>();

  NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = authController.currentUserId;
    // Notification stream is bound in controller or main screen

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Obx(() {
        if (notificationController.isLoading.value) {
          return Scaffold(
            appBar: CustomAppBar(
              title: context.l10n.notifications,
              showBackButton: true,
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (notificationController.notifications.isEmpty) {
          return Scaffold(
            appBar: CustomAppBar(
              title: context.l10n.notifications,
              showBackButton: true,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 16),
                  Text(
                    context.l10n.noNotifications,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    context.l10n.notifyWhenArrives,
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverCustomAppBar(
              title: context.l10n.notifications,
              showBackButton: true,
              actions: [
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 'read_all') {
                      notificationController.markAllAsRead(
                        authController.currentUserId!,
                      );
                    }
                  },
                  itemBuilder:
                      (context) => [
                        PopupMenuItem(
                          value: 'read_all',
                          child: Row(
                            children: [
                              Icon(
                                Icons.done_all,
                                color: AppTheme.primaryColor,
                              ),
                              SizedBox(width: 8),
                              Text(context.l10n.markAllRead),
                            ],
                          ),
                        ),
                      ],
                ),
              ],
            ),
            SliverPadding(
              padding: EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final notification =
                      notificationController.notifications[index];
                  return _buildNotificationItem(context, notification);
                }, childCount: notificationController.notifications.length),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    NotificationModel notification,
  ) {
    final IconData icon;
    final Color iconColor;

    switch (notification.type) {
      case 'order':
        icon = Icons.inventory_2;
        iconColor = AppTheme.primaryColor;
        break;
      case 'promo':
        icon = Icons.local_offer;
        iconColor = Colors.orange;
        break;
      case 'shipping':
        icon = Icons.local_shipping;
        iconColor = Colors.blue;
        break;
      default:
        icon = Icons.notifications;
        iconColor = AppTheme.primaryColor;
    }

    return Dismissible(
      key: Key(notification.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        notificationController.deleteNotification(
          notification.id!,
          authController.currentUserId!,
        );
      },
      child: GestureDetector(
        onTap: () {
          if (!notification.isRead) {
            notificationController.markAsRead(
              notification.id!,
              authController.currentUserId!,
            );
          }
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color:
                notification.isRead
                    ? Colors.white
                    : AppTheme.primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border:
                notification.isRead
                    ? null
                    : Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                      width: 1,
                    ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontWeight:
                                    notification.isRead
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                                fontSize: 15,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Text(
                        _formatDate(notification.createdAt, context),
                        style: TextStyle(color: Colors.grey[400], fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateStr, BuildContext context) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inMinutes < 60) {
        return '${difference.inMinutes} ${context.l10n.minAgo}';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} ${context.l10n.hoursAgo}';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} ${context.l10n.daysAgo}';
      } else {
        return DateFormat('MMM d, yyyy').format(date);
      }
    } catch (e) {
      return dateStr;
    }
  }
}
