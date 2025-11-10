class Word {
  final String id;
  final String glyph;
  final bool isAyahEnd;
  final String ayahId;

  Word({
    required this.id,
    required this.glyph,
    required this.ayahId,
    required this.isAyahEnd,
  });
  @override
  String toString() {
    return 'Word{id: $id, glyph: $glyph, ayahId: $ayahId, isAyahEnd: $isAyahEnd}';
  }
}

class Line {
  final int pageNumber;
  final int lineNumber;
  final String lineType;
  final bool isCentered;
  final int? surah;
  final List<Word> words;

  Line({
    required this.pageNumber,
    required this.lineNumber,
    required this.lineType,
    required this.isCentered,
    required this.surah,
    required this.words,
  });

  factory Line.fromJson(Map<String, dynamic> json) {
    final wordIds = (json['words'] == null) ? [] : json['words'].split(' ');
    final List<String> texts = (json['words'] == null)
        ? []
        : json['texts'].split(' ');
    final List<String> ayahs =  (json['words'] == null)
        ? []
        : json['ayahs'].split(' ');
    final List<Word> words = [];
    var lastWordNumber = 0;
    for (var i = 0; i < wordIds.length; i++) {
      final w = wordIds[i];
      // when word number reset then previous word is ayah end
      words.add(
        Word(
          id: '${json['surah']}:${ayahs[i]}:$w',
          ayahId: '${json['surah']}:${ayahs[i]}',
          glyph: texts[i],
          isAyahEnd: lastWordNumber != 0 && int.parse(w) < lastWordNumber,
        ),
      );
      lastWordNumber = int.parse(w);
    }
    return Line(
      pageNumber: json['page_number'],
      lineNumber: json['line_number'],
      lineType: json['line_type'],
      isCentered: json['is_centered'] == 1,
      surah: json['surah'],
      words: words,
    );
  }
}
