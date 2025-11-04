import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'core/bindings/initial_bindings.dart';
import 'core/routes/app_pages.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_service.dart';
import 'core/services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage
  await GetStorage.init();

  // Initialize core services early
  Get.put(ThemeService(), permanent: true);

  // Initialize Firebase (optional - will show error if not configured)
  try {
    final firebaseService = Get.put(FirebaseService());
    await firebaseService.initialize();
  } catch (e) {
    print('⚠️ Firebase not configured yet. Some features will be unavailable.');
    print('Please follow QUICK_START.md to set up Firebase.');
    // Continue without Firebase for now
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FamilyLink',
      debugShowCheckedModeBanner: false,

      // Theme Configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: Get.find<ThemeService>().theme,

      // Initial Bindings
      initialBinding: InitialBindings(),

      // Routing
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,

      // Default Transitions
      defaultTransition: Transition.cupertino,
      transitionDuration: Duration(milliseconds: 300),
    );
  }
}
