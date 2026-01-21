import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myprojectshop/controller/category_controller.dart';
import 'package:myprojectshop/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/controller/product_controller.dart';
import 'package:myprojectshop/controller/auth_controller.dart';
import 'package:myprojectshop/controller/cart_controller.dart';
import 'package:myprojectshop/controller/order_controller.dart';
import 'package:myprojectshop/controller/order_item_controller.dart';
import 'package:myprojectshop/controller/address_controller.dart';
import 'package:myprojectshop/controller/theme_controller.dart';
import 'package:myprojectshop/controller/wishlist_controller.dart';
import 'package:myprojectshop/controller/notification_controller.dart';
import 'package:myprojectshop/controller/chat_controller.dart';
import 'package:myprojectshop/controller/language_controller.dart';
import 'package:myprojectshop/controller/network_controller.dart';
import 'package:myprojectshop/screens/SplashScreen.dart';
import 'package:myprojectshop/theme/theme.dart';
import 'package:myprojectshop/core/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  // Initialize Controllers
  Get.put(AppConfig());
  Get.put(AuthController());
  Get.put(ProductController());
  Get.put(CategoryController());
  Get.put(CartController());
  Get.put(OrderController());
  Get.put(OrderItemController());
  Get.put(AddressController());
  Get.put(ThemeController());
  Get.put(WishlistController());
  Get.put(NotificationController());
  Get.put(ChatController());
  Get.put(LanguageController());
  Get.put(NetworkController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();

    return Obx(
      () => GetMaterialApp(
        title: "ShopEase",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,

        // Official Flutter Localization
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('ar')],
        locale: languageController.currentLocale.value,

        home: SplashScreen(),
      ),
    );
  }
}
