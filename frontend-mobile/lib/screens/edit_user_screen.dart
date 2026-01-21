import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/l10n/l10n_extension.dart';
import 'package:myprojectshop/controller/auth_controller.dart';
import 'package:myprojectshop/model/user_model.dart';
import 'package:myprojectshop/theme/theme.dart';
import 'package:myprojectshop/utils/app_snackbar.dart';

class EditUserScreen extends StatefulWidget {
  const EditUserScreen({Key? key}) : super(key: key);

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final AuthController authController = Get.find<AuthController>();

  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(
      text: authController.currentUser.value?.username ?? '',
    );
    emailController = TextEditingController(
      text: authController.currentUser.value?.email ?? '',
    );
    phoneController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(context.l10n.editProfile),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppTheme.primaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: isLoading ? null : _saveChanges,
            child: Text(
              context.l10n.save,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Picture
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: () {
                AppSnackbar.showInfo(
                  context.l10n.photoUploadSoon,
                  title: context.l10n.comingSoon,
                );
              },
              child: Text(
                context.l10n.changePhoto,
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 24),

            // Form Fields
            _buildTextField(
              controller: usernameController,
              label: context.l10n.username,
              icon: Icons.person_outline,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: emailController,
              label: context.l10n.emailAddress,
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: phoneController,
              label: context.l10n.phoneNumber,
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 32),

            // Change Password Section
            Container(
              padding: EdgeInsets.all(16),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.security,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.lock_outline, color: Colors.orange),
                    ),
                    title: Text(context.l10n.changePassword),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () => _showChangePasswordDialog(),
                  ),
                  Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.delete_outline, color: Colors.red),
                    ),
                    title: Text(
                      context.l10n.deleteAccount,
                      style: TextStyle(color: Colors.red),
                    ),
                    trailing: Icon(Icons.chevron_right, color: Colors.red),
                    onTap: () => _showDeleteAccountDialog(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Container(
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
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppTheme.primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppTheme.primaryColor),
          ),
        ),
      ),
    );
  }

  void _saveChanges() async {
    if (usernameController.text.isEmpty || emailController.text.isEmpty) {
      AppSnackbar.showError(
        context.l10n.usernameEmailRequired,
        title: context.l10n.error,
      );
      return;
    }

    setState(() => isLoading = true);

    final currentUser = authController.currentUser.value;
    if (currentUser != null) {
      final updatedUser = UserModel(
        id: currentUser.id,
        username: usernameController.text,
        email: emailController.text,
        password: currentUser.password,
        role: currentUser.role,
        phone: phoneController.text,
        gender: currentUser.gender,
        dateOfBirth: currentUser.dateOfBirth,
        memberSince: currentUser.memberSince,
        profileImageUrl: currentUser.profileImageUrl,
      );

      final success = await authController.updateUserProfile(updatedUser);
      if (success) {
        Get.back();
      }
    }

    setState(() => isLoading = false);
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text(context.l10n.changePassword),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: context.l10n.currentPassword,
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: context.l10n.newPassword,
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: context.l10n.confirmNewPassword,
                prefixIcon: Icon(Icons.lock),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(context.l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              AppSnackbar.showSuccess(
                context.l10n.passwordChangedSuccess,
                title: context.l10n.success,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: Text(
              context.l10n.change,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(context.l10n.deleteAccount),
        content: Text(context.l10n.deleteAccountConfirm),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(context.l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              authController.logout();
              AppSnackbar.showSuccess(
                context.l10n.accountDeletedMsg,
                title: context.l10n.accountDeletedTitle,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(
              context.l10n.delete,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
