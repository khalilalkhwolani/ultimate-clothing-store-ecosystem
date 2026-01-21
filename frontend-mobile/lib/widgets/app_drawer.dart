import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/controller/auth_controller.dart';
import 'package:myprojectshop/l10n/l10n_extension.dart';
import 'package:myprojectshop/screens/categories_screen.dart';
import 'package:myprojectshop/screens/external_products_screen.dart';
import 'package:myprojectshop/screens/login_screen.dart';
import 'package:myprojectshop/screens/search_filter_screen.dart';
import 'package:myprojectshop/screens/wishlist_screen.dart';
import 'package:myprojectshop/theme/theme.dart';
import 'package:myprojectshop/admin/screens/admin_dashboard_screen.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Premium Gradient Header
          _buildHeader(context),

          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              children: [
                // Admin Section (if admin)
                Obx(() {
                  final authController = Get.find<AuthController>();
                  if (authController.isAdmin) {
                    return Column(
                      children: [
                        _buildMenuItem(
                          index: -1,
                          icon: Icons.admin_panel_settings,
                          title: 'Admin Dashboard',
                          iconColor: Colors.purple,
                          onTap: () {
                            Navigator.pop(context);
                            Get.to(() => AdminDashboardScreen());
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Divider(height: 1),
                        ),
                      ],
                    );
                  }
                  return SizedBox.shrink();
                }),

                // Regular Menu Items
                // _buildMenuItem(
                //   index: 0,
                //   icon: Icons.home_rounded,
                //   title: context.l10n.home,
                //   iconColor: AppTheme.primaryColor,
                //   onTap: () {
                //     setState(() => _selectedIndex = 0);
                //     Navigator.pop(context);
                //   },
                // ),
                _buildMenuItem(
                  index: 1,
                  icon: Icons.category_rounded,
                  title: context.l10n.categories,
                  iconColor: Color(0xFF00BCD4),
                  onTap: () {
                    setState(() => _selectedIndex = 1);
                    Navigator.pop(context);
                    Get.to(() => CategoriesScreen());
                  },
                ),
                _buildMenuItem(
                  index: 2,
                  icon: Icons.store_rounded,
                  title: context.l10n.onlineStore,
                  iconColor: Color(0xFF4CAF50),
                  onTap: () {
                    setState(() => _selectedIndex = 2);
                    Navigator.pop(context);
                    Get.to(() => ExternalProductsScreen());
                  },
                ),
                _buildMenuItem(
                  index: 3,
                  icon: Icons.favorite_rounded,
                  title: context.l10n.wishlist,
                  iconColor: Color(0xFFE91E63),
                  onTap: () {
                    setState(() => _selectedIndex = 3);
                    Navigator.pop(context);
                    Get.to(() => WishlistScreen());
                  },
                ),
                _buildMenuItem(
                  index: 4,
                  icon: Icons.search_rounded,
                  title: context.l10n.search,
                  iconColor: Color(0xFFFF9800),
                  onTap: () {
                    setState(() => _selectedIndex = 4);
                    Navigator.pop(context);
                    Get.to(() => SearchFilterScreen());
                  },
                ),

                SizedBox(height: 16),

                // Logout Button
                _buildLogoutButton(context),
              ],
            ),
          ),

          // Version Footer
          _buildVersionFooter(),
        ],
      ),
    );
  }

  // Premium Gradient Header
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        bottom: 30,
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppTheme.premiumGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Obx(() {
        final authController = Get.find<AuthController>();
        return Column(
          children: [
            // Avatar
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  (authController.username ?? "G")[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
            // Name
            Text(
              authController.username ?? "Guest",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            // Email
            Text(
              authController.email ?? "",
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 13,
              ),
            ),
          ],
        );
      }),
    );
  }

  // Menu Item with selection highlight
  Widget _buildMenuItem({
    required int index,
    required IconData icon,
    required String title,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    final isSelected = _selectedIndex == index;

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: Material(
        color: isSelected ? iconColor.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          splashColor: iconColor.withOpacity(0.2),
          highlightColor: iconColor.withOpacity(0.1),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border:
                  isSelected
                      ? Border.all(color: iconColor.withOpacity(0.3), width: 1)
                      : null,
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? iconColor : AppTheme.textPrimary,
                  ),
                ),
                Spacer(),
                if (isSelected)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: iconColor,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Logout Button
  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            Get.find<AuthController>().logout();
            Get.offAll(() => LoginScreen());
          },
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.red.withOpacity(0.2),
          highlightColor: Colors.red.withOpacity(0.1),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.logout_rounded,
                  color: Colors.red.shade400,
                  size: 22,
                ),
                SizedBox(width: 12),
                Text(
                  context.l10n.logout,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Version Footer
  Widget _buildVersionFooter() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppTheme.premiumGradient,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          'الإصدار 1.0.0',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
