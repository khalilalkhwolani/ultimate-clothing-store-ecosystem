import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/model/order_model.dart' as model;
import 'package:myprojectshop/model/orderitem_model.dart';
import 'package:myprojectshop/utils/app_snackbar.dart';

class OrderItemController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var orderItems = <OrderItem>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  /// Fetch items by orderId
  Future<List<OrderItem>> fetchOrderItemsByOrderId(String orderId) async {
    try {
      isLoading.value = true;
      DocumentSnapshot doc =
          await _firestore.collection('orders').doc(orderId).get();
      if (doc.exists) {
        model.Order order = model.Order.fromMap(
          doc.data() as Map<String, dynamic>,
        );
        orderItems.value = order.items;
        return order.items;
      }
      return [];
    } catch (e) {
      AppSnackbar.showError('Failed to load order items: $e');
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  /// Add item to the order
  Future<OrderItem?> addOrderItem(OrderItem item) async {
    try {
      // Fetch current order
      DocumentSnapshot doc =
          await _firestore.collection('orders').doc(item.orderId).get();
      if (doc.exists) {
        model.Order order = model.Order.fromMap(
          doc.data() as Map<String, dynamic>,
        );

        // Add new item to list
        List<OrderItem> updatedItems = List.from(order.items);
        updatedItems.add(item);

        // Update Firestore
        await _firestore.collection('orders').doc(item.orderId).update({
          'items': updatedItems.map((i) => i.toMap()).toList(),
          'totalAmount': order.totalAmount + (item.price * item.quantity),
        });

        fetchOrderItemsByOrderId(item.orderId);
        AppSnackbar.showSuccess('Item added to the order successfully');
        return item;
      }
      return null;
    } catch (e) {
      AppSnackbar.showError('Failed to add item to the order: $e');
      return null;
    }
  }

  /// Delete an item from the order
  Future<void> deleteOrderItem(String itemId, String orderId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('orders').doc(orderId).get();
      if (doc.exists) {
        model.Order order = model.Order.fromMap(
          doc.data() as Map<String, dynamic>,
        );

        // Remove item
        List<OrderItem> updatedItems = List.from(order.items);
        OrderItem? itemToRemove = updatedItems.firstWhereOrNull(
          (item) => item.id == itemId,
        );

        if (itemToRemove != null) {
          updatedItems.remove(itemToRemove);

          // Update Firestore
          await _firestore.collection('orders').doc(orderId).update({
            'items': updatedItems.map((i) => i.toMap()).toList(),
            'totalAmount':
                order.totalAmount -
                (itemToRemove.price * itemToRemove.quantity),
          });

          orderItems.value = updatedItems;
          AppSnackbar.showSuccess(
            'Order item deleted successfully',
            title: 'Deleted',
          );
        }
      }
    } catch (e) {
      AppSnackbar.showError('Failed to delete order item: $e');
    }
  }
}
