import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/l10n/l10n_extension.dart';
import 'package:myprojectshop/controller/theme_controller.dart';
import 'package:myprojectshop/controller/language_controller.dart';
import 'package:myprojectshop/theme/theme.dart';
import 'package:myprojectshop/utils/app_snackbar.dart';
import 'package:myprojectshop/widgets/custom_app_bar.dart';
import 'package:myprojectshop/core/app_config.dart';

class SettingsScreen extends StatelessWidget {
  final ThemeController themeController = Get.find<ThemeController>();
  final LanguageController languageController = Get.find<LanguageController>();

  SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverCustomAppBar(
            title: context.l10n.settings,
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Appearance Section
                _buildSectionHeader(context.l10n.appearance),
                _buildSettingsCard(
                  children: [
                    Obx(
                      () => SwitchListTile(
                        title: Text(context.l10n.darkMode),
                        subtitle: Text(context.l10n.switchTheme),
                        value: themeController.isDarkMode.value,
                        onChanged:
                            (value) => themeController.setDarkMode(value),
                        secondary: Icon(
                          themeController.isDarkMode.value
                              ? Icons.dark_mode
                              : Icons.light_mode,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Language Section
                _buildSettingsCard(
                  children: [
                    Obx(
                      () => SwitchListTile(
                        title: Text(context.l10n.language),
                        subtitle: Text(
                          languageController.isArabic.value
                              ? 'العربية'
                              : 'English',
                        ),
                        value: languageController.isArabic.value,
                        onChanged:
                            (value) => languageController.toggleLanguage(),
                        secondary: Icon(
                          Icons.language,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                SizedBox(height: 24),

                // Data Source Section (For Testing/Admin)
                _buildSectionHeader('Data Source'),
                _buildSettingsCard(
                  children: [
                    Obx(() {
                      final appConfig = Get.find<AppConfig>();
                      return Column(
                        children: [
                          RadioListTile<DataSource>(
                            title: Text('Firebase'),
                            subtitle: Text('Cloud Firestore'),
                            value: DataSource.Firebase,
                            groupValue: appConfig.currentDataSource.value,
                            onChanged: (value) {
                              if (value != null)
                                appConfig.switchDataSource(value);
                            },
                            activeColor: AppTheme.primaryColor,
                          ),
                          Divider(height: 1),
                          RadioListTile<DataSource>(
                            title: Text('FakeStore API'),
                            subtitle: Text('Demo Data'),
                            value: DataSource.FakeStore,
                            groupValue: appConfig.currentDataSource.value,
                            onChanged: (value) {
                              if (value != null)
                                appConfig.switchDataSource(value);
                            },
                            activeColor: AppTheme.primaryColor,
                          ),
                          Divider(height: 1),
                          RadioListTile<DataSource>(
                            title: Text('Laravel API'),
                            subtitle: Text('Real Backend (Hybrid)'),
                            value: DataSource.Laravel,
                            groupValue: appConfig.currentDataSource.value,
                            onChanged: (value) {
                              if (value != null)
                                appConfig.switchDataSource(value);
                            },
                            activeColor: AppTheme.primaryColor,
                          ),
                        ],
                      );
                    }),
                  ],
                ),
                SizedBox(height: 24),

                // App Info Section
                _buildSectionHeader(context.l10n.appInfo),
                _buildSettingsCard(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.info_outline,
                        color: AppTheme.primaryColor,
                      ),
                      title: Text(context.l10n.version),
                      trailing: Text(
                        '1.0.0',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(
                        Icons.description_outlined,
                        color: AppTheme.primaryColor,
                      ),
                      title: Text(context.l10n.termsConditions),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        AppSnackbar.showInfo(
                          context.l10n.termsConditionsSoon,
                          title: context.l10n.comingSoon,
                        );
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(
                        Icons.privacy_tip_outlined,
                        color: AppTheme.primaryColor,
                      ),
                      title: Text(context.l10n.privacyPolicy),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        AppSnackbar.showInfo(
                          context.l10n.privacyPolicySoon,
                          title: context.l10n.comingSoon,
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // Support Section
                _buildSectionHeader(context.l10n.support),
                _buildSettingsCard(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.help_outline,
                        color: AppTheme.primaryColor,
                      ),
                      title: Text(context.l10n.helpCenter),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        AppSnackbar.showInfo(
                          context.l10n.helpCenterSoon,
                          title: context.l10n.comingSoon,
                        );
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(
                        Icons.email_outlined,
                        color: AppTheme.primaryColor,
                      ),
                      title: Text(context.l10n.contactUs),
                      subtitle: Text('support@shopease.com'),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        AppSnackbar.showInfo(
                          '${context.l10n.email}: support@shopease.com',
                          title: context.l10n.contact,
                        );
                      },
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}
