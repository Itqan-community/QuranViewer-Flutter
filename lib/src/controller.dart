import 'package:flutter/material.dart';

import 'data/word.dart';
import 'data/ayah.dart';
import 'data/surah.dart';
import 'data/quran_page.dart';

class ViewerConfig {
  final String? focusedAyahId;
  ViewerConfig({this.focusedAyahId});
}

class ViewerController extends ValueNotifier<ViewerConfig> {
  ViewerController(
    super.value, {
    required this.pageController,
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

  void jumpToJuz(int juzId) {
    final page = pages.firstWhere((p) => p.juzId == juzId);
    pageController.jumpToPage(page.id - 1);
  }

  void jumpToRub() {}
  void jumpToRuku() {}

  void jumpToSurah(int surahId) {
    final surah = surahs.firstWhere((s) => s.id == surahId);
    final ayahId = surah.ayahIds.first.toString();
    final page = pages.firstWhere((p) => p.contains(ayahId));
    pageController.jumpToPage(page.id - 1);
    focusOnAyah(ayahId);
  }

  void jumpToAyah(String ayahId) {
    final page = pages.firstWhere((p) => p.contains(ayahId));
    pageController.jumpToPage(page.id - 1);
    focusOnAyah(ayahId);
  }
}
