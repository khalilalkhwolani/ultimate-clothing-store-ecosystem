import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/l10n/l10n_extension.dart';
import 'package:myprojectshop/controller/auth_controller.dart';
import 'package:myprojectshop/controller/cart_controller.dart';
import 'package:myprojectshop/controller/order_controller.dart';
import 'package:myprojectshop/controller/order_item_controller.dart';
import 'package:myprojectshop/model/cart_item_model.dart';
import 'package:myprojectshop/model/order_model.dart';
import 'package:myprojectshop/model/orderitem_model.dart';
import 'package:myprojectshop/screens/order_success_screen.dart';
import 'package:myprojectshop/theme/theme.dart';
import 'package:myprojectshop/widgets/gradient_button.dart';
import 'package:myprojectshop/utils/app_snackbar.dart';
import 'package:myprojectshop/widgets/custom_app_bar.dart';

class PaymentScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final double subtotel;
  // Shipping Info passed from CheckoutScreen
  final String? shippingName;
  final String? shippingAddress;
  final String? shippingPhone;
  final String? deliveryMethod;
  final double? shippingCost;

  PaymentScreen({
    required this.cartItems,
    required this.subtotel,
    this.shippingName,
    this.shippingAddress,
    this.shippingPhone,
    this.deliveryMethod,
    this.shippingCost,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final CartController cartController = Get.find<CartController>();
  final OrderController orderController = Get.find<OrderController>();
  final OrderItemController orderItemController =
      Get.find<OrderItemController>();
  final AuthController userController = Get.find<AuthController>();

  int _selectedPaymentMethod = 0;
  int _selectedCards = 0;
  bool _isProcessing = false;

  final List<Map<String, dynamic>> paymentMethods = [
    {'title': 'Credit Card', 'icon': Icons.credit_card_outlined},
    {'title': 'Mobile Wallet', 'icon': Icons.account_balance_wallet_outlined},
    {'title': 'Apple Pay', 'icon': Icons.apple},
    {'title': 'Cash on Delivery', 'icon': Icons.payment},
  ];

  String get _selectedPaymentMethodName {
    return paymentMethods[_selectedPaymentMethod]['title'] as String;
  }

  Widget _buildStep(int number, String title, bool isActive) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? AppTheme.primaryColor : Colors.white,
              border: Border.all(
                color:
                    isActive ? AppTheme.primaryColor : AppTheme.textsecandery,
                width: 2,
              ),
            ),
            child: Center(
              child:
                  isActive
                      ? Icon(Icons.check, color: Colors.white, size: 18)
                      : Text(
                        number.toString(),
                        style: TextStyle(
                          color: AppTheme.textsecandery,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: isActive ? AppTheme.primaryColor : AppTheme.textsecandery,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepConnector(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        color:
            isActive
                ? AppTheme.primaryColor
                : AppTheme.textsecandery.withOpacity(0.3),
      ),
    );
  }

  Widget _buildPaymentMethod(int index, Map<String, dynamic> method) {
    final isSelected = _selectedPaymentMethod == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
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
            SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                method['icon'] as IconData,
                size: 24,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                method['title'] as String,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(
    String label,
    String value, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 15,
              color: isTotal ? AppTheme.textPrimary : AppTheme.textsecandery,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 15,
              color: isTotal ? AppTheme.primaryColor : AppTheme.textPrimary,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double subtotel = cartController.totalPrice;
    double shipping = widget.shippingCost ?? 5.0;
    double tax = subtotel * 0.05;
    double total = subtotel + shipping + tax;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverCustomAppBar(
            title: context.l10n.checkout,
            showBackButton: true,
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Progress Steps
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _buildStep(1, context.l10n.shoppingStep, true),
                      _buildStepConnector(true),
                      _buildStep(2, context.l10n.paymentStep, true),
                      _buildStepConnector(false),
                      _buildStep(3, context.l10n.confirmStep, false),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Shipping Info Summary
                      if (widget.shippingAddress != null) ...[
                        _buildShippingSummary(),
                        SizedBox(height: 24),
                      ],

                      // Payment Method
                      Text(
                        context.l10n.paymentMethod,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12),
                      for (int i = 0; i < paymentMethods.length; i++)
                        _buildPaymentMethod(i, paymentMethods[i]),

                      SizedBox(height: 16),

                      // Show saved cards only for credit card
                      if (_selectedPaymentMethod == 0) _buildSaveCards(),

                      // Order Summary
                      SizedBox(height: 16),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.orderSummary,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            SizedBox(height: 12),
                            _buildOrderSummary(
                              context.l10n.subtotal,
                              "\$${subtotel.toStringAsFixed(2)}",
                            ),
                            _buildOrderSummary(
                              context.l10n.shipping,
                              "\$${shipping.toStringAsFixed(2)}",
                            ),
                            _buildOrderSummary(
                              context.l10n.tax,
                              "\$${tax.toStringAsFixed(2)}",
                            ),
                            Divider(height: 24),
                            _buildOrderSummary(
                              context.l10n.total,
                              "\$${total.toStringAsFixed(2)}",
                              isTotal: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 120),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomButton(total),
    );
  }

  Widget _buildShippingSummary() {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shipping Details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextButton(onPressed: () => Get.back(), child: Text('Edit')),
            ],
          ),
          Divider(),
          Row(
            children: [
              Icon(Icons.location_on_outlined, color: AppTheme.primaryColor),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.shippingName ?? '',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      widget.shippingAddress ?? '',
                      style: TextStyle(
                        color: AppTheme.textsecandery,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.local_shipping_outlined, color: AppTheme.primaryColor),
              SizedBox(width: 12),
              Text(
                widget.deliveryMethod ?? 'Standard Delivery',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(double total) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: GradientButton(
          text:
              _isProcessing
                  ? 'Processing...'
                  : 'Confirm Order - \$${total.toStringAsFixed(2)}',
          onPressed: _isProcessing ? () {} : () => _processOrder(total),
        ),
      ),
    );
  }

  Future<void> _processOrder(double total) async {
    setState(() => _isProcessing = true);

    try {
      final cartItems = cartController.cartItems;

      if (cartItems.isEmpty) {
        AppSnackbar.showError('Cart is empty', title: 'Error');
        setState(() => _isProcessing = false);
        return;
      }

      // Create Order with all details
      final newOrder = Order(
        userId: userController.currentUser.value?.id ?? '',
        orderDate: DateTime.now().toIso8601String(),
        totalAmount: total,
        items:
            cartItems
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
        // Shipping Info
        shippingName: widget.shippingName ?? userController.username,
        shippingAddress: widget.shippingAddress ?? 'No address provided',
        shippingPhone: widget.shippingPhone,
        // Delivery Info
        deliveryMethod: widget.deliveryMethod ?? 'Standard Delivery',
        shippingCost: widget.shippingCost ?? 5.0,
        // Payment Info
        paymentMethod: _selectedPaymentMethodName,
        paymentStatus: _selectedPaymentMethod == 3 ? 'Pending' : 'Paid',
      );

      // Insert Order
      final orderId = await orderController.insertOrder(newOrder);

      if (orderId == null) {
        AppSnackbar.showError('Failed to create order', title: 'Error');
        setState(() => _isProcessing = false);
        return;
      }

      // Clear Cart
      await cartController.clearCart();

      // Navigate to Success Screen
      Get.off(() => OrderSuccessScreen(orderId: orderId));
    } catch (e) {
      AppSnackbar.showError(e.toString(), title: 'Error');
      setState(() => _isProcessing = false);
    }
  }

  Widget _buildSaveCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Saved Cards',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppTheme.textPrimary,
              ),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.add, color: AppTheme.primaryColor, size: 18),
              label: Text(
                'Add New',
                style: TextStyle(color: AppTheme.primaryColor),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 2,
            itemBuilder: (context, index) => _buildCreditCard(index),
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildCreditCard(int index) {
    final isSelected = _selectedCards == index;
    final colors = [
      AppTheme.premiumGradient,
      [Color(0xFF667EEA), Color(0xFF764BA2)],
    ];

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCards = index;
        });
      },
      child: Container(
        width: 280,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors[index % colors.length],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: colors[index % colors.length][0].withOpacity(0.3),
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'VISA',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                if (isSelected)
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: AppTheme.primaryColor,
                      size: 16,
                    ),
                  ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '**** **** **** ${1234 + index}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CARD HOLDER',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        Text(
                          userController.username ?? 'Card Holder',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EXPIRES',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        Text(
                          '12/27',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
