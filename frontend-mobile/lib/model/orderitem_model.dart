import 'package:myprojectshop/model/product_model.dart';

class OrderItem {
  final String? id;
  final String orderId;
  final String productId;
  final double price;
  final int quantity;
  final Product product;

  OrderItem({
    this.id,
    required this.orderId,
    required this.productId,
    required this.price,
    required this.quantity,
    required this.product,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id']?.toString(),
      orderId: map['orderId']?.toString() ?? '',
      productId: map['productId']?.toString() ?? '',
      price:
          (map['price'] is int)
              ? (map['price'] as int).toDouble()
              : (map['price'] ?? 0.0),
      quantity: map['quantity'] ?? 0,
      product: Product.fromMap(map['product'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderId': orderId,
      'productId': productId,
      'price': price,
      'quantity': quantity,
      'product': product.toMap(), // Include product details for history
    };
  }

  OrderItem copyWith({
    String? orderId,
    String? productId,
    int? quantity,
    double? price,
    Product? product,
  }) {
    return OrderItem(
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      product: product ?? this.product,
    );
  }
}
