import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quran_viewer/src/controller.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;

class SearchResult{
  final String type;
  final String text;
  final String id;
  SearchResult({
    required this.type,
    required this.text,
    required this.id,
  });
}

class SurahSearchResult extends SearchResult {
  SurahSearchResult({
    required String type,
    required String text,
    required String id,
  }) : super(type: type, text: text, id: id);
}
class AyahSearchResult extends SearchResult {
  AyahSearchResult({
    required String type,
    required String text,
    required String id,
  }) : super(type: type, text: text, id: id);
}
Future<List<SearchResult>> search(String input) async{
  var headers = {
    'Accept': '*/*',
    'Accept-Language': 'en-US,en;q=0.9',
    'Connection': 'keep-alive',
    'Origin': 'https://www.kalimat.dev',
    'Referer': 'https://www.kalimat.dev/',
    'Sec-Fetch-Dest': 'empty',
    'Sec-Fetch-Mode': 'cors',
    'Sec-Fetch-Site': 'same-site',
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',
    'sec-ch-ua': '"Chromium";v="142", "Google Chrome";v="142", "Not_A Brand";v="99"',
    'sec-ch-ua-mobile': '?0',
    'sec-ch-ua-platform': '"Windows"',
    'x-api-key': 'b0007da2-71ab-45a5-b35f-15f99f7adb67'
  };
  var request = http.Request('GET', Uri.parse('https://api.kalimat.dev//search?query=$input&getText=1&exactMatchesOnly=0&numResults=10&queryType=text'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    final results = await response.stream.bytesToString();
    // encode to utf8
    final decodedJson = jsonDecode(results);
    final List<SearchResult> searchResults = <SearchResult>[];
    for (var element in decodedJson) {
      searchResults.add(SearchResult(
        type: element['type'],
        text: element['text'],
        id: element['id']));
    }
    return searchResults;
  }
  else {
  print(response.reasonPhrase);
  }
  return [];

}
class QuranSearchBar extends StatefulWidget {
  const QuranSearchBar({super.key,
  required this.viewerController,
  });
  final ViewerController viewerController;

  @override
  State<QuranSearchBar> createState() => _QuranSearchBarState();
}

class _QuranSearchBarState extends State<QuranSearchBar> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(223, 208, 185, .5),
    padding: const EdgeInsets.all(8.0),
    child: SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          padding: const WidgetStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16.0),
          ),
          onTap: () {
            controller.openView();
          },
          onChanged: (_) {
            controller.openView();
          },
          leading: const Icon(Icons.search),

        );
      },
      suggestionsBuilder: (BuildContext context, SearchController searchController) async{
        final input =  searchController.value.text;

        final results = (input.length >3)?await search(input):<SearchResult>[];
        if ( results.isEmpty) {
          return [
            const ListTile(
              title: Text('No results found'),
            ),
          ];
        }
        return results.map((r)=>
            ListTile(
              title: Text(r.text),
              onTap: () {
                if (r.type =='quran_verse'){
                  final ayahId = r.id;
                  final page = widget.viewerController.pages.firstWhereOrNull((p)=>p.contains(ayahId));
                  if (page != null){
                    widget.viewerController.pageController.jumpToPage(page.id-1);
                    widget.viewerController.focusOnAyah(ayahId);
                  }
                }
                if (r.type =='quran_chapter'){
                 final surah=  widget.viewerController.surahs.firstWhereOrNull((s)=>s.id.toString() == r.id);
                 final ayahId = '${surah?.id}:1';
                 final page = widget.viewerController.pages.firstWhereOrNull((p)=>p.contains(ayahId));
                 if (page != null){
                   widget.viewerController.pageController.jumpToPage(page.id-1);


                 }
                }

                setState(() {
                  searchController.closeView(r.text);
                });
              },
            )
        );
        return List<ListTile>.generate(5, (int index) {
          final String item = 'Page $index';
          return ListTile(
            title: Text(item),
            onTap: () {
              widget.viewerController.pageController.jumpToPage(index);
              widget.viewerController.focusOnAyah('1:1');
              setState(() {
                searchController.closeView(item);
              });
            },
          );
        });
      },
    ),
    );
  }
}

debounce<T>(T Function() callback, Duration duration) {
  Timer? timer;
  return () {
    if (timer != null) {
      timer!.cancel();
    }
    timer = Timer(duration, callback);
  };
}