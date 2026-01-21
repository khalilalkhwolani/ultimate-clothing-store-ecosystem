import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/l10n/l10n_extension.dart';
// import 'package:myprojectshop/admin/screens/admin_dashboard_screen.dart';
import 'package:myprojectshop/controller/auth_controller.dart';
import 'package:myprojectshop/screens/main_screen.dart';
import 'package:myprojectshop/screens/signup_screen.dart';
import 'package:myprojectshop/screens/forgot_password_screen.dart';
import 'package:myprojectshop/theme/theme.dart';
import 'package:myprojectshop/widgets/custom_text_field.dart';
import 'package:myprojectshop/widgets/gradient_button.dart';
import 'package:myprojectshop/widgets/social_login_button.dart';
import 'package:myprojectshop/utils/app_snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  final AuthController authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController emailController;
  late TextEditingController passwordController;

  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);

    final success = await authController.loginUser(
      usernameOrEmail: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (success) {
      if (authController.isAdmin) {
        Get.offAll(() => MainScreen());
      } else {
        Get.offAll(() => MainScreen());
      }
    } else {
      if (authController.errorMessage.value.contains('not found')) {
        _showAccountNotFoundDialog();
      } else {
        AppSnackbar.showError(
          authController.errorMessage.value,
          title: context.l10n.loginFailed,
        );
      }
    }
  }

  void _showAccountNotFoundDialog() {
    Get.defaultDialog(
      title: context.l10n.accountNotFound,
      middleText: context.l10n.emailNotRegistered,
      textCancel: context.l10n.cancel,
      textConfirm: context.l10n.signup,
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        Get.to(() => const SignupScreen());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Stack(
                  children: [
                    // الخلفية الزرقاء
                    _buildHeader(constraints),

                    // الفورم الأبيض
                    Padding(
                      padding: EdgeInsets.only(
                        top: constraints.maxHeight * 0.2,
                      ),
                      child: _buildForm(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BoxConstraints constraints) {
    return Container(
      height: constraints.maxHeight * 0.5,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppTheme.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Stack(
        children: [
          // Decorative circle
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          // Back button and title
          Positioned(
            top: 48,
            left: 16,
            right: 16,
            child: Row(
              children: [
                if (Navigator.canPop(context))
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  )
                else
                  const SizedBox(width: 48),
                Expanded(
                  child: Center(
                    child: Text(
                      context.l10n.welcomeBack,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                context.l10n.login,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Email Field
            CustomTextField(
              label: context.l10n.email,
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.l10n.enterEmail;
                }
                if (!GetUtils.isEmail(value)) {
                  return context.l10n.enterValidEmail;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Password Field
            CustomTextField(
              label: context.l10n.password,
              prefixIcon: Icons.lock_outline,
              keyboardType: TextInputType.visiblePassword,
              isPassword: true,
              controller: passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.l10n.enterPassword;
                }
                if (value.length < 6) {
                  return context.l10n.passwordMinLength;
                }
                return null;
              },
            ),

            // Remember Me & Forgot Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged:
                          (value) =>
                              setState(() => _rememberMe = value ?? false),
                      activeColor: AppTheme.primaryColor,
                    ),
                    Text(
                      context.l10n.rememberMe,
                      style: TextStyle(
                        color: AppTheme.textsecandery,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => Get.to(() => ForgotPasswordScreen()),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                  ),
                  child: Text(context.l10n.forgotPassword),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Login Button
            GradientButton(
              text:
                  _isLoading
                      ? '${context.l10n.loading}...'
                      : context.l10n.login,
              onPressed: _isLoading ? () {} : _login,
            ),
            const SizedBox(height: 24),

            // Divider
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: AppTheme.textsecandery.withOpacity(0.3),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    context.l10n.orContinueWith,
                    style: TextStyle(
                      color: AppTheme.textsecandery,
                      fontSize: 14,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: AppTheme.textsecandery.withOpacity(0.3),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Social Login Buttons
            Row(
              children: [
                Expanded(
                  child: SocialLoginButton(
                    iconPath: "assets/icons/google.png",
                    text: context.l10n.google,
                    image: "assets/icons/google.png",
                    onPressed:
                        () => AppSnackbar.showInfo('Google login coming soon!'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SocialLoginButton(
                    iconPath: "assets/icons/iphon.png",
                    text: context.l10n.apple,
                    image: "assets/icons/iphon.png",
                    onPressed:
                        () => AppSnackbar.showInfo('Apple login coming soon!'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Sign Up Link
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.l10n.dontHaveAccount,
                    style: TextStyle(
                      color: AppTheme.textsecandery,
                      fontSize: 14,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.to(() => const SignupScreen()),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                    ),
                    child: Text(
                      context.l10n.signup,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
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
