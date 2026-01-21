import 'package:myprojectshop/model/orderitem_model.dart';

class Order {
  final String? id;
  final String? orderNumber; // Laravel order number
  final String userId;
  final String orderDate;
  final double totalAmount;
  final String status;
  final List<OrderItem> items;

  // Shipping Info
  final String? shippingName;
  final String? shippingAddress;
  final String? shippingPhone;

  // Delivery Info
  final String? deliveryMethod;
  final double? shippingCost;
  final String? estimatedDelivery;

  // Payment Info
  final String? paymentMethod;
  final String? paymentStatus;

  // Order Tracking
  final String? trackingNumber;
  final List<OrderStatus>? statusHistory;

  Order({
    this.id,
    this.orderNumber,
    required this.userId,
    required this.orderDate,
    required this.totalAmount,
    required this.items,
    this.status = 'Pending',
    this.shippingName,
    this.shippingAddress,
    this.shippingPhone,
    this.deliveryMethod,
    this.shippingCost,
    this.estimatedDelivery,
    this.paymentMethod,
    this.paymentStatus,
    this.trackingNumber,
    this.statusHistory,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id']?.toString(),
      orderNumber: map['order_number']?.toString(),
      userId: map['userId']?.toString() ?? '',
      orderDate: map['orderDate'] ?? '',
      totalAmount:
          (map['totalAmount'] is int)
              ? (map['totalAmount'] as int).toDouble()
              : (map['totalAmount'] ?? 0.0),
      status: map['status'] ?? 'Pending',
      items:
          map['items'] != null
              ? List<OrderItem>.from(
                (map['items'] as List).map((item) => OrderItem.fromMap(item)),
              )
              : [],
      // Shipping Info
      shippingName: map['shippingName'],
      shippingAddress: map['shippingAddress'],
      shippingPhone: map['shippingPhone'],
      // Delivery Info
      deliveryMethod: map['deliveryMethod'],
      shippingCost:
          map['shippingCost'] != null
              ? (map['shippingCost'] is int
                  ? (map['shippingCost'] as int).toDouble()
                  : map['shippingCost'])
              : null,
      estimatedDelivery: map['estimatedDelivery'],
      // Payment Info
      paymentMethod: map['paymentMethod'],
      paymentStatus: map['paymentStatus'] ?? 'Pending',
      // Tracking
      trackingNumber: map['trackingNumber'],
      statusHistory:
          map['statusHistory'] != null
              ? List<OrderStatus>.from(
                (map['statusHistory'] as List).map(
                  (s) => OrderStatus.fromMap(s),
                ),
              )
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'userId': userId,
      'orderDate': orderDate,
      'totalAmount': totalAmount,
      'status': status,
      'items': items.map((item) => item.toMap()).toList(),
      // Shipping Info
      'shippingName': shippingName,
      'shippingAddress': shippingAddress,
      'shippingPhone': shippingPhone,
      // Delivery Info
      'deliveryMethod': deliveryMethod,
      'shippingCost': shippingCost,
      'estimatedDelivery': estimatedDelivery,
      // Payment Info
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      // Tracking
      'trackingNumber': trackingNumber,
      'statusHistory': statusHistory?.map((s) => s.toMap()).toList(),
    };
  }

  // Helper to get current status step (0-4)
  int get currentStatusStep {
    switch (status.toLowerCase()) {
      case 'pending':
        return 0;
      case 'confirmed':
        return 1;
      case 'shipped':
        return 2;
      case 'out for delivery':
        return 3;
      case 'delivered':
        return 4;
      case 'cancelled':
        return -1;
      default:
        return 0;
    }
  }

  // Copy with method for updating order
  Order copyWith({
    String? id,
    String? orderNumber,
    String? userId,
    String? orderDate,
    double? totalAmount,
    String? status,
    List<OrderItem>? items,
    String? shippingName,
    String? shippingAddress,
    String? shippingPhone,
    String? deliveryMethod,
    double? shippingCost,
    String? estimatedDelivery,
    String? paymentMethod,
    String? paymentStatus,
    String? trackingNumber,
    List<OrderStatus>? statusHistory,
  }) {
    return Order(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      userId: userId ?? this.userId,
      orderDate: orderDate ?? this.orderDate,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      items: items ?? this.items,
      shippingName: shippingName ?? this.shippingName,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      shippingPhone: shippingPhone ?? this.shippingPhone,
      deliveryMethod: deliveryMethod ?? this.deliveryMethod,
      shippingCost: shippingCost ?? this.shippingCost,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      statusHistory: statusHistory ?? this.statusHistory,
    );
  }

  /// Convert Order to Laravel API JSON format
  Map<String, dynamic> toApiJson() {
    return {
      'user_id': userId,
      'total_amount': totalAmount,
      'shipping_address': {
        'name': shippingName ?? '',
        'address': shippingAddress ?? '',
        'phone': shippingPhone ?? '',
      },
      'billing_address': {
        'name': shippingName ?? '',
        'address': shippingAddress ?? '',
        'phone': shippingPhone ?? '',
      },
      'payment_method': paymentMethod ?? 'cash_on_delivery',
      'items':
          items
              .map(
                (item) => {
                  'product_variant_id': item.productId,
                  'quantity': item.quantity,
                  'price': item.price,
                },
              )
              .toList(),
    };
  }
}

// Order Status History Model
class OrderStatus {
  final String status;
  final String date;
  final String? description;

  OrderStatus({required this.status, required this.date, this.description});

  factory OrderStatus.fromMap(Map<String, dynamic> map) {
    return OrderStatus(
      status: map['status'] ?? '',
      date: map['date'] ?? '',
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'status': status, 'date': date, 'description': description};
  }
}
