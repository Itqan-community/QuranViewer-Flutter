import 'package:flutter/material.dart';
import '../data/line.dart';

import '../controller.dart';
import 'word_widget.dart';

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
          Text(
            'header',
            style: TextStyle(
              fontFamily: 'Juz',
              fontSize: viewerController.value.headerFontSize,
            ),
          ),
          Text(
            'surah${line.surahId.toString().padLeft(3, "0")}',
            style: TextStyle(
              fontFamily: 'QPC v2 surah name',
              fontSize: viewerController.value.surahNameFontSize,
            ),
          ),
        ],
      );
    }
    if (line.lineType == LineType.basmallah) {
      return Text(
        '﷽',
        style: TextStyle(
          fontFamily: 'Juz',
          fontSize: viewerController.value.basmallahFontSize,
        ),
      );
    }

    final sajdaWidget = Text(
      'marker-half',
      style: TextStyle(
        fontFamily: 'Juz',
        fontSize: viewerController.value.markerFontSize,
      ),
    );
    final rubWidget = (line.rubNumber == null)
        ? null
        : Text(
            ((line.rubNumber! - 1) % 4 == 0) ? 'marker-full' : 'marker-half',
            style: TextStyle(
              fontFamily: 'Juz',
              fontSize: viewerController.value.markerFontSize,
            ),
          );
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (pageNumber % 2 != 0)
          if (line.hasSajda) sajdaWidget else if (rubWidget != null) rubWidget,

        Spacer(),
        ...line.words.map(
          (word) => WordWidget(
            viewerController: viewerController,
            onTap: (word) async {
              // move focus to the previous word
              //show bottom sheet
              if (word.isAyahEnd) {
                await showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return BottomSheet(
                      builder: (BuildContext context) => SizedBox(
                        height: MediaQuery.of(context).size.height / 4,
                        child: Column(
                          children: [
                            Text(
                              'Show Translation/Tafsir for this word or this Ayah',
                            ),
                            Text('Word: ${word.text} (Ayah: ${word.ayahId})'),
                          ],
                        ),
                      ),
                      onClosing: () {},
                    );
                  },
                );
              }
            },
            word: word,
            style: TextStyle(
              fontFamily: (line.lineType == LineType.basmallah)
                  ? 'QPC v2 p1'
                  : 'QPC v2 p$pageNumber',
              fontSize: viewerController.value.wordFontSize,
            ),
          ),
        ),
        Spacer(),
        if (pageNumber % 2 == 0)
          if (line.hasSajda) sajdaWidget else if (rubWidget != null) rubWidget,
      ],
    );
  }
}
