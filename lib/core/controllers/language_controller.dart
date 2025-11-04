import 'dart:ui';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  final GetStorage _storage = GetStorage();
  final RxString _currentLanguage = 'en'.obs;

  String get currentLanguage => _currentLanguage.value;
  bool get isArabic => _currentLanguage.value == 'ar';
  bool get isEnglish => _currentLanguage.value == 'en';

  @override
  void onInit() {
    super.onInit();
    _loadLanguage();
  }

  void _loadLanguage() {
    final String? savedLanguage = _storage.read('language');
    if (savedLanguage != null) {
      _currentLanguage.value = savedLanguage;
      Get.updateLocale(Locale(savedLanguage));
    } else {
      // Auto-detect system language
      final systemLocale = Get.deviceLocale?.languageCode ?? 'en';
      final language = ['ar', 'en'].contains(systemLocale)
          ? systemLocale
          : 'en';
      _currentLanguage.value = language;
      Get.updateLocale(Locale(language));
    }
  }

  void changeLanguage(String languageCode) {
    _currentLanguage.value = languageCode;
    _storage.write('language', languageCode);
    Get.updateLocale(Locale(languageCode));

    Get.snackbar(
      'language_changed'.tr,
      'language_changed_to'.trParams({
        'lang': languageCode == 'ar' ? 'العربية' : 'English',
      }),
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
    );
  }

  void toggleLanguage() {
    final newLanguage = _currentLanguage.value == 'en' ? 'ar' : 'en';
    changeLanguage(newLanguage);
  }
}
