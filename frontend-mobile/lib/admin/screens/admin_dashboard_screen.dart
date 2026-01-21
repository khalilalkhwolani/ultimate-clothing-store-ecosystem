import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/admin/controllers/admin_dashboard_controller.dart';
import 'package:myprojectshop/admin/screens/manage_categories_screen.dart';
import 'package:myprojectshop/admin/screens/manage_orders_screen.dart';
import 'package:myprojectshop/admin/screens/manage_products_screen.dart';
import 'package:myprojectshop/admin/screens/manage_users_screen.dart';
import 'package:myprojectshop/controller/auth_controller.dart';
import 'package:myprojectshop/screens/main_screen.dart';
import 'package:myprojectshop/theme/theme.dart';
import 'package:myprojectshop/widgets/custom_app_bar.dart';

class AdminDashboardScreen extends StatelessWidget {
  AdminDashboardScreen({super.key});

  final AdminDashboardController controller = Get.put(
    AdminDashboardController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Scaffold(
            appBar: CustomAppBar(
              title: 'Admin Dashboard',
              showBackButton: true,
              actions: [
                IconButton(
                  icon: Icon(Icons.logout, color: Colors.white),
                  onPressed: () => Get.find<AuthController>().logout(),
                ),
              ],
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final authController = Get.find<AuthController>();
        return CustomScrollView(
          slivers: [
            SliverCustomAppBar(
              title: 'Admin Dashboard',
              showBackButton: true,
              actions: [
                IconButton(
                  icon: Icon(Icons.logout, color: Colors.white),
                  onPressed: () => Get.find<AuthController>().logout(),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Welcome, ${authController.username ?? "Admin"}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textsecandery,
                          ),
                        ),
                        Text(
                          'Statistics',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        _buildStatCard(
                          'Total Products',
                          controller.totalProducts.value.toString(),
                          Icons.inventory,
                        ),
                        SizedBox(width: 16),
                        _buildStatCard(
                          'Total Orders',
                          controller.totalOrders.value.toString(),
                          Icons.shopping_cart,
                        ),
                        SizedBox(width: 16),
                        _buildStatCard(
                          'Total Users',
                          controller.totalUsers.value.toString(),
                          Icons.people,
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    Text(
                      'Management',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildManagementCard(
                    'Manage Products',
                    Icons.inventory,
                    () => Get.to(() => ManageProductsScreen()),
                  ),
                  _buildManagementCard(
                    'Manage Categories',
                    Icons.category,
                    () => Get.to(() => ManageCategoriesScreen()),
                  ),
                  _buildManagementCard(
                    'Manage Orders',
                    Icons.shopping_cart,
                    () => Get.to(() => ManageOrdersScreen()),
                  ),
                  _buildManagementCard(
                    'Manage Users',
                    Icons.people,
                    () => Get.to(() => ManageUsersScreen()),
                  ),
                  _buildManagementCard(
                    'Go to Store',
                    Icons.store,
                    () => Get.offAll(() => MainScreen()),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 16)),
          ],
        );
      }),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 40, color: AppTheme.primaryColor),
              SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(title, style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildManagementCard(String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: AppTheme.primaryColor),
              SizedBox(height: 8),
              Text(title, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
