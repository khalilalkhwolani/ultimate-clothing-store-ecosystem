import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:get/get.dart';
import 'package:myprojectshop/core/app_config.dart';
import 'package:myprojectshop/model/order_model.dart';
import 'package:myprojectshop/service/order_service.dart';
import 'package:myprojectshop/utils/app_snackbar.dart';

class OrderController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final OrderService _orderService;

  final RxList<Order> orders = <Order>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _orderService = OrderService();
  }

  /// Fetch orders based on current data source
  Future<void> fetchOrders() async {
    if (AppConfig.to.currentDataSource.value == DataSource.Laravel) {
      await _fetchOrdersFromLaravel();
    } else {
      await _fetchOrdersFromFirebase();
    }
  }

  /// Fetch orders for a specific user
  Future<void> fetchOrdersForUser(String userId) async {
    if (AppConfig.to.currentDataSource.value == DataSource.Laravel) {
      await _fetchOrdersForUserFromLaravel(userId);
    } else {
      await _fetchOrdersForUserFromFirebase(userId);
    }
  }

  /// Insert a new order
  Future<String?> insertOrder(Order order) async {
    if (AppConfig.to.currentDataSource.value == DataSource.Laravel) {
      return await _insertOrderToLaravel(order);
    } else {
      return await _insertOrderToFirebase(order);
    }
  }

  /// Fetch order by ID
  Future<Order?> fetchOrderById(String id) async {
    if (AppConfig.to.currentDataSource.value == DataSource.Laravel) {
      return await _fetchOrderByIdFromLaravel(id);
    } else {
      return await _fetchOrderByIdFromFirebase(id);
    }
  }

  /// Update order
  Future<void> updateOrder(Order order) async {
    if (AppConfig.to.currentDataSource.value == DataSource.Laravel) {
      await _updateOrderInLaravel(order);
    } else {
      await _updateOrderInFirebase(order);
    }
  }

  /// Delete order
  Future<bool> deleteOrder(String id) async {
    if (AppConfig.to.currentDataSource.value == DataSource.Laravel) {
      return await _deleteOrderFromLaravel(id);
    } else {
      return await _deleteOrderFromFirebase(id);
    }
  }

  /// Track order (Laravel only)
  Future<Map<String, dynamic>?> trackOrder(String orderId) async {
    try {
      isLoading.value = true;
      final trackingData = await _orderService.trackOrder(orderId);
      return trackingData;
    } catch (e) {
      errorMessage.value = 'Failed to track order: $e';
      _showError('Error', errorMessage.value);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== LARAVEL METHODS ====================

  Future<void> _fetchOrdersFromLaravel() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Note: This fetches all orders, might need user_id filter
      final fetchedOrders = await _orderService.fetchUserOrders('');
      orders.assignAll(fetchedOrders);
    } catch (e) {
      errorMessage.value = 'Failed to fetch orders: $e';
      _showError('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchOrdersForUserFromLaravel(String userId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final fetchedOrders = await _orderService.fetchUserOrders(userId);
      orders.assignAll(fetchedOrders);
    } catch (e) {
      errorMessage.value = 'Failed to fetch user orders: $e';
      _showError('Error', errorMessage.value);
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> _insertOrderToLaravel(Order order) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final createdOrder = await _orderService.createOrder(order);

      if (createdOrder == null) {
        AppSnackbar.showError('Failed to place order');
        return null;
      }

      // Add to local list
      orders.insert(0, createdOrder);

      AppSnackbar.showSuccess('Order placed successfully');
      return createdOrder.id;
    } catch (e) {
      errorMessage.value = 'Failed to place order: $e';
      _showError('Error', errorMessage.value);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<Order?> _fetchOrderByIdFromLaravel(String id) async {
    try {
      final order = await _orderService.fetchOrderById(id);
      if (order == null) {
        AppSnackbar.showError('Failed to load order details');
      }
      return order;
    } catch (e) {
      print("Error fetching order by ID: $e");
      AppSnackbar.showError('Failed to load order details');
      return null;
    }
  }

  Future<void> _updateOrderInLaravel(Order order) async {
    try {
      isLoading.value = true;
      if (order.id == null) return;

      final success = await _orderService.updateOrderStatus(
        order.id!,
        order.status,
      );

      if (success) {
        // Update local list
        int index = orders.indexWhere((o) => o.id == order.id);
        if (index != -1) {
          orders[index] = order;
        }
        AppSnackbar.showSuccess('Order updated successfully');
      } else {
        AppSnackbar.showError('Failed to update order');
      }
    } catch (e) {
      _showError('Error', 'Failed to update order: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> _deleteOrderFromLaravel(String id) async {
    try {
      isLoading.value = true;
      // Laravel API doesn't have delete endpoint yet
      // This is a placeholder
      AppSnackbar.showError('Delete not supported for Laravel orders');
      return false;
    } catch (e) {
      _showError('Error', 'Failed to delete order: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== FIREBASE METHODS ====================

  Future<void> _fetchOrdersFromFirebase() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      QuerySnapshot snapshot =
          await _firestore
              .collection('orders')
              .orderBy('orderDate', descending: true)
              .get();
      orders.assignAll(
        snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // Ensure ID is set from doc ID
          return Order.fromMap(data);
        }).toList(),
      );
    } catch (e) {
      errorMessage.value = 'Failed to fetch orders: $e';
      _showError('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchOrdersForUserFromFirebase(String userId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      QuerySnapshot snapshot =
          await _firestore
              .collection('orders')
              .where('userId', isEqualTo: userId)
              .orderBy('orderDate', descending: true)
              .get();

      orders.assignAll(
        snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return Order.fromMap(data);
        }).toList(),
      );
    } catch (e) {
      errorMessage.value = 'Failed to fetch user orders: $e';
      _showError('Error', errorMessage.value);
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> _insertOrderToFirebase(Order order) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Create a new document reference to get an ID
      DocumentReference docRef = _firestore.collection('orders').doc();

      // Update order with the new ID
      Map<String, dynamic> orderData = order.toMap();
      orderData['id'] = docRef.id;

      await docRef.set(orderData);

      // Deduct stock for each product in the order
      await _deductStock(order);

      // Refresh orders list locally
      orders.insert(0, Order.fromMap(orderData));

      AppSnackbar.showSuccess('Order placed successfully');

      return docRef.id;
    } catch (e) {
      errorMessage.value = 'Failed to place order: $e';
      _showError('Error', errorMessage.value);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<Order?> _fetchOrderByIdFromFirebase(String id) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('orders').doc(id).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Order.fromMap(data);
      }
      return null;
    } catch (e) {
      print("Error fetching order by ID: $e");
      AppSnackbar.showError('Failed to load order details');
      return null;
    }
  }

  Future<void> _updateOrderInFirebase(Order order) async {
    try {
      isLoading.value = true;
      if (order.id == null) return;

      await _firestore.collection('orders').doc(order.id).update(order.toMap());

      // Update local list
      int index = orders.indexWhere((o) => o.id == order.id);
      if (index != -1) {
        orders[index] = order;
      }

      AppSnackbar.showSuccess('Order updated successfully');
    } catch (e) {
      _showError('Error', 'Failed to update order: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> _deleteOrderFromFirebase(String id) async {
    try {
      isLoading.value = true;
      await _firestore.collection('orders').doc(id).delete();
      orders.removeWhere((o) => o.id == id);
      AppSnackbar.showSuccess('Order deleted successfully');
      return true;
    } catch (e) {
      _showError('Error', 'Failed to delete order: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Deduct stock from products when order is placed (Firebase only)
  Future<void> _deductStock(Order order) async {
    try {
      // Use batch for atomic updates
      WriteBatch batch = _firestore.batch();

      for (var item in order.items) {
        final productRef = _firestore
            .collection('products')
            .doc(item.productId);

        // Get current stock
        final productDoc = await productRef.get();
        if (productDoc.exists) {
          final currentStock = productDoc.data()?['stock'] ?? 0;
          final newStock = currentStock - item.quantity;

          // Update stock (don't go below 0)
          batch.update(productRef, {'stock': newStock < 0 ? 0 : newStock});
        }
      }

      await batch.commit();
      print('Stock deducted successfully for order');
    } catch (e) {
      print('Error deducting stock: $e');
      // Don't fail the order if stock update fails
    }
  }

  void _showError(String title, String message) {
    AppSnackbar.showError(message, title: title);
  }
}
