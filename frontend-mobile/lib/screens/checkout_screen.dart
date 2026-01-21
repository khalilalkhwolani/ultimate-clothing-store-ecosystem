import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/l10n/l10n_extension.dart';
import 'package:myprojectshop/controller/auth_controller.dart';
import 'package:myprojectshop/controller/cart_controller.dart';
import 'package:myprojectshop/controller/order_controller.dart';
import 'package:myprojectshop/model/order_model.dart';
import 'package:myprojectshop/model/orderitem_model.dart';
import 'package:myprojectshop/screens/order_success_screen.dart';
import 'package:myprojectshop/theme/theme.dart';
import 'package:myprojectshop/widgets/custom_app_bar.dart';
import 'package:myprojectshop/widgets/gradient_button.dart';
import 'package:myprojectshop/utils/app_snackbar.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final CartController cartController = Get.find<CartController>();
  final OrderController orderController = Get.find<OrderController>();
  final AuthController authController = Get.find<AuthController>();

  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Selected options
  int _selectedDeliveryMethod = 0;
  int _selectedPaymentMethod = 0;
  bool _isProcessing = false;

  // Delivery methods
  final List<Map<String, dynamic>> deliveryMethods = [
    {
      'title': 'التوصيل العادي',
      'titleEn': 'Standard',
      'days': '5-7',
      'price': 5.0,
      'icon': Icons.local_shipping_outlined,
    },
    {
      'title': 'التوصيل السريع',
      'titleEn': 'Express',
      'days': '1-2',
      'price': 10.0,
      'icon': Icons.delivery_dining_outlined,
    },
  ];

  // Payment methods
  final List<Map<String, dynamic>> paymentMethods = [
    {
      'title': 'الدفع عند التوصيل',
      'titleEn': 'Cash on Delivery',
      'icon': Icons.money,
    },
    {
      'title': 'بطاقة ائتمان',
      'titleEn': 'Credit Card',
      'icon': Icons.credit_card,
    },
    {
      'title': 'محفظة إلكترونية',
      'titleEn': 'E-Wallet',
      'icon': Icons.account_balance_wallet,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Pre-fill with user data if available
    _nameController.text = authController.username ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  double get shippingCost =>
      deliveryMethods[_selectedDeliveryMethod]['price'] as double;
  double get subtotal => cartController.totalPrice;
  double get tax => subtotal * 0.05;
  double get total => subtotal + shippingCost + tax;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverCustomAppBar(
            title: context.l10n.checkout,
            showBackButton: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Shipping Address Section
                  _buildSectionCard(
                    icon: Icons.location_on_outlined,
                    title: context.l10n.shippingAddress,
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _nameController,
                          hint: context.l10n.fullName,
                          icon: Icons.person_outline,
                        ),
                        SizedBox(height: 12),
                        _buildTextField(
                          controller: _addressController,
                          hint: context.l10n.address,
                          icon: Icons.home_outlined,
                          maxLines: 2,
                        ),
                        SizedBox(height: 12),
                        _buildTextField(
                          controller: _phoneController,
                          hint: context.l10n.phone,
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  // 2. Delivery Method Section
                  _buildSectionCard(
                    icon: Icons.local_shipping_outlined,
                    title: context.l10n.deliveryMethod,
                    child: Column(
                      children: List.generate(
                        deliveryMethods.length,
                        (index) => _buildDeliveryOption(index),
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // 3. Payment Method Section
                  _buildSectionCard(
                    icon: Icons.payment_outlined,
                    title: context.l10n.paymentMethod,
                    child: Column(
                      children: List.generate(
                        paymentMethods.length,
                        (index) => _buildPaymentOption(index),
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // 4. Order Summary Section
                  _buildSectionCard(
                    icon: Icons.receipt_long_outlined,
                    title: context.l10n.orderSummary,
                    child: Column(
                      children: [
                        // Items list
                        ...cartController.cartItems.map(
                          (item) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.quantity}x ${item.product.name}',
                                    style: TextStyle(
                                      color: AppTheme.textsecandery,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(height: 24),
                        _buildSummaryRow(
                          context.l10n.subtotal,
                          '\$${subtotal.toStringAsFixed(2)}',
                        ),
                        _buildSummaryRow(
                          context.l10n.shipping,
                          '\$${shippingCost.toStringAsFixed(2)}',
                        ),
                        _buildSummaryRow(
                          context.l10n.tax,
                          '\$${tax.toStringAsFixed(2)}',
                        ),
                        Divider(height: 24),
                        _buildSummaryRow(
                          context.l10n.total,
                          '\$${total.toStringAsFixed(2)}',
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // 5. Confirm Button
                  GradientButton(
                    text:
                        _isProcessing
                            ? '${context.l10n.loading}...'
                            : '${context.l10n.confirmOrder} - \$${total.toStringAsFixed(2)}',
                    onPressed: _isProcessing ? () {} : _processOrder,
                  ),

                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppTheme.primaryColor, size: 20),
              ),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppTheme.textsecandery),
        filled: true,
        fillColor: AppTheme.backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildDeliveryOption(int index) {
    final method = deliveryMethods[index];
    final isSelected = _selectedDeliveryMethod == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedDeliveryMethod = index),
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.only(
          bottom: index < deliveryMethods.length - 1 ? 8 : 0,
        ),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppTheme.primaryColor.withOpacity(0.05)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                border: Border.all(
                  color:
                      isSelected
                          ? AppTheme.primaryColor
                          : AppTheme.textsecandery,
                  width: 2,
                ),
              ),
              child:
                  isSelected
                      ? Icon(Icons.check, color: Colors.white, size: 14)
                      : null,
            ),
            SizedBox(width: 12),
            Icon(method['icon'] as IconData, color: AppTheme.primaryColor),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method['title'] as String,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${method['days']} ${context.l10n.days}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textsecandery,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '\$${(method['price'] as double).toStringAsFixed(0)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(int index) {
    final method = paymentMethods[index];
    final isSelected = _selectedPaymentMethod == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = index),
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.only(
          bottom: index < paymentMethods.length - 1 ? 8 : 0,
        ),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppTheme.primaryColor.withOpacity(0.05)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                border: Border.all(
                  color:
                      isSelected
                          ? AppTheme.primaryColor
                          : AppTheme.textsecandery,
                  width: 2,
                ),
              ),
              child:
                  isSelected
                      ? Icon(Icons.check, color: Colors.white, size: 14)
                      : null,
            ),
            SizedBox(width: 12),
            Icon(method['icon'] as IconData, color: AppTheme.primaryColor),
            SizedBox(width: 12),
            Text(
              method['title'] as String,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
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
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? AppTheme.textPrimary : AppTheme.textsecandery,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? AppTheme.primaryColor : AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _processOrder() async {
    // Validate inputs
    if (_nameController.text.trim().isEmpty) {
      AppSnackbar.showError(context.l10n.enterName);
      return;
    }
    if (_addressController.text.trim().isEmpty) {
      AppSnackbar.showError(context.l10n.enterAddress);
      return;
    }
    if (_phoneController.text.trim().isEmpty) {
      AppSnackbar.showError(context.l10n.enterPhone);
      return;
    }
    if (cartController.cartItems.isEmpty) {
      AppSnackbar.showError(context.l10n.cartEmpty);
      return;
    }

    setState(() => _isProcessing = true);

    try {
      // Create Order
      final newOrder = Order(
        userId: authController.currentUser.value?.id ?? '',
        orderDate: DateTime.now().toIso8601String(),
        totalAmount: total,
        items:
            cartController.cartItems
                .map(
                  (item) => OrderItem(
                    productId: item.productId,
                    quantity: item.quantity,
                    price: item.product.price,
                    orderId: '',
                    product: item.product,
                  ),
                )
                .toList(),
        status: "Pending",
        shippingName: _nameController.text.trim(),
        shippingAddress: _addressController.text.trim(),
        shippingPhone: _phoneController.text.trim(),
        deliveryMethod:
            deliveryMethods[_selectedDeliveryMethod]['title'] as String,
        shippingCost: shippingCost,
        paymentMethod:
            paymentMethods[_selectedPaymentMethod]['title'] as String,
        paymentStatus: _selectedPaymentMethod == 0 ? 'Pending' : 'Paid',
      );

      // Insert Order
      final orderId = await orderController.insertOrder(newOrder);

      if (orderId == null) {
        AppSnackbar.showError(context.l10n.orderFailed);
        setState(() => _isProcessing = false);
        return;
      }

      // Clear Cart
      await cartController.clearCart();

      // Navigate to Success Screen
      Get.off(() => OrderSuccessScreen(orderId: orderId));
    } catch (e) {
      AppSnackbar.showError(e.toString());
      setState(() => _isProcessing = false);
    }
  }
}
