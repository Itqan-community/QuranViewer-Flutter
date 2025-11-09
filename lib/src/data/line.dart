class Line {
  final int pageNumber;
  final int lineNumber;
  final String lineType;
  final bool isCentered;
  final int? surah;
  final int? ayah;
  final String? words;
  final String? texts;

  Line({
    required this.pageNumber,
    required this.lineNumber,
    required this.lineType,
    required this.isCentered,
    required this.surah,
    required this.ayah,
    required this.words,
    required this.texts,
  });

  factory Line.fromJson(Map<String, dynamic> json) {
    return Line(
      pageNumber: json['page_number'],
      lineNumber: json['line_number'],
      lineType: json['line_type'],
      isCentered: json['is_centered'] == 1,
      surah: json['surah'],
      ayah: json['ayah'],
      words: json['words'],
      texts: json['texts'],
    );
  }
}