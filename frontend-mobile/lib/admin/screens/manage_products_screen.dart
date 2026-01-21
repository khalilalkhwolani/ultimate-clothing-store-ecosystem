import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/admin/screens/add_edit_product_screen.dart';
import 'package:myprojectshop/controller/product_controller.dart';
import 'package:myprojectshop/controller/category_controller.dart';
import 'package:myprojectshop/model/product_model.dart';
import 'package:myprojectshop/theme/theme.dart';
import 'package:myprojectshop/service/database_seeder.dart';
import 'package:myprojectshop/widgets/custom_image.dart';
import 'package:myprojectshop/utils/app_snackbar.dart';

class ManageProductsScreen extends StatelessWidget {
  ManageProductsScreen({super.key});

  final ProductController controller = Get.find<ProductController>();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
        backgroundColor: AppTheme.primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.cloud_upload),
            onPressed: () async {
              // Show loading
              Get.dialog(
                Center(child: CircularProgressIndicator()),
                barrierDismissible: false,
              );

              // Seed Database
              bool success = await DatabaseSeeder().seedDatabase();

              // Close loading
              Get.back();

              if (success) {
                AppSnackbar.showSuccess(
                  'Database seeded successfully!',
                  title: 'Success',
                );
                // Refresh products and categories
                controller.fetchProducts();
                Get.find<CategoryController>().fetchCategories();
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Get.to(() => AddEditProductScreen()),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged:
                  (value) =>
                      controller
                          .fetchProducts(), // Implement search logic if needed
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              return RefreshIndicator(
                onRefresh: controller.fetchProducts,
                child: ListView.builder(
                  itemCount: controller.products.length,
                  itemBuilder: (context, index) {
                    final product = controller.products[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: CustomImage(
                          imageUrl: product.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          borderRadius: 8,
                        ),
                        title: Text(product.name),
                        subtitle: Text(
                          '\$${product.price.toStringAsFixed(2)} - Stock: ${product.stock}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed:
                                  () => Get.to(
                                    () =>
                                        AddEditProductScreen(product: product),
                                  ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmDelete(context, product),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, Product product) {
    Get.defaultDialog(
      title: 'Delete Product',
      middleText: 'Are you sure you want to delete ${product.name}?',
      textCancel: 'Cancel',
      textConfirm: 'Delete',
      confirmTextColor: Colors.white,
      onConfirm: () {
        controller.deleteProduct(product.id!);
        Get.back();
      },
    );
  }
}
