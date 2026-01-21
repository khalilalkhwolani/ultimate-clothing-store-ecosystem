import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/controller/auth_controller.dart';
import 'package:myprojectshop/theme/theme.dart';

class ManageUsersScreen extends StatelessWidget {
  ManageUsersScreen({super.key});

  final AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchAllUsers();
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Users'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: controller.allUsers.length,
          itemBuilder: (context, index) {
            final user = controller.allUsers[index];
            return ListTile(
              title: Text(user.username),
              subtitle: Text('${user.email} - Role: ${user.role}'),
            );
          },
        );
      }),
    );
  }
}
