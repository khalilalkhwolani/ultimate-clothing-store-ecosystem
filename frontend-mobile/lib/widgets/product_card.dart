import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/l10n/l10n_extension.dart';
import 'package:myprojectshop/model/product_model.dart';
import 'package:myprojectshop/screens/product_details_screen.dart';
import 'package:myprojectshop/theme/theme.dart';
import 'package:myprojectshop/widgets/custom_image.dart';
import 'package:myprojectshop/controller/cart_controller.dart';
import 'package:myprojectshop/controller/auth_controller.dart';
import 'package:myprojectshop/screens/cart_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final String? categoryName;

  const ProductCard({
    Key? key,
    required this.product,
    this.onTap,
    this.categoryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          onTap ??
          () {
            Get.to(() => ProductDetailsScreen(product: product));
          },
      child: Container(
        width: 150,
        height: 260,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: CustomImage(
                  imageUrl: product.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 120,
                ),
              ),
            ),

            // Product Details
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (categoryName != null)
                    Text(
                      categoryName!,
                      style: TextStyle(
                        color: AppTheme.textsecandery,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  else
                    Text(
                      context.l10n.categoryLabel,
                      style: TextStyle(
                        color: AppTheme.textsecandery,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  SizedBox(height: 4),
                  Text(
                    "${context.l10n.price} : \$${product.price.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 15),
                      Icon(Icons.star, color: Colors.amber, size: 15),
                      Icon(Icons.star_half, color: Colors.amber, size: 15),
                      Spacer(),
                      IconButton(
                        onPressed: () async {
                          final CartController _cartController =
                              Get.find<CartController>();
                          final AuthController _authController =
                              Get.find<AuthController>();

                          try {
                            await _cartController.addToCart(
                              product,
                              quantity: 1,
                              selectedSize: 'M', // Default size
                              selectedColor: 'Blue', // Default color
                            );
                            if (_authController.isLoggedIn.value) {
                              Get.to(() => CartScreen());
                            }
                          } catch (e) {
                            print("Error adding to cart: $e");
                          }
                        },
                        icon: Icon(
                          Icons.shopping_cart_outlined,
                          color: AppTheme.textsecandery,
                          size: 18,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
