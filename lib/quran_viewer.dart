import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'src/data/line.dart';

Future<dynamic> loadJsonData() async {
  final String response = await rootBundle.loadString(
    'packages/quran_viewer/lib/assets/lines3.json',
  );
  final dynamic data = json.decode(response);
  return data;
}



class QuranViewer extends StatefulWidget {
  const QuranViewer({super.key});

  static const routeName = '/quran';

  @override
  State<QuranViewer> createState() => _QuranViewerState();
}

class _QuranViewerState extends State<QuranViewer> {
  var pageNumber = 1;
  final focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Text('next'),
          onPressed: () => setState(() {
            pageNumber += 1;
          }),
        ),
        body: FutureBuilder(
          future: loadJsonData(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              var text = snapshot.data[pageNumber.toString()] as List;
              var lines = text
                  .map((line) => Line.fromJson(line as Map<String, dynamic>))
                  .toList();
              return PageWidget(pageNumber: pageNumber, lines: lines, focusNode: focusNode);
            }
          },
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
        right: (pageNumber % 2 == 0) ? 10 : 100,
        left: (pageNumber % 2 == 0) ? 100 : 10,
      ),
      child: ListView(
        children: lines
            .map(
              (line) => Center(
                child: LineWidget(focusNode: focusNode, line: line),
              ),
            )
            .toList(),
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
