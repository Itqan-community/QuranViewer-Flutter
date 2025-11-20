import 'package:flutter/material.dart';

import 'data/line.dart';

class ViewerConfig {
  final String? focusedAyahId;
  ViewerConfig({this.focusedAyahId});
}
class ViewerController extends ValueNotifier<ViewerConfig> {
  ViewerController(super.value, {required this.pageController,
    required this.words,
    required this.ayahs,
    required this.surahs,
    required this.pages,
  });
  final PageController pageController;
  final List<Word> words;
  final Map<String, Ayah> ayahs;
  final List<Surah> surahs;
  final List<QuranPage> pages;

  void focusOnAyah(String ayahId) {
    value = ViewerConfig(focusedAyahId: ayahId);
    notifyListeners();
  }
  void removeAyahFocus() {
    value = ViewerConfig(focusedAyahId: null);
    notifyListeners();
  }

}