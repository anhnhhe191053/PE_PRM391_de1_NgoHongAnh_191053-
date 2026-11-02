import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/theme_local_storage.dart';

class ThemeViewModel extends StateNotifier<Color> {
  // Màu mặc định ban đầu
  ThemeViewModel() : super(const Color(0xFF263238)) {
    loadColor();
  }

  Future<void> loadColor() async {
    final savedColor = await ThemeLocalStorage.getSavedColor();
    if (savedColor != null) {
      state = savedColor;
    }
  }

  Future<void> changeColor(Color newColor) async {
    state = newColor;
    await ThemeLocalStorage.saveColor(newColor);
  }
}

final themeViewModelProvider =
StateNotifierProvider<ThemeViewModel, Color>((ref) {
  return ThemeViewModel();
});