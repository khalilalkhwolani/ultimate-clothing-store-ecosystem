import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/l10n/l10n_extension.dart';
import 'package:myprojectshop/controller/address_controller.dart';
import 'package:myprojectshop/controller/auth_controller.dart';
import 'package:myprojectshop/model/address_model.dart';
import 'package:myprojectshop/theme/theme.dart';
import 'package:myprojectshop/utils/app_snackbar.dart';
import 'package:myprojectshop/widgets/custom_app_bar.dart';

class AddressScreen extends StatelessWidget {
  final AddressController addressController = Get.find<AddressController>();
  final AuthController authController = Get.find<AuthController>();

  AddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = authController.currentUserId;
    if (userId != null) {
      addressController.fetchAddresses(userId);
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Obx(() {
        if (addressController.isLoading.value) {
          return Scaffold(
            appBar: CustomAppBar(
              title: context.l10n.myAddresses,
              showBackButton: true,
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (addressController.addresses.isEmpty) {
          return Scaffold(
            appBar: CustomAppBar(
              title: context.l10n.myAddresses,
              showBackButton: true,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_off, size: 80, color: Colors.grey[300]),
                  SizedBox(height: 16),
                  Text(
                    context.l10n.noAddresses,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    context.l10n.addYourDeliveryAddress,
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverCustomAppBar(
              title: context.l10n.myAddresses,
              showBackButton: true,
            ),
            SliverPadding(
              padding: EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final address = addressController.addresses[index];
                  return _buildAddressCard(context, address);
                }, childCount: addressController.addresses.length),
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditAddressDialog(context),
        backgroundColor: AppTheme.primaryColor,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          context.l10n.addAddress,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, Address address) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border:
            address.isDefault
                ? Border.all(color: AppTheme.primaryColor, width: 2)
                : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.location_on, color: AppTheme.primaryColor),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            address.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (address.isDefault) ...[
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                context.l10n.defaultLabel,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        address.phone,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showAddEditAddressDialog(context, address: address);
                    } else if (value == 'delete') {
                      _deleteAddress(address.id!, context);
                    } else if (value == 'default') {
                      addressController.setDefaultAddress(
                        address.id!,
                        address.userId,
                      );
                    }
                  },
                  itemBuilder:
                      (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 20),
                              SizedBox(width: 8),
                              Text(context.l10n.edit),
                            ],
                          ),
                        ),
                        if (!address.isDefault)
                          PopupMenuItem(
                            value: 'default',
                            child: Row(
                              children: [
                                Icon(Icons.check_circle, size: 20),
                                SizedBox(width: 8),
                                Text(context.l10n.setAsDefault),
                              ],
                            ),
                          ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 20, color: Colors.red),
                              SizedBox(width: 8),
                              Text(
                                context.l10n.delete,
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                ),
              ],
            ),
            SizedBox(height: 12),
            Divider(),
            SizedBox(height: 8),
            Text(
              address.fullAddress,
              style: TextStyle(color: Colors.grey[700]),
            ),
            if (address.postalCode != null && address.postalCode!.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  '${context.l10n.postalCode}: ${address.postalCode}',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showAddEditAddressDialog(BuildContext context, {Address? address}) {
    final isEdit = address != null;
    final userId = authController.currentUserId!;

    final nameController = TextEditingController(text: address?.name ?? '');
    final phoneController = TextEditingController(text: address?.phone ?? '');
    final streetController = TextEditingController(text: address?.street ?? '');
    final cityController = TextEditingController(text: address?.city ?? '');
    final countryController = TextEditingController(
      text: address?.country ?? 'Yemen',
    );
    final postalController = TextEditingController(
      text: address?.postalCode ?? '',
    );
    final isDefault = (address?.isDefault ?? false).obs;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEdit ? context.l10n.editAddress : context.l10n.addNewAddress,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              SizedBox(height: 20),
              _buildTextField(
                nameController,
                context.l10n.fullName,
                Icons.person,
              ),
              SizedBox(height: 12),
              _buildTextField(
                phoneController,
                context.l10n.phoneNumber,
                Icons.phone,
              ),
              SizedBox(height: 12),
              _buildTextField(
                streetController,
                context.l10n.streetAddress,
                Icons.home,
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      cityController,
                      context.l10n.city,
                      Icons.location_city,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      countryController,
                      context.l10n.country,
                      Icons.flag,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _buildTextField(
                postalController,
                context.l10n.postalCodeOptional,
                Icons.markunread_mailbox,
              ),
              SizedBox(height: 16),
              Obx(
                () => CheckboxListTile(
                  value: isDefault.value,
                  onChanged: (val) => isDefault.value = val ?? false,
                  title: Text(context.l10n.setAsDefaultAddress),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(context.l10n.cancel),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (nameController.text.isEmpty ||
                            phoneController.text.isEmpty ||
                            streetController.text.isEmpty ||
                            cityController.text.isEmpty ||
                            countryController.text.isEmpty) {
                          AppSnackbar.showError(
                            context.l10n.fillRequiredFields,
                            title: 'Error',
                          );
                          return;
                        }

                        final newAddress = Address(
                          id: address?.id,
                          userId: userId,
                          name: nameController.text,
                          phone: phoneController.text,
                          street: streetController.text,
                          city: cityController.text,
                          country: countryController.text,
                          postalCode:
                              postalController.text.isEmpty
                                  ? null
                                  : postalController.text,
                          isDefault: isDefault.value,
                        );

                        bool success;
                        if (isEdit) {
                          success = await addressController.updateAddress(
                            newAddress,
                          );
                        } else {
                          success = await addressController.addAddress(
                            newAddress,
                          );
                        }

                        if (success) {
                          Get.back();
                          AppSnackbar.showSuccess(
                            isEdit
                                ? context.l10n.addressUpdated
                                : context.l10n.addressAdded,
                            title: 'Success',
                          );
                        } else {
                          AppSnackbar.showError(
                            context.l10n.failedSaveAddress,
                            title: 'Error',
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        isEdit ? context.l10n.update : context.l10n.add,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.primaryColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppTheme.primaryColor),
        ),
      ),
    );
  }

  void _deleteAddress(String id, BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text(context.l10n.deleteAddress),
        content: Text(context.l10n.deleteAddressConfirm),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(context.l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              final success = await addressController.deleteAddress(id);
              if (success) {
                AppSnackbar.showSuccess(
                  context.l10n.addressDeleted,
                  title: 'Success',
                );
              }
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
