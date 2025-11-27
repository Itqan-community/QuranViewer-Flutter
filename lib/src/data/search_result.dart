class SearchResult {
  final String type;
  final String text;
  final String id;
  SearchResult({required this.type, required this.text, required this.id});
}

class SurahSearchResult extends SearchResult {
  SurahSearchResult({
    required super.type,
    required super.text,
    required super.id,
  });
}

class AyahSearchResult extends SearchResult {
  AyahSearchResult({
    required super.type,
    required super.text,
    required super.id,
  });
}
