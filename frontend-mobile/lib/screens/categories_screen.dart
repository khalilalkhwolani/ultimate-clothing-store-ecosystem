import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/controller/category_controller.dart';
import 'package:myprojectshop/controller/product_controller.dart';
import 'package:myprojectshop/model/category_modle.dart';
import 'package:myprojectshop/screens/product_details_screen.dart';
import 'package:myprojectshop/theme/theme.dart';
import 'package:myprojectshop/widgets/custom_app_bar.dart';
import 'package:myprojectshop/widgets/custom_image.dart';

class CategoriesScreen extends StatelessWidget {
  final CategoryController categoryController = Get.find<CategoryController>();
  final ProductController productController = Get.find<ProductController>();

  CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Obx(() {
        if (categoryController.isLoading.value) {
          return Scaffold(
            appBar: CustomAppBar(title: 'Categories', showBackButton: true),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (categoryController.categories.isEmpty) {
          return Scaffold(
            appBar: CustomAppBar(title: 'Categories', showBackButton: true),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No categories available',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverCustomAppBar(title: 'Categories', showBackButton: true),
            SliverPadding(
              padding: EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final category = categoryController.categories[index];
                  return _buildCategoryCard(context, category);
                }, childCount: categoryController.categories.length),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildCategoryCard(BuildContext context, Category category) {
    // Get products in this category
    final categoryProducts =
        productController.products
            .where((p) => p.categoryId == category.id)
            .toList();

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child:
              category.imageUrl != null && category.imageUrl!.isNotEmpty
                  ? ClipOval(
                    child: CustomImage(
                      imageUrl: category.imageUrl!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  )
                  : Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.category, color: AppTheme.primaryColor),
                  ),
        ),
        title: Text(
          category.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppTheme.textPrimary,
          ),
        ),
        subtitle: Text(
          '${categoryProducts.length} products',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${categoryProducts.length}',
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        children: [
          if (categoryProducts.isEmpty)
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'No products in this category',
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            Container(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: categoryProducts.length,
                itemBuilder: (context, index) {
                  final product = categoryProducts[index];
                  return GestureDetector(
                    onTap:
                        () => Get.to(
                          () => ProductDetailsScreen(product: product),
                        ),
                    child: Container(
                      width: 120,
                      margin: EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10),
                              ),
                              child: CustomImage(
                                imageUrl: product.imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
