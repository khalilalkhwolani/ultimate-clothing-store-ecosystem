import 'package:myprojectshop/model/product_model.dart';

class CartItem {
  final String? id;
  final String userId;
  final String productId;
  final int quantity;
  final Product product;
  final String? selectedSize;
  final String? selectedColor;

  CartItem({
    this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.product,
    this.selectedSize,
    this.selectedColor,
  });

  // دالة لحساب إجمالي السعر لهذا العنصر في السلة
  double get totalPrice => product.price * quantity;
  // تحويل CartItem إلى Map لتخزينه محلياً إذا لزم الأمر
  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'productId': productId,
    'quantity': quantity,
    'product': product.toMap(),
    'selectedSize': selectedSize,
    'selectedColor': selectedColor,
  };
  factory CartItem.fromMap(Map<String, dynamic> json) => CartItem(
    id: json['id']?.toString(),
    userId: json['userId']?.toString() ?? '',
    productId: json['productId']?.toString() ?? '',
    quantity: json['quantity'] ?? 0,
    product: Product.fromMap(json['product'] ?? {}),
    selectedSize: json['selectedSize']?.toString(),
    selectedColor: json['selectedColor']?.toString(),
  );

  // إنشاء نسخة جديدة من CartItem مع تحديث الكمية
  CartItem copyWith({
    int? quantity,
    String? selectedSize,
    String? selectedColor,
  }) {
    return CartItem(
      id: this.id,
      userId: this.userId,
      productId: this.productId,
      product: this.product,
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }
}
