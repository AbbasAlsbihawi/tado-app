import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  _loadSaveFromBox(bool isDarkMode) {
    _box.write(_key, isDarkMode);
  }

  bool _loadThemeFromBox() => _box.read<bool>(_key) ?? true;

  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  switchModeTheme() {
    Get.changeThemeMode(
        !_loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light);
    _loadSaveFromBox(!_loadThemeFromBox());
  }
}
