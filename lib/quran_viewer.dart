import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:quran_viewer/src/controller.dart';
import 'dart:async';

import 'src/data/line.dart';

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
                  ayahs: ayahs,
                  surahs: d['surahs']!
                      .map<Surah>((e) => Surah.fromJson(e))
                      .toList(),
                  pages: d['pages']!
                      .map<QuranPage>(
                        (e) => QuranPage.fromJson(e, words, ayahs),
                      )
                      .toList(),
                );
              }
            },
      ),
    );
  }
}

class Book extends StatefulWidget {
  const Book({
    super.key,
    required this.ayahs,
    required this.surahs,
    required this.pages,
    this.viewerController,
  });

  final Map<String, Ayah> ayahs;
  final List<Surah> surahs;
  final List<QuranPage> pages;
  final ViewerController? viewerController;

  @override
  State<Book> createState() => _BookState();
}

class _BookState extends State<Book> {
  final pageList = <Widget>[];
  final pageController = PageController(initialPage: 527);
  late final ViewerController viewerController =
      widget.viewerController ?? ViewerController(ViewerConfig());

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    for (var page in widget.pages) {
      pageList.add(
        PageWidget(
          key: Key('page${page.id}'),
          viewerController: viewerController,
          pageNumber: page.id,
          lines: page.lines,
          juzId: page.juzId,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pageController.animateToPage(
            Random().nextInt(pageList.length),
            duration: Duration(milliseconds: 120),
            curve: Curves.fastLinearToSlowEaseIn,
          );
        },
      ),

      body: GestureDetector(
        onTap: () {
          viewerController.removeAyahFocus();
          // pageController.nextPage(
          //   duration: Duration(milliseconds: 400),
          //   curve: Curves.easeInOut,
          // );
        },
        child: PageView.builder(
          controller: pageController,
          clipBehavior: Clip.none,
          pageSnapping: true,
          padEnds: true,
          itemCount: pageList.length,
          scrollDirection: Axis.horizontal,
          scrollBehavior: ScrollConfiguration.of(context).copyWith(
            scrollbars: false,
            dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
          ),
          physics: const PageScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return pageList[index];
          },
          // children: pageList,
        ),
      ),
    );
  }
}

class PageWidget extends StatelessWidget {
  const PageWidget({
    super.key,
    required this.pageNumber,
    required this.lines,
    required this.viewerController,
    required this.juzId,
    this.marginWidgetBuilder,
  });

  final int pageNumber;
  final List<Line> lines;
  final ViewerController viewerController;
  final int juzId;
  final Widget Function(Line line)? marginWidgetBuilder;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(223, 208, 185, .5),
      padding: EdgeInsets.only(
        right: (pageNumber % 2 == 0) ? 5 : 50,
        left: (pageNumber % 2 == 0) ? 50 : 5,
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              if (pageNumber > 2)
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'juz${juzId.toString().padLeft(3, "0")}',
                      style: TextStyle(fontFamily: 'Juz', fontSize: 20),
                    ),
                    Text(
                      'surah${lines.first.surahId.toString().padLeft(3, "0")}',
                      style: TextStyle(
                        fontFamily: 'QPC v2 surah name',
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),

              Column(
                // shrinkWrap: true,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...lines
                    .map(
                      (line) => LineWidget(
                        viewerController: viewerController,
                        pageNumber: pageNumber,
                        line: line,
                      ),
                    )
                    ],
              ),

              const Divider(),
              Text('$pageNumber'),
            ],
          ),
        ),
      ),
    );
  }
}

class LineWidget extends StatelessWidget {
  const LineWidget({
    super.key,
    required this.line,
    required this.pageNumber,
    required this.viewerController,
  });

  final Line line;
  final int pageNumber;
  final ViewerController viewerController;

  @override
  Widget build(BuildContext context) {
    if (line.lineType == LineType.surahName) {
      return Stack(
        alignment: AlignmentGeometry.center,
        fit: StackFit.passthrough,
        children: [
          Text('header', style: TextStyle(fontFamily: 'Juz', fontSize: 38)),
          Text(
            'surah${line.surahId.toString().padLeft(3, "0")}',
            style: TextStyle(fontFamily: 'QPC v2 surah name', fontSize: 30),
          ),
        ],
      );
    }
    if (line.lineType == LineType.basmallah) {
      return Text('﷽', style: TextStyle(fontFamily: 'Juz', fontSize: 30));
      //   return WordWidget(
      //     viewerController: viewerController,
      //     onTap: () {
      //       print(line.surah);
      //     },
      //     word: Word(
      //       id: '${line.surah}:0:basmallah',
      //       ayahId: '${line.surah}:0',
      //       glyph: BASMALLAH,
      //       isAyahEnd: false,
      //     ),
      //     style: TextStyle(fontFamily: 'QPC v2 p1', fontSize: 30),
      //   );
    }

    final marginWidget = Text(
            'marker-half',
            style: TextStyle(fontFamily: 'Juz', fontSize: 40),
          );
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (pageNumber %2 !=0 && line.hasSajda)
          marginWidget,
        Spacer(),
        ...line.words.map(
          (word) => WordWidget(
            viewerController: viewerController,
            onTap: () {
              // move focus to the previous word
              print(word);
            },
            word: word,
            style: TextStyle(
              fontFamily: (line.lineType == LineType.basmallah)
                  ? 'QPC v2 p1'
                  : 'QPC v2 p$pageNumber',
              fontSize: 30,
            ),
          ),
        ),
        Spacer(),
        if (pageNumber %2 ==0 && line.hasSajda)
          marginWidget,
      ],
    );
  }
}

class WordWidget extends StatelessWidget {
  const WordWidget({
    super.key,
    required this.word,
    required this.style,
    required this.onTap,
    required this.viewerController,
  });

  final Word word;
  final TextStyle style;
  final Function() onTap;
  final ViewerController viewerController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewerController,
      builder: (BuildContext context, Widget? child) => Container(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        color: viewerController.value.focusedAyahId == word.ayahId
            ? Colors.blueGrey
            : Colors.transparent,
        child: InkWell(
          key: Key('word${word.globalId}'),
          highlightColor: Colors.blue,
          onTap: () {
            viewerController.focusOnAyah(word.ayahId);
            onTap();
          },
          child: Text(word.glyph, style: style),
        ),
      ),
    );
  }
}
