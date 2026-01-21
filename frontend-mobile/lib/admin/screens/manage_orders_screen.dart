import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/controller/order_controller.dart';
import 'package:myprojectshop/model/order_model.dart';
import 'package:myprojectshop/theme/theme.dart';

class ManageOrdersScreen extends StatelessWidget {
  ManageOrdersScreen({super.key});

  final OrderController controller = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Orders'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: controller.orders.length,
          itemBuilder: (context, index) {
            final order = controller.orders[index];
            return ListTile(
              title: Text('Order #${order.id}'),
              subtitle: Text('Total: \$${order.totalAmount.toStringAsFixed(2)} - Status: ${order.status}'),
              onTap: () => _showOrderDetails(order),
            );
          },
        );
      }),
    );
  }

  void _showOrderDetails(Order order) {
    Get.defaultDialog(
      title: 'Order Details',
      content: Column(
        children: order.items.map((item) => Text('${item.product.name}: ${item.quantity}')).toList(),
      ),
    );
  }
}