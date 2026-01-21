import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/l10n/l10n_extension.dart';
import 'package:myprojectshop/controller/auth_controller.dart';
import 'package:myprojectshop/controller/cart_controller.dart';
import 'package:myprojectshop/controller/wishlist_controller.dart';
import 'package:myprojectshop/model/product_model.dart';
import 'package:myprojectshop/screens/product_details_screen.dart';
import 'package:myprojectshop/theme/theme.dart';
import 'package:myprojectshop/widgets/custom_app_bar.dart';
import 'package:myprojectshop/widgets/custom_image.dart';
import 'package:myprojectshop/utils/app_snackbar.dart';

class WishlistScreen extends StatelessWidget {
  final WishlistController wishlistController = Get.find<WishlistController>();
  final AuthController authController = Get.find<AuthController>();
  final CartController cartController = Get.find<CartController>();

  WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = authController.currentUserId;
    if (userId != null) {
      wishlistController.fetchWishlist(userId.toString());
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Obx(() {
        if (wishlistController.isLoading.value) {
          return Scaffold(
            appBar: CustomAppBar(
              title: context.l10n.myWishlist,
              showBackButton: true,
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (wishlistController.wishlistItems.isEmpty) {
          return Scaffold(
            appBar: CustomAppBar(
              title: context.l10n.myWishlist,
              showBackButton: true,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 16),
                  Text(
                    context.l10n.wishlistEmpty,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    context.l10n.wishlistEmptyHint,
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white,
                    ),
                    label: Text(
                      context.l10n.startShopping,
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverCustomAppBar(
              title: context.l10n.myWishlist,
              showBackButton: true,
              actions: [
                IconButton(
                  icon: Icon(Icons.delete_sweep),
                  onPressed: () => _showClearAllDialog(context),
                ),
              ],
            ),
            SliverPadding(
              padding: EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final product = wishlistController.wishlistItems[index];
                  return _buildWishlistItem(context, product);
                }, childCount: wishlistController.wishlistItems.length),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildWishlistItem(BuildContext context, Product product) {
    return Dismissible(
      key: Key(product.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        wishlistController.removeFromWishlist(
          authController.currentUserId!,
          product.id!,
        );
        AppSnackbar.showInfo(
          '${context.l10n.itemRemovedFrom} ${context.l10n.wishlist}',
          title: context.l10n.removed,
        );
      },
      child: GestureDetector(
        onTap: () => Get.to(() => ProductDetailsScreen(product: product)),
        child: Container(
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
          child: Row(
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(12),
                ),
                child: Container(
                  width: 100,
                  height: 100,
                  child: CustomImage(
                    imageUrl: product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Product Info
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppTheme.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        product.description ?? '',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          Row(
                            children: [
                              // Add to Cart Button
                              Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.add_shopping_cart,
                                    color: AppTheme.primaryColor,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    cartController.addToCart(product);
                                    AppSnackbar.showSuccess(
                                      '${context.l10n.itemAddedTo} ${context.l10n.cart}',
                                      title: context.l10n.addedToCart,
                                    );
                                  },
                                  constraints: BoxConstraints(
                                    minWidth: 36,
                                    minHeight: 36,
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                              SizedBox(width: 8),
                              // Remove from Wishlist Button
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    wishlistController.removeFromWishlist(
                                      authController.currentUserId!,
                                      product.id!,
                                    );
                                  },
                                  constraints: BoxConstraints(
                                    minWidth: 36,
                                    minHeight: 36,
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showClearAllDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text(context.l10n.clearWishlist),
        content: Text(context.l10n.clearWishlistConfirm),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(context.l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              for (var item in wishlistController.wishlistItems.toList()) {
                await wishlistController.removeFromWishlist(
                  authController.currentUserId!,
                  item.id!,
                );
              }
              AppSnackbar.showSuccess(
                context.l10n.wishlistCleared,
                title: context.l10n.cleared,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(
              context.l10n.clearAll,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
