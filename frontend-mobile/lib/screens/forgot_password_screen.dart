import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/l10n/l10n_extension.dart';
import 'package:myprojectshop/controller/auth_controller.dart';
import 'package:myprojectshop/theme/theme.dart';
import 'package:myprojectshop/utils/app_snackbar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();
  bool isLoading = false;
  bool emailSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.primaryColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Center(
                child: Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    emailSent ? Icons.mark_email_read : Icons.lock_reset,
                    size: 60,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
              SizedBox(height: 32),

              // Title
              Center(
                child: Text(
                  emailSent
                      ? context.l10n.checkEmail
                      : context.l10n.forgotPasswordTitle,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              SizedBox(height: 12),

              // Description
              Center(
                child: Text(
                  emailSent
                      ? context.l10n.resetLinkSentDesc
                      : context.l10n.forgotPasswordDesc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ),
              SizedBox(height: 40),

              if (!emailSent) ...[
                // Email Field
                Text(
                  context.l10n.emailAddress,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: context.l10n.enterEmailHint,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: AppTheme.primaryColor,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppTheme.primaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child:
                        isLoading
                            ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : Text(
                              context.l10n.sendResetLink,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),
              ] else ...[
                // Success - Open Email Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      AppSnackbar.showInfo(
                        context.l10n.openingEmailApp,
                        title: 'Info',
                      );
                    },
                    icon: Icon(Icons.email, color: Colors.white),
                    label: Text(
                      context.l10n.openEmailApp,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Resend Link
                Center(
                  child: TextButton(
                    onPressed: () {
                      setState(() => emailSent = false);
                    },
                    child: Text(
                      context.l10n.resendEmailLink,
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],

              SizedBox(height: 32),

              // Back to Login
              Center(
                child: TextButton.icon(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.arrow_back, size: 18),
                  label: Text(context.l10n.backToLogin),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubmit() async {
    if (emailController.text.isEmpty) {
      AppSnackbar.showError(context.l10n.enterEmail, title: context.l10n.error);
      return;
    }

    if (!GetUtils.isEmail(emailController.text)) {
      AppSnackbar.showError(
        context.l10n.enterValidEmail,
        title: context.l10n.error,
      );
      return;
    }

    setState(() => isLoading = true);

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      isLoading = false;
      emailSent = true;
    });

    AppSnackbar.showSuccess(
      '${context.l10n.resetLinkSentSuccess} ${emailController.text}',
      title: context.l10n.success,
    );
  }
}
