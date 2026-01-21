import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myprojectshop/model/user_model.dart';
import 'package:myprojectshop/screens/login_screen.dart';
import 'package:myprojectshop/utils/app_snackbar.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _userKey = 'cached_user';

  // Current user state
  final Rxn<UserModel> currentUser = Rxn<UserModel>();
  final RxList<UserModel> allUsers = <UserModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final RxString errorMessage = ''.obs;

  // Flag to track if we've completed the initial Firebase Auth check
  bool _isInitialAuthCheckDone = false;

  String? get currentUserId => currentUser.value?.id;
  String? get userRole => currentUser.value?.role;
  bool get isAdmin => userRole?.toLowerCase() == 'admin';
  String? get username =>
      (currentUser.value?.username != null &&
              currentUser.value!.username.isNotEmpty)
          ? currentUser.value!.username
          : (currentUser.value?.email != null
              ? currentUser.value!.email.split('@').first
              : null);
  String? get email => currentUser.value?.email;

  @override
  void onInit() {
    super.onInit();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    // 1. Load from cache immediately for fast UI response
    await _loadCachedUser();

    // 2. Listen to Auth State Changes
    _auth.authStateChanges().listen((User? user) async {
      print("Auth state changed: User is ${user?.uid ?? 'null'}");
      if (user != null) {
        _isInitialAuthCheckDone = true;
        isLoggedIn.value = true;
        await _fetchUserData(user.uid);
      } else {
        // If Firebase says no user, we wait a bit on startup to be sure
        if (!_isInitialAuthCheckDone) {
          print("Initial auth check: user is null, waiting...");
          await Future.delayed(const Duration(seconds: 3)); // Increased delay
          // Check again after delay
          if (_auth.currentUser == null) {
            print("Definitive no user on startup. Clearing cache.");
            _clearUserData();
            _isInitialAuthCheckDone = true;
          } else {
            print("User found after delay: ${_auth.currentUser?.uid}");
            _isInitialAuthCheckDone = true;
            isLoggedIn.value = true;
            await _fetchUserData(_auth.currentUser!.uid);
          }
        } else {
          // This is a definitive logout event after the app has already started
          print("Logout detected. Clearing cache.");
          _clearUserData();
        }
      }
    });
  }

  Future<void> _loadCachedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      if (userJson != null) {
        final cachedUser = UserModel.fromMap(json.decode(userJson));
        currentUser.value = cachedUser;
        isLoggedIn.value = true;
        print(
          "Loaded cached user: ${cachedUser.username} (${cachedUser.email})",
        );
      } else {
        print("No user found in cache.");
      }
    } catch (e) {
      print("Error loading cached user: $e");
    }
  }

  Future<void> _saveUserToCache(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final map = user.toMap();
      print("Saving user to cache: $map");
      await prefs.setString(_userKey, json.encode(map));
      print("User saved to cache: ${user.username}");
    } catch (e) {
      print("Error caching user: $e");
    }
  }

  void _clearUserData() async {
    currentUser.value = null;
    isLoggedIn.value = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    print("User data and cache cleared.");
  }

  void clearError() {
    errorMessage.value = '';
  }

  Future<void> _fetchUserData(String uid) async {
    try {
      print("Fetching user data for UID: $uid");
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        print("Firestore data received: $data");
        final user = UserModel.fromMap(data);
        print("User model created: $user");
        print("User role: ${user.role}");
        currentUser.value = user;
        isLoggedIn.value = true;
        await _saveUserToCache(user);
        print("User data fetched and cached: ${user.username}");
      } else {
        print("User document does not exist in Firestore for UID: $uid");
      }
    } catch (e) {
      print("Error fetching user data from Firestore: $e");
    }
  }

  Future<void> fetchAllUsers() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').get();
      allUsers.value =
          snapshot.docs.map((doc) {
            return UserModel.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();
    } catch (e) {
      print("Error fetching all users: $e");
      AppSnackbar.showError('Failed to load users list');
    }
  }

  Future<bool> registerUser({
    required String username,
    required String email,
    required String password,
    String role = 'user',
  }) async {
    try {
      isLoading.value = true;
      clearError();

      if (username.isEmpty || email.isEmpty || password.isEmpty) {
        errorMessage.value = 'All fields are required';
        return false;
      }

      // Create User in Firebase Auth
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Save User Data to Firestore
      UserModel newUser = UserModel(
        id: userCredential.user!.uid,
        username: username,
        email: email,
        password: '', // Don't save password in Firestore
        role: role,
        memberSince: DateTime.now().toString(),
      );

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(newUser.toMap());

      AppSnackbar.showSuccess('Registration successful!');
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        errorMessage.value =
            'No internet connection. Please check your network.';
      } else {
        errorMessage.value = e.message ?? 'Registration failed';
      }
      AppSnackbar.showError(errorMessage.value);
      return false;
    } catch (e) {
      errorMessage.value = 'An error occurred. Please try again.';
      AppSnackbar.showError(errorMessage.value);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> loginUser({
    required String usernameOrEmail,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      clearError();

      if (usernameOrEmail.isEmpty || password.isEmpty) {
        errorMessage.value = 'Email and password are required.';
        return false;
      }

      if (!GetUtils.isEmail(usernameOrEmail)) {
        errorMessage.value = 'Please enter a valid email.';
        return false;
      }

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: usernameOrEmail,
        password: password,
      );

      // Wait for user data to be fetched before returning
      if (userCredential.user != null) {
        await _fetchUserData(userCredential.user!.uid);
      }

      AppSnackbar.showSuccess('Login successful!');
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        errorMessage.value =
            'No internet connection. Please check your network.';
      } else {
        errorMessage.value = e.message ?? 'Login failed';
      }
      AppSnackbar.showError(errorMessage.value);
      return false;
    } catch (e) {
      errorMessage.value = 'An error occurred. Please try again.';
      AppSnackbar.showError(errorMessage.value);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async {
    try {
      await _auth.signOut();
      _clearUserData();
      Get.offAll(() => LoginScreen());
    } catch (e) {
      AppSnackbar.showError('Logout failed: $e');
    }
  }

  Future<bool> updateUserProfile(UserModel updatedUser) async {
    try {
      isLoading.value = true;
      if (updatedUser.id == null) return false;

      await _firestore
          .collection('users')
          .doc(updatedUser.id)
          .update(updatedUser.toMap());

      currentUser.value = updatedUser;
      await _saveUserToCache(updatedUser);
      AppSnackbar.showSuccess('Profile updated successfully!');
      return true;
    } catch (e) {
      print("Error updating profile: $e");
      AppSnackbar.showError('Failed to update profile');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadUser() async {
    if (_auth.currentUser != null) {
      await _fetchUserData(_auth.currentUser!.uid);
    }
  }

  /// Make a user an admin by their email (for debugging/setup)
  Future<bool> makeAdmin(String email) async {
    try {
      // Find user by email
      QuerySnapshot snapshot =
          await _firestore
              .collection('users')
              .where('email', isEqualTo: email)
              .get();

      if (snapshot.docs.isEmpty) {
        AppSnackbar.showError('User not found with email: $email');
        return false;
      }

      // Update role to admin
      await _firestore.collection('users').doc(snapshot.docs.first.id).update({
        'role': 'admin',
      });

      AppSnackbar.showSuccess('User $email is now an admin!');
      print('User $email has been made admin');

      // Refresh current user if it's the same user
      if (currentUser.value?.email == email) {
        await _fetchUserData(snapshot.docs.first.id);
      }

      return true;
    } catch (e) {
      print('Error making user admin: $e');
      AppSnackbar.showError('Failed to make user admin');
      return false;
    }
  }
}
