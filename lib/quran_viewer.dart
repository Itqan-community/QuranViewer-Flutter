import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:quran_viewer/src/controller.dart';
import 'dart:async';

import 'src/data/line.dart';

Future<dynamic> loadJsonData() async {
  final String response = await rootBundle.loadString(
    'packages/quran_viewer/lib/assets/lines4.json',
  );
  final dynamic data = json.decode(response);
  return data;
}

class QuranViewer extends StatelessWidget {
  const QuranViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: FutureBuilder(
        future: loadJsonData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Book(data: snapshot.data);
          }
        },
      ),
    );
  }
}

class Book extends StatefulWidget {
  const Book({super.key, required this.data, this.viewerController});

  final data;
  final ViewerController? viewerController;

  @override
  State<Book> createState() => _BookState();
}

class _BookState extends State<Book> {
  final pageList = <Widget>[];
  final pageController = PageController(initialPage: 0);
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
    var pages = widget.data as Map<String, dynamic>;
    for (var page in pages.values) {
      _addPage(page as List);
      if (pageList.length >= 50) break;
    }
  }

  _addPage(linesJson) {
    linesJson as List<dynamic>;
    final lines = linesJson.map((line) => Line.fromJson(line)).toList();
    final pageNumber = lines.first.pageNumber;
    pageList.add(
      PageWidget(
        key: Key('page$pageNumber'),
        viewerController: viewerController,
        pageNumber: pageNumber,
        lines: lines,
      ),
    );
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
  });

  final int pageNumber;
  final List<Line> lines;
  final ViewerController viewerController;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(223, 208, 185, .5),
      padding: EdgeInsets.only(
        right: (pageNumber % 2 == 0) ? 5 : 50,
        left: (pageNumber % 2 == 0) ? 50 : 5,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            clipBehavior: Clip.none,
            fit: BoxFit.none,
            child: Column(
              // shrinkWrap: true,
              mainAxisAlignment: MainAxisAlignment.center,
              children: lines
                  .map(
                    (line) => LineWidget(
                      viewerController: viewerController,
                      line: line,
                    ),
                  )
                  .toList(),
            ),
          ),
          Text('$pageNumber'),
        ],
      ),
    );
  }
}

class LineWidget extends StatelessWidget {
  const LineWidget({
    super.key,
    required this.line,
    required this.viewerController,
  });

  final Line line;
  final ViewerController viewerController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: line.words
          .map(
            (word) => WordWidget(
              viewerController: viewerController,
              onTap: () {
                // move focus to the previous word
                print(word);
              },
              word: word,
              style: TextStyle(
                fontFamily: 'QPC v2 p${line.pageNumber}',
                fontSize: 30,
              ),
            ),
          )
          .toList(),
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
          key: Key('word${word.id}'),
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
