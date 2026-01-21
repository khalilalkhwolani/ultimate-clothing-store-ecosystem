import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  static const String _languageKey = 'selected_language';

  final Rx<Locale> currentLocale = const Locale('en').obs;
  final RxBool isArabic = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(_languageKey) ?? 'en';
      await changeLanguage(savedLanguage);
    } catch (e) {
      print('Error loading saved language: $e');
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);

      currentLocale.value = Locale(languageCode);
      isArabic.value = languageCode == 'ar';
      Get.updateLocale(currentLocale.value);
    } catch (e) {
      print('Error changing language: $e');
    }
  }

  void toggleLanguage() {
    if (isArabic.value) {
      changeLanguage('en');
    } else {
      changeLanguage('ar');
    }
  }

  String get currentLanguageName => isArabic.value ? 'العربية' : 'English';
}
