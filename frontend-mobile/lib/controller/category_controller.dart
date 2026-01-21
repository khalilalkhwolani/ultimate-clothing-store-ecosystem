import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/core/app_config.dart';
import 'package:myprojectshop/model/category_modle.dart';
import 'package:myprojectshop/utils/app_snackbar.dart';

class CategoryController extends GetxController {
  final AppConfig _appConfig = Get.find<AppConfig>();

  var categories = <Category>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();

    ever(_appConfig.currentDataSource, (_) {
      fetchCategories();
    });
  }

  Future<void> fetchCategories() async {
    try {
      isLoading(true);
      final fetchedCategories = await _appConfig.repository.fetchCategories();
      categories.assignAll(fetchedCategories);
    } catch (e) {
      print("Error fetching categories: $e");
      if (e is FirebaseException && e.code == 'permission-denied') {
        AppSnackbar.showError(
          'Permission Denied: Guest users cannot access categories. Please check Firestore Rules.',
        );
      } else {
        AppSnackbar.showError('Failed to load categories: $e');
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> addCategory(Category category) async {
    try {
      isLoading(true);
      await _appConfig.repository.addCategory(category);
      fetchCategories();
      AppSnackbar.showSuccess('Category added successfully');
    } catch (e) {
      print("Error adding Category: $e");
      AppSnackbar.showError('Failed to add Category: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateCategory(Category category) async {
    try {
      isLoading(true);
      await _appConfig.repository.updateCategory(category);
      fetchCategories();
      AppSnackbar.showSuccess('Category updated successfully');
    } catch (e) {
      print("Error updating category: $e");
      AppSnackbar.showError('Failed to update category: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      isLoading(true);
      await _appConfig.repository.deleteCategory(id);
      fetchCategories();
      AppSnackbar.showSuccess('Category deleted successfully');
    } catch (e) {
      print("Error deleting category: $e");
      AppSnackbar.showError('Failed to delete category: $e');
    } finally {
      isLoading(false);
    }
  }
}
