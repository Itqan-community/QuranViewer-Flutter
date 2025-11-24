import 'line.dart';
import 'word.dart';
import 'ayah.dart';

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
        .map((line) => Line.fromJson(json['id'], line, words, ayahs))
        .toList();
    return QuranPage(id: json['id'], lines: lines, juzId: json['juz']);
  }

  bool contains(String ayahId) {
    for (var line in lines) {
      for (var word in line.words) {
        if (word.ayahId == ayahId) {
          return true;
        }
      }
    }
    return false;
  }
}
