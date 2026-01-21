import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboardController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;
  var totalProducts = 0.obs;
  var totalOrders = 0.obs;
  var totalUsers = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardStats();
  }

  Future<void> fetchDashboardStats() async {
    try {
      isLoading.value = true;

      // Fetch Products Count
      QuerySnapshot productsSnapshot =
          await _firestore.collection('products').get();
      totalProducts.value = productsSnapshot.size;

      // Fetch Orders Count
      QuerySnapshot ordersSnapshot =
          await _firestore.collection('orders').get();
      totalOrders.value = ordersSnapshot.size;

      // Fetch Users Count
      QuerySnapshot usersSnapshot = await _firestore.collection('users').get();
      totalUsers.value = usersSnapshot.size;
    } catch (e) {
      print("Error fetching dashboard stats: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
