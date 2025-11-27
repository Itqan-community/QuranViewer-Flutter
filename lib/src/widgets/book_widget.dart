import 'dart:ui';
import 'package:flutter/material.dart';
import '../data/word.dart';
import '../data/ayah.dart';
import '../data/surah.dart';
import '../data/quran_page.dart';
import '../controller.dart';
import '../../quran_search_bar.dart';
import 'page_widget.dart';

class Book extends StatefulWidget {
  const Book({
    super.key,
    required this.words,
    required this.ayahs,
    required this.surahs,
    required this.pages,
    this.viewerController,
  });

  final List<Word> words;
  final Map<String, Ayah> ayahs;
  final List<Surah> surahs;
  final List<QuranPage> pages;
  final ViewerController? viewerController;

  @override
  State<Book> createState() => _BookState();
}

class _BookState extends State<Book> {
  final pageList = <Widget>[];
  ViewerController? _localViewerController;
  PageController? _localPageController;

  ViewerController get viewerController =>
      widget.viewerController ?? _localViewerController!;

  @override
  void dispose() {
    _localPageController?.dispose();
    _localViewerController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.viewerController == null) {
      final config = ViewerConfig();
      _localPageController = PageController(
        initialPage: config.initialPage - 1,
      );
      _localViewerController = ViewerController(
        config,
        pageController: _localPageController!,
        words: widget.words,
        ayahs: widget.ayahs,
        surahs: widget.surahs,
        pages: widget.pages,
      );
    }

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          QuranSearchBar(viewerController: viewerController),
          Expanded(
            child: GestureDetector(
              onTap: () {
                viewerController.removeAyahFocus();
                // pageController.nextPage(
                //   duration: Duration(milliseconds: 400),
                //   curve: Curves.easeInOut,
                // );
              },
              child: PageView.builder(
                controller: viewerController.pageController,
                clipBehavior: Clip.none,
                pageSnapping: true,
                padEnds: true,
                itemCount: pageList.length,
                scrollDirection: Axis.horizontal,
                scrollBehavior: ScrollConfiguration.of(context).copyWith(
                  scrollbars: false,
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                physics: const PageScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return pageList[index];
                },
                // children: pageList,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
