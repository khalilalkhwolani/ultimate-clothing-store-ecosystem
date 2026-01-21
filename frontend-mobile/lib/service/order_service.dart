import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myprojectshop/core/env.dart';
import 'package:myprojectshop/model/order_model.dart';

class OrderService {
  final String baseUrl = Env.laravelBaseUrl;

  /// Create a new order via Laravel API
  Future<Order?> createOrder(Order order) async {
    try {
      final url = Uri.parse('$baseUrl/checkout');

      // Convert order to Laravel API format
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(order.toApiJson()),
      );

      print('Create Order Response: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final orderData = jsonResponse['data']['order'];
        return Order.fromMap(orderData);
      } else {
        print('Failed to create order: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error creating order: $e');
      return null;
    }
  }

  /// Fetch all orders for a specific user
  Future<List<Order>> fetchUserOrders(String userId) async {
    try {
      final url = Uri.parse('$baseUrl/orders?user_id=$userId');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Fetch Orders Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> ordersData = jsonResponse['data'];
        return ordersData.map((json) => Order.fromMap(json)).toList();
      } else {
        print('Failed to fetch orders: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching orders: $e');
      return [];
    }
  }

  /// Fetch a single order by ID
  Future<Order?> fetchOrderById(String orderId) async {
    try {
      final url = Uri.parse('$baseUrl/orders/$orderId');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Fetch Order By ID Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final orderData = jsonResponse['data'];
        return Order.fromMap(orderData);
      } else {
        print('Failed to fetch order: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching order by ID: $e');
      return null;
    }
  }

  /// Update order status
  Future<bool> updateOrderStatus(String orderId, String status) async {
    try {
      final url = Uri.parse('$baseUrl/orders/$orderId');

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'status': status}),
      );

      print('Update Order Status Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update order status: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error updating order status: $e');
      return false;
    }
  }

  /// Track order (get tracking information)
  Future<Map<String, dynamic>?> trackOrder(String orderId) async {
    try {
      final url = Uri.parse('$baseUrl/orders/$orderId/track');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Track Order Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse['data'];
      } else {
        print('Failed to track order: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error tracking order: $e');
      return null;
    }
  }
}
