import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quran_viewer/src/controller.dart';
import 'package:quran_viewer/src/widgets/page_widget.dart';
import 'package:quran_viewer/src/data/line.dart';

import 'helpers/data_mocks.dart';
import 'helpers/font_loader.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  testWidgets('PageWidget golden test', (WidgetTester tester) async {
    // Create mock data for a page (e.g., Page 1 - Al-Fatiha)
    final words = [
      DataMocks.createWord(globalId: 1, glyph: 'ﱁ', text: 'بِسْمِ'),
      DataMocks.createWord(globalId: 2, glyph: 'ﱂ', text: 'ٱللَّهِ'),
      DataMocks.createWord(globalId: 3, glyph: 'ﱃ', text: 'ٱلرَّحْمَـٰنِ'),
      DataMocks.createWord(globalId: 4, glyph: 'ﱄ', text: 'ٱلرَّحِيمِ'),
    ];

    final line = DataMocks.createLine(
      id: 1,
      pageNumber: 1,
      lineType: LineType.basmallah,
      words: words,
    );

    final page = DataMocks.createPage(id: 1, juzId: 1, lines: [line]);

    final viewerController = ViewerController(
      ViewerConfig(),
      pageController: PageController(),
      words: words,
      ayahs: {},
      surahs: [],
      pages: [page],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PageWidget(
            pageNumber: 1,
            lines: [line],
            viewerController: viewerController,
            juzId: 1,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await expectLater(
      find.byType(PageWidget),
      matchesGoldenFile('goldens/page_widget_p1.png'),
    );
  });
}
