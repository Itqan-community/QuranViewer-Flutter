import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'src/data/word.dart';
import 'src/data/ayah.dart';
import 'src/data/surah.dart';
import 'src/data/quran_page.dart';
import 'src/widgets/book_widget.dart';

Future<Map<String, dynamic>> loadQuranData() async {
  final String response = await rootBundle.loadString(
    'packages/quran_viewer/lib/assets/quran_data.json',
  );
  final data = jsonDecode(response) as Map<String, dynamic>;
  return data;
}

class QuranViewer extends StatelessWidget {
  const QuranViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: FutureBuilder(
        future: loadQuranData(),
        builder:
            (
              BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data == null) {
                return Text('Error: ${snapshot.error}');
              } else {
                var d = snapshot.data!;
                var words = d['words']!
                    .map<Word>((e) => Word.fromJson(e))
                    .toList();
                final ayahs = {
                  for (var a in d['ayahs'])
                    '${a["surah_id"]}:${a["id"]}': Ayah.fromJson(a),
                };
                return Book(
                  words: words,
                  ayahs: ayahs,
                  surahs: d['surahs']!
                      .map<Surah>((surah) => Surah.fromJson(surah))
                      .toList(),
                  pages: d['pages']!
                      .map<QuranPage>(
                        (page) => QuranPage.fromJson(page, words, ayahs),
                      )
                      .toList(),
                );
              }
            },
      ),
    );
  }
}
