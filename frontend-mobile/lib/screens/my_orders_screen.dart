import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myprojectshop/l10n/l10n_extension.dart';
import 'package:myprojectshop/controller/auth_controller.dart';
import 'package:myprojectshop/controller/order_controller.dart';
import 'package:myprojectshop/model/order_model.dart';
import 'package:myprojectshop/screens/order_tracking_screen.dart';
import 'package:myprojectshop/theme/theme.dart';
import 'package:myprojectshop/widgets/custom_app_bar.dart';
// import 'package:myprojectshop/widgets/custom_app_bar.dart';

class MyOrdersScreen extends StatelessWidget {
  final OrderController orderController = Get.find<OrderController>();
  final AuthController authController = Get.find<AuthController>();

  MyOrdersScreen({Key? key}) : super(key: key);

  // Format date nicely
  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy - HH:mm').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  // Get short order ID
  String _getShortOrderId(String? id) {
    if (id == null) return 'N/A';
    return id.length > 8 ? id.substring(0, 8).toUpperCase() : id.toUpperCase();
  }

  // Get localized status
  String _getLocalizedStatus(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return context.l10n.pending;
      case 'confirmed':
        return context.l10n.orderConfirmed;
      case 'shipped':
        return context.l10n.shipped;
      case 'out for delivery':
        return context.l10n.outForDelivery;
      case 'delivered':
        return context.l10n.delivered;
      case 'cancelled':
        return context.l10n.cancelled;
      default:
        return status;
    }
  }

  // Get status color
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'out for delivery':
        return Colors.indigo;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Fetch orders when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authController.currentUserId != null) {
        orderController.fetchOrdersForUser(authController.currentUserId!);
      }
    });

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Obx(() {
        if (orderController.isLoading.value) {
          return Scaffold(
            appBar: CustomAppBar(
              title: context.l10n.myOrders,
              showBackButton: true,
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (orderController.orders.isEmpty) {
          return Scaffold(
            appBar: CustomAppBar(
              title: context.l10n.myOrders,
              showBackButton: true,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 16),
                  Text(
                    context.l10n.noOrders,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    context.l10n.startShoppingOrders,
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(context.l10n.myOrders),
              centerTitle: true,
              backgroundColor: AppTheme.primaryColor,
              surfaceTintColor: AppTheme.primaryColor,
              pinned: true,
              snap: false,
              floating: false,
            ),
            SliverPadding(
              padding: EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  // Show newest first
                  final order =
                      orderController.orders[orderController.orders.length -
                          1 -
                          index];
                  return _buildOrderCard(context, order);
                }, childCount: orderController.orders.length),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildOrderCard(BuildContext context, Order order) {
    final statusColor = _getStatusColor(order.status);

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.inventory_2, color: AppTheme.primaryColor),
        ),
        title: Text(
          '${context.l10n.order} #${_getShortOrderId(order.id)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              _formatDate(order.orderDate),
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 4),
            Text(
              '\$${order.totalAmount.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _getLocalizedStatus(context, order.status),
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        children: [
          Divider(),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${context.l10n.items} (${order.items.length})",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                ...order.items
                    .map(
                      (item) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "${item.quantity}x ${item.product.name}",
                                style: TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              "\$${(item.price * item.quantity).toStringAsFixed(2)}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                SizedBox(height: 16),
                // Track Order Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Get.to(() => OrderTrackingScreen(order: order));
                    },
                    icon: Icon(Icons.local_shipping_outlined),
                    label: Text(context.l10n.trackOrder),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      foregroundColor: AppTheme.primaryColor,
                      side: BorderSide(color: AppTheme.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
