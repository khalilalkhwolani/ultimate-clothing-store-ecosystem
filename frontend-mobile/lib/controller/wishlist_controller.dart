import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/model/product_model.dart';
import 'package:myprojectshop/utils/app_snackbar.dart';

class WishlistController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxList<Product> wishlistItems = <Product>[].obs;
  final RxBool isLoading = false.obs;

  Future<void> fetchWishlist(String userId) async {
    isLoading.value = true;
    try {
      final snapshot =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('wishlist')
              .get();

      // Wishlist items in Firestore might just be references or copies of products.
      // For simplicity, let's assume we store the full product data or at least enough to display.
      // Or we fetch products by ID.
      // Given the previous implementation used `getWishlistItems` which likely joined tables,
      // we should probably store product details in wishlist for easier access, or fetch them.
      // Let's assume we store product details in the wishlist subcollection.

      wishlistItems.value =
          snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] =
                doc.id; // Use document ID as product ID if it matches, or store productId field
            // Actually, it's better if the document ID IS the product ID.
            return Product.fromMap(data);
          }).toList();
    } catch (e) {
      print("Error fetching wishlist: $e");
      AppSnackbar.showError('Failed to load wishlist');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addToWishlist(String userId, Product product) async {
    try {
      if (product.id == null) return false;

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .doc(product.id)
          .set(product.toMap());

      if (!isInWishlist(product.id!)) {
        wishlistItems.add(product);
      }
      return true;
    } catch (e) {
      print("Error adding to wishlist: $e");
      AppSnackbar.showError('Failed to add to wishlist');
      return false;
    }
  }

  Future<bool> removeFromWishlist(String userId, String productId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .doc(productId)
          .delete();

      wishlistItems.removeWhere((p) => p.id == productId);
      return true;
    } catch (e) {
      print("Error removing from wishlist: $e");
      AppSnackbar.showError('Failed to remove from wishlist');
      return false;
    }
  }

  bool isInWishlist(String productId) {
    return wishlistItems.any((p) => p.id == productId);
  }

  Future<void> toggleWishlist(String userId, Product product) async {
    if (product.id == null) return;

    if (isInWishlist(product.id!)) {
      await removeFromWishlist(userId, product.id!);
    } else {
      await addToWishlist(userId, product);
    }
  }
}
