import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/l10n/l10n_extension.dart';
import 'package:myprojectshop/controller/auth_controller.dart';
import 'package:myprojectshop/screens/login_screen.dart';
import 'package:myprojectshop/screens/main_screen.dart';
import 'package:myprojectshop/theme/theme.dart';
import 'package:myprojectshop/widgets/custom_text_field.dart';
import 'package:myprojectshop/widgets/gradient_button.dart';
import 'package:myprojectshop/widgets/social_login_button.dart';
import 'package:myprojectshop/utils/app_snackbar.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthController authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  bool _isLoading = false;
  bool _acceptTerms = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptTerms) {
      AppSnackbar.showError(context.l10n.acceptTermsError);
      return;
    }

    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);

    final success = await authController.registerUser(
      username: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    setState(() => _isLoading = false);

    if (success) {
      AppSnackbar.showSuccess(context.l10n.accountCreated);
      Get.offAll(() =>  MainScreen());
    }
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
                    // الخلفية الزرقاء - نفس تصميم Login
                    _buildHeader(constraints),

                    // الفورم الأبيض
                    Padding(
                      padding: EdgeInsets.only(
                        top: constraints.maxHeight * 0.18,
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
      height: constraints.maxHeight * 0.45,
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
          // Decorative circles
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
          Positioned(
            bottom: 50,
            left: -30,
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
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
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      context.l10n.createAccount,
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
                context.l10n.signup,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                context.l10n.signupSubtitle,
                style: TextStyle(fontSize: 14, color: AppTheme.textsecandery),
              ),
            ),
            const SizedBox(height: 24),

            // Name Field
            CustomTextField(
              label: context.l10n.fullName,
              prefixIcon: Icons.person_outline,
              keyboardType: TextInputType.name,
              controller: nameController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return context.l10n.enterName;
                }
                if (value.trim().length < 2) {
                  return context.l10n.nameMinLength;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Email Field
            CustomTextField(
              label: context.l10n.email,
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return context.l10n.enterEmail;
                }
                if (!GetUtils.isEmail(value.trim())) {
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
            const SizedBox(height: 16),

            // Confirm Password Field
            CustomTextField(
              label: context.l10n.confirmPassword,
              prefixIcon: Icons.lock_outline,
              keyboardType: TextInputType.visiblePassword,
              isPassword: true,
              controller: confirmPasswordController,
              validator: (value) {
                if (value != passwordController.text) {
                  return context.l10n.passwordsNotMatch;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Terms & Conditions Checkbox
            Row(
              children: [
                Checkbox(
                  value: _acceptTerms,
                  onChanged:
                      (value) => setState(() => _acceptTerms = value ?? false),
                  activeColor: AppTheme.primaryColor,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _acceptTerms = !_acceptTerms),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: AppTheme.textsecandery,
                          fontSize: 13,
                        ),
                        children: [
                          TextSpan(text: '${context.l10n.iAgreeToThe} '),
                          TextSpan(
                            text: context.l10n.termsAndConditions,
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Signup Button
            GradientButton(
              text:
                  _isLoading
                      ? '${context.l10n.loading}...'
                      : context.l10n.createAccount,
              onPressed: _isLoading ? () {} : _signup,
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
                        () =>
                            AppSnackbar.showInfo('Google signup coming soon!'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SocialLoginButton(
                    iconPath: "assets/icons/iphon.png",
                    text: context.l10n.apple,
                    image: "assets/icons/iphon.png",
                    onPressed:
                        () => AppSnackbar.showInfo('Apple signup coming soon!'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Login Link
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.l10n.alreadyHaveAccount,
                    style: TextStyle(
                      color: AppTheme.textsecandery,
                      fontSize: 14,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.off(() => const LoginScreen()),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                    ),
                    child: Text(
                      context.l10n.login,
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
