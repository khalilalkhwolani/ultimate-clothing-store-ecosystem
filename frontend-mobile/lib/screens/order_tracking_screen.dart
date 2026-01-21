import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myprojectshop/l10n/l10n_extension.dart';
import 'package:myprojectshop/model/order_model.dart';
import 'package:myprojectshop/theme/theme.dart';
import 'package:myprojectshop/widgets/custom_app_bar.dart';

class OrderTrackingScreen extends StatelessWidget {
  final Order order;

  const OrderTrackingScreen({super.key, required this.order});

  // Helper to format date nicely
  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy - HH:mm').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  // Helper to get short order ID
  String _getShortOrderId() {
    if (order.id == null) return 'N/A';
    return order.id!.length > 8
        ? order.id!.substring(0, 8).toUpperCase()
        : order.id!.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverCustomAppBar(
            title: context.l10n.trackOrder,
            showBackButton: true,
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Order Info Card
                _buildOrderInfoCard(context),

                // Timeline
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildTimelineItem(
                        context: context,
                        status: context.l10n.orderPlaced,
                        date: _formatDate(order.orderDate),
                        description: context.l10n.orderPlacedDesc,
                        isCompleted: order.currentStatusStep >= 0,
                        isFirst: true,
                      ),
                      _buildTimelineItem(
                        context: context,
                        status: context.l10n.orderConfirmed,
                        date:
                            order.currentStatusStep >= 1
                                ? _getEstimatedDate(1)
                                : '',
                        description:
                            order.currentStatusStep >= 1
                                ? context.l10n.orderConfirmedDesc
                                : '',
                        isCompleted: order.currentStatusStep >= 1,
                      ),
                      _buildTimelineItem(
                        context: context,
                        status: context.l10n.shipped,
                        date:
                            order.currentStatusStep >= 2
                                ? _getEstimatedDate(2)
                                : '',
                        description:
                            order.currentStatusStep >= 2
                                ? context.l10n.shippedDesc
                                : '',
                        isCompleted: order.currentStatusStep >= 2,
                      ),
                      _buildTimelineItem(
                        context: context,
                        status: context.l10n.outForDelivery,
                        date:
                            order.currentStatusStep >= 3
                                ? _getEstimatedDate(3)
                                : '',
                        description:
                            order.currentStatusStep >= 3
                                ? context.l10n.outForDeliveryDesc
                                : '',
                        isCompleted: order.currentStatusStep >= 3,
                      ),
                      _buildTimelineItem(
                        context: context,
                        status: context.l10n.delivered,
                        date:
                            order.currentStatusStep >= 4
                                ? _getEstimatedDate(4)
                                : '',
                        description:
                            order.currentStatusStep >= 4
                                ? context.l10n.deliveredDesc
                                : '',
                        isCompleted: order.currentStatusStep >= 4,
                        isLast: true,
                      ),
                    ],
                  ),
                ),

                // Delivery Details Card
                _buildDeliveryDetailsCard(context),

                SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getEstimatedDate(int step) {
    try {
      final orderDateTime = DateTime.parse(order.orderDate);
      final estimatedDate = orderDateTime.add(Duration(days: step));
      return DateFormat('dd/MM/yyyy').format(estimatedDate);
    } catch (e) {
      return '';
    }
  }

  Widget _buildOrderInfoCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${context.l10n.order} #${_getShortOrderId()}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getLocalizedStatus(context, order.status),
                  style: TextStyle(
                    color: _getStatusColor(order.status),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Divider(),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem(
                context.l10n.items,
                '${order.items.length}',
                Icons.shopping_bag_outlined,
              ),
              _buildInfoItem(
                context.l10n.total,
                '\$${order.totalAmount.toStringAsFixed(2)}',
                Icons.attach_money,
              ),
              _buildInfoItem(
                context.l10n.date,
                _formatDate(order.orderDate).split(' - ').first,
                Icons.calendar_today_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getLocalizedStatus(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return context.l10n.pending;
      case 'confirmed':
        return context.l10n.orderConfirmed;
      case 'shipped':
        return context.l10n.shipped;
      case 'out for delivery':
        return context.l10n.outForDelivery;
      case 'delivered':
        return context.l10n.delivered;
      case 'cancelled':
        return context.l10n.cancelled;
      default:
        return status;
    }
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 20),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: AppTheme.textsecandery),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'out for delivery':
        return Colors.indigo;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return AppTheme.primaryColor;
    }
  }

  Widget _buildDeliveryDetailsCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
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
            context.l10n.deliveryDetails,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 16),

          // Delivery Address
          _buildDetailRow(
            icon: Icons.location_on_outlined,
            title: context.l10n.deliveryAddress,
            value: order.shippingAddress ?? context.l10n.noAddressProvided,
          ),

          SizedBox(height: 16),
          Divider(),
          SizedBox(height: 16),

          // Delivery Method
          _buildDetailRow(
            icon: Icons.local_shipping_outlined,
            title: context.l10n.deliveryMethod,
            value: order.deliveryMethod ?? context.l10n.standardDelivery,
          ),

          if (order.trackingNumber != null) ...[
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 16),
            _buildDetailRow(
              icon: Icons.qr_code,
              title: context.l10n.trackingNumber,
              value: order.trackingNumber!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.primaryColor),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12, color: AppTheme.textsecandery),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineItem({
    required BuildContext context,
    required String status,
    required String date,
    required String description,
    required bool isCompleted,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Column(
              children: [
                if (!isFirst)
                  Container(
                    width: 2,
                    height: 30,
                    color:
                        isCompleted
                            ? AppTheme.primaryColor
                            : AppTheme.textsecandery.withOpacity(0.2),
                  ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted ? AppTheme.primaryColor : Colors.white,
                    border: Border.all(
                      width: 2,
                      color:
                          isCompleted
                              ? AppTheme.primaryColor
                              : AppTheme.textsecandery,
                    ),
                  ),
                  child:
                      isCompleted
                          ? const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          )
                          : null,
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 30,
                    color:
                        isCompleted
                            ? AppTheme.primaryColor
                            : AppTheme.textsecandery.withOpacity(0.2),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          isCompleted
                              ? AppTheme.primaryColor
                              : AppTheme.textPrimary,
                    ),
                  ),
                  if (date.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textsecandery,
                      ),
                    ),
                  ],
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
