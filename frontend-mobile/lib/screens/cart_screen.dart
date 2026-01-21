import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/l10n/l10n_extension.dart';
import 'package:myprojectshop/controller/auth_controller.dart';
import 'package:myprojectshop/controller/cart_controller.dart';
import 'package:myprojectshop/screens/checkout_screen.dart';
import 'package:myprojectshop/screens/login_screen.dart';
import 'package:myprojectshop/theme/theme.dart';
import 'package:myprojectshop/widgets/custom_image.dart';
import 'package:myprojectshop/widgets/gradient_button.dart';
import 'package:myprojectshop/utils/app_snackbar.dart';
import 'package:myprojectshop/widgets/custom_app_bar.dart';

class CartScreen extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();

  CartScreen({Key? key}) : super(key: key);

  Widget _buildCartItem(BuildContext context, int index) {
    final item = cartController.cartItems[index];

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CustomImage(
                imageUrl: item.product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.product.name ?? context.l10n.productDefaultName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: AppTheme.error),
                      onPressed: () {
                        cartController.removeItem(index);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  'Fall',
                  style: TextStyle(fontSize: 12, color: AppTheme.textsecandery),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${item.product.price.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.textsecandery.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          _buildQuantityButton(
                            icon: Icons.remove,
                            onPressed: () {
                              cartController.decreaseQuantity(index);
                            },
                          ),
                          SizedBox(
                            width: 40,
                            child: Center(
                              child: Text(
                                "${item.quantity}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          _buildQuantityButton(
                            icon: Icons.add,
                            onPressed: () {
                              cartController.increaseQuantity(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? AppTheme.textPrimary : AppTheme.textsecandery,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? AppTheme.primaryColor : AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon, size: 16, color: AppTheme.primaryColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double shipping = 10.0;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return Scaffold(
            appBar: CustomAppBar(
              title: context.l10n.myCart,
              showBackButton: true,
            ),
            body: _buildEmptyCart(context),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverCustomAppBar(
              title: context.l10n.myCart,
              showBackButton: true,
            ),
            SliverPadding(
              padding: EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: cartController.cartItems.length,
                    itemBuilder: (context, index) {
                      return _buildCartItem(context, index);
                    },
                  ),
                  SizedBox(height: 24),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildSummaryRow(
                          context.l10n.subtotal,
                          "\$${cartController.totalPrice.toStringAsFixed(2)}",
                        ),
                        _buildSummaryRow(
                          context.l10n.shipping,
                          "\$${shipping.toStringAsFixed(2)}",
                        ),
                        _buildSummaryRow(
                          context.l10n.tax,
                          "\$${(cartController.totalPrice * 0.05).toStringAsFixed(2)}",
                        ),
                        Divider(height: 24),
                        _buildSummaryRow(
                          context.l10n.total,
                          "\$${(cartController.totalPrice + shipping + (cartController.totalPrice * 0.05)).toStringAsFixed(2)}",
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  GradientButton(
                    text: context.l10n.checkout,
                    onPressed: () {
                      final AuthController authController =
                          Get.find<AuthController>();
                      final userId = authController.currentUser.value?.id;

                      if (userId == null) {
                        AppSnackbar.showError(
                          context.l10n.loginRequired,
                          title: context.l10n.error,
                        );
                        Get.to(() => LoginScreen());
                      } else {
                        Get.to(() => const CheckoutScreen());
                      }
                    },
                  ),
                ]),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 100,
              color: AppTheme.textsecandery.withOpacity(0.5),
            ),
            SizedBox(height: 24),
            Text(
              context.l10n.cartEmpty,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            SizedBox(height: 16),
            Text(
              context.l10n.cartEmptySubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppTheme.textsecandery),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                context.l10n.continueShopping,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
