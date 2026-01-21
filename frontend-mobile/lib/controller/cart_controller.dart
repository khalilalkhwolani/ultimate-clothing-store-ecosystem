import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/controller/auth_controller.dart';
import 'package:myprojectshop/model/cart_item_model.dart';
import 'package:myprojectshop/model/product_model.dart';
import 'package:myprojectshop/screens/login_screen.dart';
import 'package:myprojectshop/utils/app_snackbar.dart';

class CartController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthController _authController = Get.find<AuthController>();

  final RxList<CartItem> cartItems = <CartItem>[].obs;
  final RxDouble _totalPrice = 0.0.obs;
  final RxInt _itemCount = 0.obs;

  double get totalPrice => _totalPrice.value;
  int get itemCount => _itemCount.value;

  @override
  void onInit() {
    super.onInit();
    // Listen to auth changes to fetch cart
    ever(_authController.currentUser, (user) {
      if (user != null) {
        fetchCart();
      } else {
        cartItems.clear();
        _calculateTotals();
      }
    });

    // Also fetch if already logged in
    if (_authController.isLoggedIn.value) {
      fetchCart();
    }

    ever(cartItems, (_) => _calculateTotals());
  }

  void _calculateTotals() {
    double total = 0.0;
    int count = 0;
    for (var item in cartItems) {
      total += item.totalPrice;
      count += item.quantity;
    }
    _totalPrice.value = total;
    _itemCount.value = count;
  }

  Future<void> fetchCart() async {
    final userId = _authController.currentUserId;
    if (userId == null) return;

    try {
      final snapshot =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('cart')
              .get();

      final items =
          snapshot.docs.map((doc) {
            return CartItem.fromMap(doc.data());
          }).toList();

      cartItems.assignAll(items);
    } catch (e) {
      print("Error fetching cart: $e");
      AppSnackbar.showError('Failed to load cart items');
    }
  }

  Future<void> addToCart(
    Product product, {
    int quantity = 1,
    String? selectedSize,
    String? selectedColor,
  }) async {
    final userId = _authController.currentUserId;
    if (userId == null) {
      _showLoginRequiredDialog();
      return;
    }

    if (product.id == null) {
      AppSnackbar.showError('Product ID is missing');
      return;
    }

    try {
      int existingIndex = cartItems.indexWhere(
        (item) => item.product.id == product.id,
      );

      if (existingIndex >= 0) {
        // Update existing item
        CartItem existingItem = cartItems[existingIndex];
        CartItem newItem = existingItem.copyWith(
          quantity: existingItem.quantity + quantity,
          selectedSize: selectedSize ?? existingItem.selectedSize,
          selectedColor: selectedColor ?? existingItem.selectedColor,
        );

        await _firestore
            .collection('users')
            .doc(userId)
            .collection('cart')
            .doc(product.id)
            .update(newItem.toMap());

        cartItems[existingIndex] = newItem;
      } else {
        // Add new item
        CartItem newItem = CartItem(
          id: product.id, // Use product ID as cart item ID for simplicity
          userId: userId,
          productId: product.id!,
          product: product,
          quantity: quantity,
          selectedSize: selectedSize,
          selectedColor: selectedColor,
        );

        await _firestore
            .collection('users')
            .doc(userId)
            .collection('cart')
            .doc(product.id)
            .set(newItem.toMap());

        cartItems.add(newItem);
      }

      AppSnackbar.showSuccess('Added ${product.name} to cart');
    } catch (e) {
      AppSnackbar.showError('Failed to add to cart: $e');
    }
  }

  Future<void> increaseQuantity(int index) async {
    if (index >= 0 && index < cartItems.length) {
      final item = cartItems[index];
      await addToCart(item.product, quantity: 1);
    }
  }

  Future<void> decreaseQuantity(int index) async {
    if (index >= 0 && index < cartItems.length) {
      final item = cartItems[index];
      if (item.quantity > 1) {
        await addToCart(item.product, quantity: -1);
      } else {
        await removeItem(index);
      }
    }
  }

  Future<void> removeItem(int index) async {
    final userId = _authController.currentUserId;
    if (userId == null) return;

    if (index >= 0 && index < cartItems.length) {
      final item = cartItems[index];
      try {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('cart')
            .doc(item.productId)
            .delete();

        cartItems.removeAt(index);
      } catch (e) {
        AppSnackbar.showError('Failed to remove item: $e');
      }
    }
  }

  Future<void> clearCart() async {
    final userId = _authController.currentUserId;
    if (userId == null) return;

    try {
      final batch = _firestore.batch();
      final snapshot =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('cart')
              .get();

      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      cartItems.clear();
    } catch (e) {
      print("Error clearing cart: $e");
      AppSnackbar.showError('Failed to clear cart');
    }
  }

  bool isInCart(String productId) {
    return cartItems.any((item) => item.product.id == productId);
  }

  int getQuantityForProduct(String productId) {
    int quantity = 0;
    for (var item in cartItems) {
      if (item.product.id == productId) {
        quantity += item.quantity;
      }
    }
    return quantity;
  }

  /// Show dialog prompting guest users to login
  void _showLoginRequiredDialog() {
    Get.defaultDialog(
      title: 'تسجيل الدخول مطلوب',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      middleText:
          'يجب تسجيل الدخول لإضافة المنتجات إلى السلة.\nهل تريد تسجيل الدخول الآن؟',
      textCancel: 'لاحقاً',
      textConfirm: 'تسجيل الدخول',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        Get.to(() => const LoginScreen());
      },
      onCancel: () {},
    );
  }
}
