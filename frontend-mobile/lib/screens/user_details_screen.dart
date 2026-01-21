import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/controller/auth_controller.dart';
import 'package:myprojectshop/screens/edit_user_screen.dart';
import 'package:myprojectshop/theme/theme.dart';

class UserDetailsScreen extends StatelessWidget {
  UserDetailsScreen({super.key});

  final AuthController authController = Get.find<AuthController>();

  Widget _bulidSction(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _buildUserInfo({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: AppTheme.primaryColor),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: valueColor ?? Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Obx(() {
        final user = authController.currentUser.value;
        return SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppTheme.primaryGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -50,
                      right: -50,
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 48,
                      left: 16,
                      right: 16,
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            color: Colors.white,
                            onPressed: () => Get.back(),
                          ),
                          Expanded(
                            child: Text(
                              "Personal Details ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Get.to(() => EditUserScreen()),
                            icon: Icon(Icons.edit),
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.15,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: AppTheme.primaryGradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(color: Colors.white, width: 4),
                        color: Colors.white,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child:
                            user?.profileImageUrl != null
                                ? Image.network(
                                  user!.profileImageUrl!,
                                  fit: BoxFit.cover,
                                )
                                : Image.asset('assets/images/iphon.png'),
                      ),
                    ),
                    SizedBox(height: 24),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                _bulidSction(' Personal Information', [
                                  _buildUserInfo(
                                    icon: Icons.person,
                                    label: 'Full Name',
                                    value: user?.username ?? 'N/A',
                                  ),
                                  _buildUserInfo(
                                    icon: Icons.email,
                                    label: 'Email',
                                    value: user?.email ?? 'N/A',
                                  ),
                                  _buildUserInfo(
                                    icon: Icons.phone,
                                    label: ' Phone',
                                    value: user?.phone ?? 'N/A',
                                  ),
                                ]),
                                SizedBox(height: 20),
                                _bulidSction(' More Information', [
                                  _buildUserInfo(
                                    icon: Icons.date_range_outlined,
                                    label: 'Date of birth',
                                    value: user?.dateOfBirth ?? 'N/A',
                                  ),
                                  _buildUserInfo(
                                    icon: Icons.person,
                                    label: ' Gender',
                                    value: user?.gender ?? 'N/A',
                                  ),
                                ]),
                                SizedBox(height: 20),
                                _bulidSction(' Account Information', [
                                  _buildUserInfo(
                                    icon: Icons.calendar_month,
                                    label: 'Member Since',
                                    value: user?.memberSince ?? 'N/A',
                                  ),
                                ]),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
