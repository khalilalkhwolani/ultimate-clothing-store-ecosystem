import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/controller/category_controller.dart';
import 'package:myprojectshop/controller/auth_controller.dart';
import 'package:myprojectshop/l10n/l10n_extension.dart';
import 'package:myprojectshop/controller/product_controller.dart';
import 'package:myprojectshop/controller/cart_controller.dart';
import 'package:myprojectshop/model/product_model.dart';
import 'package:myprojectshop/screens/cart_screen.dart';
import 'package:myprojectshop/screens/categories_screen.dart';
import 'package:myprojectshop/screens/product_details_screen.dart';
import 'package:myprojectshop/screens/search_filter_screen.dart';
import 'package:myprojectshop/screens/wishlist_screen.dart';
import 'package:myprojectshop/theme/theme.dart';
import 'package:myprojectshop/widgets/app_drawer.dart';
import 'package:myprojectshop/widgets/custom_image.dart';
import 'package:myprojectshop/widgets/product_card.dart';
import 'package:myprojectshop/screens/notifications_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final ProductController controller = Get.find<ProductController>();
  final CartController _cartcontroller = Get.find<CartController>();
  final CategoryController categoryController = Get.find<CategoryController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      drawer: AppDrawer(),
      body: Obx(() {
        if (controller.isLoading.value) {
         return Center(child: CircularProgressIndicator());
        }

        return CustomScrollView(
          slivers: [
            // Premium Header with Search Bar
            SliverToBoxAdapter(child: _buildPremiumHeader(context)),
            // Content
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  // Promo Banner
                  _buildPromoBanner(context),
                  SizedBox(height: 5),
                  // Categories Section
                  _buildSectionTitle(context, context.l10n.categories, () {
                    Get.to(() => CategoriesScreen());
                  }),
                  SizedBox(height: 5),
                  _buildCategoriesGrid(context),
                  SizedBox(height: 5),
                  // Featured Products
                  _buildSectionTitle(context, context.l10n.featured, () {
                    Get.to(() => SearchFilterScreen());
                  }),
                  SizedBox(height: 5),
                  _buildFeaturedProducts(),
                  SizedBox(height: 5),

                  // New Arrivals
                  _buildSectionTitle(context, context.l10n.newArrivals, () {
                    Get.to(() => SearchFilterScreen());
                  }),
                  SizedBox(height: 5),
                  _buildNewArrivals(context),
                  SizedBox(height: 5),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  // Premium Header with Gradient and Search Bar
  Widget _buildPremiumHeader(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        // Gradient Header
        Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppTheme.premiumGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Top Row
                Row(
                  children: [
                    // Menu Button
                    Builder(
                      builder:
                          (context) => Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.menu, color: Colors.white),
                              onPressed:
                                  () => Scaffold.of(context).openDrawer(),
                            ),
                          ),
                    ),
                    SizedBox(width: 12),
                    // Welcome Message
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.welcomeBack,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                          Obx(
                            () => Text(
                              authController.username ?? 'Guest',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Notification Button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Get.to(() => NotificationsScreen());
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    // Wishlist Button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.favorite_border, color: Colors.white),
                        onPressed: () {
                          Get.to(() => WishlistScreen());
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Search Bar INSIDE gradient
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: AppTheme.textsecandery),
                      SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          onSubmitted: (value) {
                            Get.to(() => SearchFilterScreen());
                          },
                          decoration: InputDecoration(
                            hintText: context.l10n.searchProducts,
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: AppTheme.textsecandery,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.tune,
                          color: AppTheme.primaryColor,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Promo Banner
  Widget _buildPromoBanner(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        child: Container(
          height: 160,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF667EEA).withOpacity(0.4),
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              // Decorative circles
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Text Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '🔥 ${context.l10n.featured}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '50% OFF',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              context.l10n.viewAll,
                              style: TextStyle(
                                color: Color(0xFF667EEA),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Icon
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.local_offer_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Section Title
  Widget _buildSectionTitle(
    BuildContext context,
    String title,
    VoidCallback onViewAll,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          TextButton(
            onPressed: onViewAll,
            child: Text(
              context.l10n.viewAll,
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Categories Grid
  Widget _buildCategoriesGrid(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Obx(() {
        if (categoryController.categories.isEmpty) {
          return Center(child: Text(context.l10n.noCategories));
        }
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: categoryController.categories.length,
          itemBuilder: (context, index) {
            final cat = categoryController.categories[index];

            final colors = [
              Color(0xFF4CAF50),
              Color(0xFF2196F3),
              Color(0xFFE91E63),
              Color(0xFFFF9800),
            ];
            final iconColor = colors[index % colors.length];

            IconData getCategoryIcon(String name) {
              switch (name.toLowerCase()) {
                case 'men':
                  return Icons.man_outlined;
                case 'women':
                  return Icons.woman_outlined;
                case 'kids':
                  return Icons.child_care_outlined;
                case 'accessories':
                  return Icons.watch_outlined;
                default:
                  return Icons.category_outlined;
              }
            }

            return Container(
              width: 85,
              margin: EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(15), // Rounded square
                    ),
                    child:
                        cat.imageUrl != null && cat.imageUrl!.isNotEmpty
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CustomImage(
                                imageUrl: cat.imageUrl!,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            )
                            : Padding(
                              padding: EdgeInsets.all(15),
                              child: Icon(
                                getCategoryIcon(cat.name),
                                color: iconColor,
                                size: 35,
                              ),
                            ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    cat.name,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  // Featured Products
  Widget _buildFeaturedProducts() {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: controller.products.length,
        itemBuilder: (context, index) {
          final Product product = controller.products[index];
          return ProductCard(
            product: product,
            categoryName: product.getCategoryName(
              categoryController.categories,
            ),
          );
        },
      ),
    );
  }

  // New Arrivals List
  Widget _buildNewArrivals(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount:
          controller.products.length > 5 ? 5 : controller.products.length,
      itemBuilder: (context, index) {
        final Product product = controller.products[index];

        return Container(
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              Get.to(() => ProductDetailsScreen(product: product));
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CustomImage(
                      imageUrl: product.imageUrl,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          product.getCategoryName(
                            categoryController.categories,
                          ),
                          style: TextStyle(
                            color: AppTheme.textsecandery,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              '\$${product.price}',
                              style: TextStyle(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Text(
                              ' 4.5',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textsecandery,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () async {
                        try {
                          await _cartcontroller.addToCart(
                            product,
                            quantity: 1,
                            selectedSize: '0',
                            selectedColor: '0',
                          );
                          if (authController.isLoggedIn.value) {
                            Get.to(() => CartScreen());
                          }
                        } catch (e) {
                          print("Error adding cart: $e");
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
