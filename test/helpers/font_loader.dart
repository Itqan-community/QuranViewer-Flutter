import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> loadFonts() async {
  final fontLoader = FontLoader('Juz');
  fontLoader.addFont(loadFontFile('lib/fonts/juz.ttf'));
  await fontLoader.load();

  final surahFontLoader = FontLoader('QPC v2 surah name');
  surahFontLoader.addFont(loadFontFile('lib/fonts/qpc_v2/surah-name.ttf'));
  await surahFontLoader.load();

  // Load a few page fonts for testing
  for (var i = 1; i <= 5; i++) {
    final pageFontLoader = FontLoader('QPC v2 p$i');
    pageFontLoader.addFont(loadFontFile('lib/fonts/qpc_v2/p$i.ttf'));
    await pageFontLoader.load();
  }
}

// Helper to load font from file system if rootBundle fails in test environment
// (Sometimes needed depending on test setup, but let's try rootBundle first)
Future<ByteData> loadFontFile(String path) async {
  final file = File(path);
  final bytes = await file.readAsBytes();
  return ByteData.view(bytes.buffer);
}
