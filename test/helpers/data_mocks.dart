import 'package:quran_viewer/src/data/word.dart';
import 'package:quran_viewer/src/data/line.dart';
import 'package:quran_viewer/src/data/quran_page.dart';
import 'package:quran_viewer/src/data/ayah.dart';
import 'package:quran_viewer/src/data/surah.dart';

class DataMocks {
  static Word createWord({
    int globalId = 1,
    String glyph = 'ﱁ',
    String ayahId = '1:1',
    String text = 'بِسْمِ',
    bool isAyahEnd = false,
  }) {
    return Word(
      globalId: globalId,
      glyph: glyph,
      ayahId: ayahId,
      text: text,
      isAyahEnd: isAyahEnd,
    );
  }

  static Line createLine({
    int id = 1,
    int pageNumber = 1,
    LineType lineType = LineType.basmallah,
    int surahId = 1,
    List<Word>? words,
    bool hasSajda = false,
    int? rubNumber,
  }) {
    return Line(
      id: id,
      pageNumber: pageNumber,
      lineType: lineType,
      surahId: surahId,
      words: words ?? [createWord()],
      hasSajda: hasSajda,
      rubNumber: rubNumber,
    );
  }

  static QuranPage createPage({int id = 1, int juzId = 1, List<Line>? lines}) {
    return QuranPage(
      id: id,
      juzId: juzId,
      lines: lines ?? [createLine(pageNumber: id)],
    );
  }

  static Ayah createAyah({
    int id = 1,
    int surahId = 1,
    List<int> wordIds = const [1],
    bool hasSajda = false,
    int? rubNumber,
  }) {
    return Ayah(
      id: id,
      surahId: surahId,
      wordIds: wordIds,
      hasSajda: hasSajda,
      rubNumber: rubNumber,
    );
  }

  static Surah createSurah({int id = 1, List<int> ayahIds = const [1]}) {
    return Surah(id: id, ayahIds: ayahIds);
  }
}
