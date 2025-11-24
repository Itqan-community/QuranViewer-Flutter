import 'word.dart';
import 'ayah.dart';

const BASMALLAH = '\ufc41 \ufc42 \ufc43 \ufc44';

enum LineType { ayah, surahName, basmallah }

class Line {
  final int id;
  final int pageNumber;
  final LineType lineType;
  final int surahId;
  final List<Word> words;
  final bool hasSajda;
  final int? rubNumber;

  Line({
    required this.id,
    required this.pageNumber,
    required this.lineType,
    required this.surahId,
    required this.words,
    required this.hasSajda,
    required this.rubNumber,
  });

  factory Line.fromJson(
    int pageNumber,
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
      pageNumber: pageNumber,
    );
  }
}
