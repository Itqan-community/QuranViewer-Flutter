const BASMALLAH = '\ufc41 \ufc42 \ufc43 \ufc44';

enum LineType { ayah, surahName, basmallah }

class Word {
  final int globalId;
  final String glyph;
  final bool isAyahEnd;
  final String ayahId;
  final String text;

  Word({
    required this.globalId,
    required this.glyph,
    required this.ayahId,
    required this.isAyahEnd,
    required this.text,
  });

  @override
  String toString() {
    return 'Word{globalId: $globalId, text: $text, glyph: $glyph, ayahId: $ayahId, isAyahEnd: $isAyahEnd}';
  }

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      globalId: json['global_id'],
      glyph: json['glyph'],
      ayahId: json['ayah_id'],
      text: json['text'],
      isAyahEnd: json['is_ayah_end'] == 1,
    );
  }
}

// '2:23'
class Ayah {
  final int id;
  final int surahId;
  final List<int> wordIds;
  final bool hasSajda;
  final int? rubNumber;

  Ayah({
    required this.id,
    required this.surahId,
    required this.wordIds,
    required this.rubNumber,
    this.hasSajda = false,
  });

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      id: json['id'],
      surahId: json['surah_id'],
      wordIds: json['word_ids'].cast<int>(),
      hasSajda: json['has_sajda'],
      rubNumber: json['rub_number'],
    );
  }

  factory Ayah.fromStr(
    String ayahIdStr, {
    bool hasSajda = false,
    List<int> wordIds = const [],
  }) {
    final parts = ayahIdStr.split(':');
    final surahId = int.parse(parts[0]);
    final ayahAndWords = parts[1].split('-');
    final ayahId = int.parse(ayahAndWords[0]);
    final wordIds = ayahAndWords.length > 1
        ? ayahAndWords.sublist(1).map((e) => int.parse(e)).toList()
        : <int>[];
    return Ayah(
      id: ayahId,
      surahId: surahId,
      wordIds: wordIds,
      hasSajda: hasSajda,
      rubNumber: null,
    );
  }

  @override
  String toString() {
    return '$surahId:$id';
  }

  operator <(Ayah other) {
    return surahId < other.surahId ||
        (surahId == other.surahId && id < other.id);
  }

  operator <=(Ayah other) {
    return other.surahId > surahId ||
        (surahId == other.surahId && other.id >= id);
  }

  operator >(Ayah other) {
    return surahId > other.surahId ||
        (surahId == other.surahId && id > other.id);
  }

  operator >=(Ayah other) {
    return surahId > other.surahId ||
        (surahId == other.surahId && id >= other.id);
  }
}

class Surah {
  final int id;
  final List<int> ayahIds;

  Surah({required this.id, required this.ayahIds});

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(id: json['id'], ayahIds: json['ayah_ids'].cast<int>());
  }
}

class Line {
  final int id;

  // final int pageNumber;
  final LineType lineType;
  final int surahId;
  final List<Word> words;
  final bool hasSajda;
  final int? rubNumber;

  Line({
    // required this.pageNumber,
    required this.id,
    required this.lineType,
    required this.surahId,
    required this.words,
    required this.hasSajda,
    required this.rubNumber,
  });

  factory Line.fromJson(
    Map<String, dynamic> json,
    List<Word> words,
    Map<String, Ayah> ayahs,
  ) {
    var words2 = json['word_ids']
        .map<Word>((wordId) => words[wordId - 1])
        .toList();
    var hasSajda = false;
    int? rubNumber;
    for (var word in words2) {
      final ayah = ayahs['${word.ayahId}'];

      if (ayah != null && ayah.hasSajda) {
        hasSajda = true;
      }
      if (ayah != null &&
          ayah.rubNumber != null &&
          ayah.wordIds.last == word.globalId - 1) {
        if(word.globalId > 375 && word.globalId < 411) {
          // print('word: ${word.globalId} ${word.text} ${word.ayahId} ${ayah?.rubNumber??""}');
          print('${((ayah.rubNumber!-1)%4 )} ');
        }
        rubNumber = ayah.rubNumber;
      }
    }
    return Line(
      id: json['id'],
      lineType: json['line_type'] == 'ayah'
          ? LineType.ayah
          : (json['line_type'] == 'surah_name'
                ? LineType.surahName
                : LineType.basmallah),
      surahId: json['surah_id'],
      words: words2,
      hasSajda: hasSajda,
      rubNumber: rubNumber,
    );
  }
}

class Juz {
  final int juzNumber;
  final String firstAyah;
  final String lastAyah;

  Juz({
    required this.juzNumber,
    required this.firstAyah,
    required this.lastAyah,
  });

  factory Juz.fromJson(Map<String, dynamic> json) {
    return Juz(
      juzNumber: json['juz_number'],
      firstAyah: json['first_verse_key'],
      lastAyah: json['last_verse_key'],
    );
  }

  bool contains(Ayah ayahId) {
    return Ayah.fromStr(firstAyah) <= ayahId &&
        ayahId <= Ayah.fromStr(lastAyah);
  }
}

class QuranPage {
  final int id;
  final List<Line> lines;
  final int juzId;

  QuranPage({required this.id, required this.lines, required this.juzId});

  factory QuranPage.fromJson(
    Map<String, dynamic> json,
    List<Word> words,
    Map<String, Ayah> ayahs,
  ) {
    final linesJson = json['lines'] as List<dynamic>;

    final lines = linesJson
        .map((line) => Line.fromJson(line, words, ayahs))
        .toList();
    return QuranPage(id: json['id'], lines: lines, juzId: json['juz']);
  }
}
