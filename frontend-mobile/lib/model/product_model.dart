import 'dart:convert';

import 'package:myprojectshop/model/category_modle.dart'; // For JSON encoding/decoding attributes

class Product {
  final String? id; // Firestore Document ID
  String name;
  String? description;
  double price;
  String? imageUrl;
  String? categoryId; // Firestore Category ID
  int stock;
  Map<String, dynamic>? attributes;
  DateTime? createdAt;
  DateTime? updatedAt;

  Product({
    this.id,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
    this.categoryId,
    this.stock = 0,
    this.attributes,
    this.createdAt,
    this.updatedAt,
  });

  // Convert a Product object into a Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl ?? '',
      'categoryId': categoryId,
      'stock': stock,
      'attributes': attributes, // Firestore handles Maps natively
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Create a Product object from a Map retrieved from the database
  // Universal Factory: Handles both Firestore (Map) and API (JSON)
  factory Product.fromJson(Map<String, dynamic> json) {
    // Handle ID: Firestore uses 'id', API might use 'id' (int) or '_id' (String)
    final id = json['id']?.toString() ?? json['_id']?.toString();

    // Handle Name: Firestore uses 'name', API might use 'title' or 'product_name'
    final name = json['name'] ?? json['title'] ?? json['product_name'] ?? '';

    // Handle Price: Ensure it's a double
    final price = double.tryParse(json['price'].toString()) ?? 0.0;

    // Handle Image:
    // 1. Check 'media' array (Laravel)
    // 2. Check 'imageUrl' (Firestore)
    // 3. Check 'image' (FakeStore)
    String? imageUrl;
    if (json['media'] != null &&
        json['media'] is List &&
        (json['media'] as List).isNotEmpty) {
      imageUrl = json['media'][0]['url'];
    } else {
      imageUrl = json['imageUrl'] ?? json['image'];
    }

    // Handle Category: Firestore uses 'categoryId', API might use 'category' (String or Object)
    // If API returns a category object, we might need to extract ID or Name
    String? categoryId = json['categoryId']?.toString();
    if (json['category'] is String) {
      // For simple APIs like FakeStore where category is just a name
      categoryId = json['category'];
    } else if (json['category'] is Map) {
      categoryId = json['category']['id']?.toString();
    } else if (json['category_id'] != null) {
      categoryId = json['category_id'].toString();
    }

    // Handle Attributes: Firestore Map vs API JSON String
    var attributes = json['attributes'];
    if (attributes is String) {
      try {
        attributes = jsonDecode(attributes);
      } catch (_) {}
    }

    return Product(
      id: id,
      name: name,
      description: json['description'] ?? '',
      price: price,
      imageUrl: imageUrl,
      categoryId: categoryId,
      stock: int.tryParse(json['stock'].toString()) ?? 0,
      attributes: attributes,
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'].toString())
              : null,
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.tryParse(json['updatedAt'].toString())
              : null,
    );
  }

  // Deprecated: Use fromJson instead
  factory Product.fromMap(Map<String, dynamic> map) => Product.fromJson(map);

  // Optional: Override toString for easy printing/debugging
  @override
  String toString() {
    return 'Product{id: $id, name: $name, price: $price, categoryId: $categoryId, stock: $stock}';
  }

  String getCategoryName(List<Category> categories) {
    if (categoryId == null) return 'فئة غير معروفة';

    try {
      final category = categories.firstWhere((cat) => cat.id == categoryId);
      return category.name;
    } catch (e) {
      return 'فئة غير معروفة';
    }
  }
}
