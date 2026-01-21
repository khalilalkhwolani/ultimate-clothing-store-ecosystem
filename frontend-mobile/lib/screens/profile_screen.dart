import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/l10n/l10n_extension.dart';
import 'package:myprojectshop/controller/auth_controller.dart';
import 'package:myprojectshop/screens/login_screen.dart';
import 'package:myprojectshop/screens/address_screen.dart';
import 'package:myprojectshop/screens/my_orders_screen.dart';
import 'package:myprojectshop/screens/notifications_screen.dart';
import 'package:myprojectshop/screens/settings_screen.dart';
import 'package:myprojectshop/screens/user_details_screen.dart';
import 'package:myprojectshop/theme/theme.dart';
import 'package:myprojectshop/widgets/app_drawer.dart';
import 'package:myprojectshop/widgets/custom_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController usercontroller = Get.find<AuthController>();

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: AppTheme.textsecandery,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textsecandery,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(children: [...items, SizedBox(height: 16)]),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    isDestructive
                        ? AppTheme.error.withOpacity(0.1)
                        : color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isDestructive ? AppTheme.error : color,
                size: 24,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color:
                          isDestructive ? AppTheme.error : AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textsecandery,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppTheme.textsecandery, size: 24),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    usercontroller.loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      backgroundColor: const Color.fromARGB(255, 241, 241, 246),
      body: CustomScrollView(
        slivers: [
          SliverCustomAppBar(
            title: context.l10n.myProfile,
            showBackButton: false,
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      padding: EdgeInsets.all(24),
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
                          Container(
                            height: 100,
                            width: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset(
                                'assets/images/iphon.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Obx(() {
                            return Column(
                              children: [
                                Text(
                                  usercontroller.username ??
                                      context.l10n.userName,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                Text(
                                  usercontroller.currentUser.value?.email ??
                                      context.l10n.emailAddress,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textsecandery,
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          _buildActionCard(
                            icon: Icons.shopping_bag_outlined,
                            title: context.l10n.orders,
                            value: '12',
                            color: AppTheme.primaryColor,
                          ),
                          SizedBox(width: 16),
                          _buildActionCard(
                            icon: Icons.favorite_border,
                            title: context.l10n.favorite,
                            value: '5',
                            color: AppTheme.secondaryColor,
                          ),
                          SizedBox(width: 16),
                          _buildActionCard(
                            icon: Icons.delivery_dining_sharp,
                            title: context.l10n.shopping,
                            value: '5',
                            color: AppTheme.tertiaryColor,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: _buildSection(
                        title: context.l10n.accountSettings,
                        items: [
                          _buildMenuItem(
                            icon: Icons.person_outline,
                            title: context.l10n.profileDetails,
                            subtitle: context.l10n.editYourProfile,
                            color: AppTheme.primaryColor,
                            onTap: () {
                              Get.to(() => UserDetailsScreen());
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.lock_outline,
                            title: context.l10n.security,
                            subtitle: context.l10n.changeYourPassword,
                            color: AppTheme.primaryColor,
                            onTap: () {
                              Get.to(() => SettingsScreen());
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.notifications_none,
                            title: context.l10n.notifications,
                            subtitle: context.l10n.manageNotifications,
                            color: AppTheme.primaryColor,
                            onTap: () {
                              Get.to(() => NotificationsScreen());
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: _buildSection(
                        title: context.l10n.shoppingPreferences,
                        items: [
                          _buildMenuItem(
                            icon: Icons.shopping_bag_outlined,
                            title: context.l10n.myOrders,
                            subtitle: context.l10n.viewOrderHistory,
                            color: AppTheme.secondaryColor,
                            onTap: () {
                              Get.to(() => MyOrdersScreen());
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.location_on_outlined,
                            title: context.l10n.myAddresses,
                            subtitle: context.l10n.yourAddresses,
                            color: AppTheme.secondaryColor,
                            onTap: () {
                              Get.to(() => AddressScreen());
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.payment_outlined,
                            title: context.l10n.paymentMethod,
                            subtitle: context.l10n.paymentMethods,
                            color: AppTheme.secondaryColor,
                            onTap: () {
                              // Handle payment methods tap
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: _buildSection(
                        title: context.l10n.supportAndMore,
                        items: [
                          _buildMenuItem(
                            icon: Icons.settings_outlined,
                            title: context.l10n.settings,
                            subtitle: context.l10n.appSettings,
                            color: AppTheme.tertiaryColor,
                            onTap: () {
                              Get.to(() => SettingsScreen());
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.help_outline,
                            title: context.l10n.helpCenter,
                            subtitle: context.l10n.getHelp,
                            color: AppTheme.tertiaryColor,
                            onTap: () {
                              // Handle help tap
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.logout,
                            title: context.l10n.logout,
                            subtitle: context.l10n.signOut,
                            color: AppTheme.secondaryColor,
                            onTap: () {
                              final authController = Get.find<AuthController>();
                              authController.logout();
                              Get.offAll(() => LoginScreen());
                            },
                            isDestructive: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
