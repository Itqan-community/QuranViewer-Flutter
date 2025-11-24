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
      isAyahEnd: json['is_ayah_end'],
    );
  }
}
