class SearchResult {
  final String type;
  final String text;
  final String id;
  SearchResult({required this.type, required this.text, required this.id});
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
