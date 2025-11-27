import 'package:flutter/material.dart';

import 'data/word.dart';
import 'data/ayah.dart';
import 'data/surah.dart';
import 'data/quran_page.dart';

class ViewerConfig {
  final String? focusedAyahId;
  final int initialPage;
  final Color pageBackgroundColor;
  final double pageInnerMargin;
  final double pageOuterMargin;
  final double headerFontSize;
  final double surahNameFontSize;
  final double basmallahFontSize;
  final double markerFontSize;
  final double wordFontSize;
  final double juzFontSize;
  final double surahHeaderFontSize;
  final Color wordHighlightColor;
  final Color wordFocusColor;
  final Duration pageAnimationDuration;
  final Curve pageAnimationCurve;

  ViewerConfig({
    this.focusedAyahId,
    this.initialPage = 1,
    this.pageBackgroundColor = const Color.fromRGBO(223, 208, 185, .5),
    this.pageInnerMargin = 5,
    this.pageOuterMargin = 50,
    this.headerFontSize = 38,
    this.surahNameFontSize = 30,
    this.basmallahFontSize = 30,
    this.markerFontSize = 40,
    this.wordFontSize = 30,
    this.juzFontSize = 20,
    this.surahHeaderFontSize = 25,
    this.wordHighlightColor = Colors.blue,
    this.wordFocusColor = Colors.blueGrey,
    this.pageAnimationDuration = const Duration(milliseconds: 400),
    this.pageAnimationCurve = Curves.easeInOut,
  });

  ViewerConfig copyWith({
    String? focusedAyahId,
    int? initialPage,
    Color? pageBackgroundColor,
    double? pageInnerMargin,
    double? pageOuterMargin,
    double? headerFontSize,
    double? surahNameFontSize,
    double? basmallahFontSize,
    double? markerFontSize,
    double? wordFontSize,
    double? juzFontSize,
    double? surahHeaderFontSize,
    Color? wordHighlightColor,
    Color? wordFocusColor,
    Duration? pageAnimationDuration,
    Curve? pageAnimationCurve,
  }) {
    return ViewerConfig(
      focusedAyahId: focusedAyahId ?? this.focusedAyahId,
      initialPage: initialPage ?? this.initialPage,
      pageBackgroundColor: pageBackgroundColor ?? this.pageBackgroundColor,
      pageInnerMargin: pageInnerMargin ?? this.pageInnerMargin,
      pageOuterMargin: pageOuterMargin ?? this.pageOuterMargin,
      headerFontSize: headerFontSize ?? this.headerFontSize,
      surahNameFontSize: surahNameFontSize ?? this.surahNameFontSize,
      basmallahFontSize: basmallahFontSize ?? this.basmallahFontSize,
      markerFontSize: markerFontSize ?? this.markerFontSize,
      wordFontSize: wordFontSize ?? this.wordFontSize,
      juzFontSize: juzFontSize ?? this.juzFontSize,
      surahHeaderFontSize: surahHeaderFontSize ?? this.surahHeaderFontSize,
      wordHighlightColor: wordHighlightColor ?? this.wordHighlightColor,
      wordFocusColor: wordFocusColor ?? this.wordFocusColor,
      pageAnimationDuration:
          pageAnimationDuration ?? this.pageAnimationDuration,
      pageAnimationCurve: pageAnimationCurve ?? this.pageAnimationCurve,
    );
  }
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
    value = value.copyWith(focusedAyahId: ayahId);
    notifyListeners();
  }

  void removeAyahFocus() {
    value = ViewerConfig(
      focusedAyahId: null,
      initialPage: value.initialPage,
      pageBackgroundColor: value.pageBackgroundColor,
      pageInnerMargin: value.pageInnerMargin,
      pageOuterMargin: value.pageOuterMargin,
      headerFontSize: value.headerFontSize,
      surahNameFontSize: value.surahNameFontSize,
      basmallahFontSize: value.basmallahFontSize,
      markerFontSize: value.markerFontSize,
      wordFontSize: value.wordFontSize,
      juzFontSize: value.juzFontSize,
      surahHeaderFontSize: value.surahHeaderFontSize,
      wordHighlightColor: value.wordHighlightColor,
      wordFocusColor: value.wordFocusColor,
      pageAnimationDuration: value.pageAnimationDuration,
      pageAnimationCurve: value.pageAnimationCurve,
    );
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
