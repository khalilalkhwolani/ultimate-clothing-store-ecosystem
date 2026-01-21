import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/core/app_config.dart';
import 'package:myprojectshop/model/product_model.dart';
import 'package:myprojectshop/utils/app_snackbar.dart';

class ProductController extends GetxController {
  final AppConfig _appConfig = Get.find<AppConfig>();

  var products = <Product>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();

    // Listen to data source changes
    ever(_appConfig.currentDataSource, (_) {
      fetchProducts();
    });
  }

  Future<void> fetchProducts() async {
    try {
      isLoading(true);

      // Use the repository from AppConfig
      final fetchedProducts = await _appConfig.repository.fetchProducts();
      products.assignAll(fetchedProducts);
    } catch (e) {
      print("Error fetching products: $e");
      if (e is FirebaseException && e.code == 'permission-denied') {
        AppSnackbar.showError(
          'Permission Denied: Guest users cannot access products. Please check Firestore Rules.',
        );
      } else {
        AppSnackbar.showError('Failed to load products: $e');
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      isLoading(true);
      await _appConfig.repository.addProduct(product);
      fetchProducts(); // Refresh list
      AppSnackbar.showSuccess('Product added successfully');
    } catch (e) {
      print("Error adding product: $e");
      AppSnackbar.showError('Failed to add product: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      isLoading(true);
      await _appConfig.repository.updateProduct(product);
      fetchProducts(); // Refresh list
      AppSnackbar.showSuccess('Product updated successfully');
    } catch (e) {
      print("Error updating product: $e");
      AppSnackbar.showError('Failed to update product: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      isLoading(true);
      await _appConfig.repository.deleteProduct(id);
      fetchProducts(); // Refresh list
      AppSnackbar.showSuccess('Product deleted successfully');
    } catch (e) {
      print("Error deleting product: $e");
      AppSnackbar.showError('Failed to delete product: $e');
    } finally {
      isLoading(false);
    }
  }
}
