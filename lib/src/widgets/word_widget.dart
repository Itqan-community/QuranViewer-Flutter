import 'package:flutter/material.dart';
import '../data/word.dart';
import '../controller.dart';

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
  final Function(Word word) onTap;
  final ViewerController viewerController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewerController,
      child: InkWell(
        key: Key('word${word.globalId}'),
        highlightColor: Colors.blue,
        onTap: () async {
          viewerController.focusOnAyah(word.ayahId);
          await onTap(word);
        },
        child: Text(word.glyph, style: style),
      ),
      builder: (BuildContext context, Widget? child) => Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        color: viewerController.value.focusedAyahId == word.ayahId
            ? Colors.blueGrey
            : null,
        child: child,
      ),
    );
  }
}
