import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/utils/app_snackbar.dart';
import 'package:myprojectshop/model/address_model.dart';

class AddressController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxList<Address> addresses = <Address>[].obs;
  final Rx<Address?> selectedAddress = Rx<Address?>(null);
  final RxBool isLoading = false.obs;

  Future<void> fetchAddresses(String userId) async {
    isLoading.value = true;
    try {
      final snapshot =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('addresses')
              .get();

      addresses.value =
          snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return Address.fromMap(data);
          }).toList();

      // Set selected address to default if available
      if (addresses.isNotEmpty) {
        selectedAddress.value =
            addresses.firstWhereOrNull((a) => a.isDefault) ?? addresses.first;
      }
    } catch (e) {
      print("Error fetching addresses: $e");
      AppSnackbar.showError('Failed to load addresses');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addAddress(Address address) async {
    try {
      // If this is the first address or set as default, ensure others are not default
      if (address.isDefault || addresses.isEmpty) {
        // We handle this by updating others after adding, or checking before.
        // For simplicity, let's add first.
      }

      final docRef = await _firestore
          .collection('users')
          .doc(address.userId)
          .collection('addresses')
          .add(address.toMap());

      final newAddress = address.copyWith(id: docRef.id);

      if (newAddress.isDefault) {
        await _ensureSingleDefault(newAddress);
      }

      addresses.add(newAddress);

      // If it's default or the only address, set as selected
      if (newAddress.isDefault || addresses.length == 1) {
        selectedAddress.value = newAddress;
      }
      return true;
    } catch (e) {
      print("Error adding address: $e");
      AppSnackbar.showError('Failed to add address');
    }
    return false;
  }

  Future<bool> updateAddress(Address address) async {
    if (address.id == null) return false;
    try {
      await _firestore
          .collection('users')
          .doc(address.userId)
          .collection('addresses')
          .doc(address.id)
          .update(address.toMap());

      final index = addresses.indexWhere((a) => a.id == address.id);
      if (index != -1) {
        addresses[index] = address;

        // If this address is now default, update selection and other addresses
        if (address.isDefault) {
          await _ensureSingleDefault(address);
          selectedAddress.value = address;
          // Refresh to update isDefault status for other addresses
          await fetchAddresses(address.userId);
        }
      }
      return true;
    } catch (e) {
      print("Error updating address: $e");
      AppSnackbar.showError('Failed to update address');
    }
    return false;
  }

  Future<bool> deleteAddress(String id) async {
    // We need userId to delete from subcollection.
    // Assuming we can find the address in local list to get userId.
    final address = addresses.firstWhereOrNull((a) => a.id == id);
    if (address == null) return false;

    try {
      await _firestore
          .collection('users')
          .doc(address.userId)
          .collection('addresses')
          .doc(id)
          .delete();

      addresses.removeWhere((a) => a.id == id);

      // If deleted address was selected, select another
      if (selectedAddress.value?.id == id) {
        selectedAddress.value = addresses.isNotEmpty ? addresses.first : null;
      }
      return true;
    } catch (e) {
      print("Error deleting address: $e");
      AppSnackbar.showError('Failed to delete address');
    }
    return false;
  }

  Future<bool> setDefaultAddress(String addressId, String userId) async {
    try {
      // 1. Set all to false
      final batch = _firestore.batch();
      final snapshot =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('addresses')
              .get();

      for (var doc in snapshot.docs) {
        if (doc.id == addressId) {
          batch.update(doc.reference, {'isDefault': true});
        } else {
          batch.update(doc.reference, {'isDefault': false});
        }
      }

      await batch.commit();
      await fetchAddresses(userId);
      return true;
    } catch (e) {
      print("Error setting default address: $e");
      AppSnackbar.showError('Failed to set default address');
      return false;
    }
  }

  Future<void> _ensureSingleDefault(Address newDefault) async {
    try {
      // Set all other addresses to isDefault: false
      final batch = _firestore.batch();
      final snapshot =
          await _firestore
              .collection('users')
              .doc(newDefault.userId)
              .collection('addresses')
              .where(FieldPath.documentId, isNotEqualTo: newDefault.id)
              .get();

      for (var doc in snapshot.docs) {
        batch.update(doc.reference, {'isDefault': false});
      }
      await batch.commit();
    } catch (e) {
      print("Error ensuring single default address: $e");
    }
  }

  void selectAddress(Address address) {
    selectedAddress.value = address;
  }
}
