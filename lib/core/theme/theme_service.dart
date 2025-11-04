import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService extends GetxController {
  final _storage = GetStorage();
  final _key = 'isDarkMode';

  ThemeMode get theme =>
      _loadThemeFromStorage() ? ThemeMode.dark : ThemeMode.light;
  bool get isDarkMode => _loadThemeFromStorage();

  bool _loadThemeFromStorage() => _storage.read(_key) ?? false;

  void switchTheme() {
    Get.changeThemeMode(
      _loadThemeFromStorage() ? ThemeMode.light : ThemeMode.dark,
    );
    _storage.write(_key, !_loadThemeFromStorage());
    update();
  }

  void saveTheme(bool isDarkMode) {
    _storage.write(_key, isDarkMode);
    update();
  }
}
