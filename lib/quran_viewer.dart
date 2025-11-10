import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';

import 'src/data/line.dart';

Future<dynamic> loadJsonData() async {
  final String response = await rootBundle.loadString(
    'packages/quran_viewer/lib/assets/lines3.json',
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
  const Book({super.key, required this.data});

  final data;

  @override
  State<Book> createState() => _BookState();
}

class _BookState extends State<Book> {
  final focusNode = FocusNode();
  final pageList = <Widget>[];
  final carouselController = CarouselController(initialItem: 0);

  @override
  void dispose() {
    carouselController.dispose();
    focusNode.dispose();
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
        pageNumber: pageNumber,
        lines: lines,
        focusNode: focusNode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CarouselView.weighted(
        enableSplash: false,
        shape: Border(),
        onTap: (index) {
          final turnCount = MediaQuery.of(context).size.width > 1100 ? 2 : 1;
          carouselController.animateToItem(index + turnCount);
        },
        itemSnapping: true,
        controller: carouselController,
        flexWeights: MediaQuery.of(context).size.width > 1100 ? [1, 1] : [1],
        scrollDirection: Axis.horizontal,
        children: pageList,
      ),
    );
  }
}

class PageWidget extends StatelessWidget {
  const PageWidget({
    super.key,
    required this.pageNumber,
    required this.lines,
    required this.focusNode,
  });

  final int pageNumber;
  final List<Line> lines;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(223, 208, 185, .5),
      padding: EdgeInsets.only(
        right: (pageNumber % 2 == 0) ? 0 : 50,
        left: (pageNumber % 2 == 0) ? 50 : 0,
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
                    (line) => Center(
                      child: LineWidget(focusNode: focusNode, line: line),
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
  const LineWidget({super.key, required this.focusNode, required this.line});

  final Line line;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: (line.texts == null)
            ? [Container()]
            : line.texts!
                  .split(' ')
                  .map(
                    (word) => WordWidget(
                      focusNode: focusNode,
                      onTap: () {
                        focusNode.requestFocus();
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
      ),
    );
  }
}

class WordWidget extends StatelessWidget {
  const WordWidget({
    super.key,
    required this.word,
    required this.style,
    required this.focusNode,
    required this.onTap,
  });

  final String word;
  final TextStyle style;
  final FocusNode focusNode;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.green,
      highlightColor: Colors.blue,
      focusNode: focusNode,
      onTap: onTap,
      child: Text(word, style: style),
    );
  }
}
