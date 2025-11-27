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
    return ListenableBuilder(
      listenable: viewerController,
      builder: (context, child) {
        final config = viewerController.value;
        return Container(
          color: config.pageBackgroundColor,
          padding: EdgeInsets.only(
            right: (pageNumber % 2 == 0)
                ? config.pageInnerMargin
                : config.pageOuterMargin,
            left: (pageNumber % 2 == 0)
                ? config.pageOuterMargin
                : config.pageInnerMargin,
          ),
          child: child,
        );
      },
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
                      style: TextStyle(
                        fontFamily: 'Juz',
                        fontSize: viewerController.value.juzFontSize,
                      ),
                    ),
                    Text(
                      'surah${lines.first.surahId.toString().padLeft(3, "0")}',
                      style: TextStyle(
                        fontFamily: 'QPC v2 surah name',
                        fontSize: viewerController.value.surahHeaderFontSize,
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
