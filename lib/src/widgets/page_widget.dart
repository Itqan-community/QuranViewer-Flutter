import 'package:flutter/material.dart';
import '../data/line.dart';
import '../controller.dart';
import 'line_widget.dart';

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
                  ...lines.map(
                    (line) => LineWidget(
                      viewerController: viewerController,
                      pageNumber: pageNumber,
                      line: line,
                    ),
                  ),
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
