class Ayah {
  final int id;
  final int surahId;
  final List<int> wordIds;
  final bool hasSajda;
  final int? rubNumber;

  Ayah({
    required this.id,
    required this.surahId,
    required this.wordIds,
    required this.rubNumber,
    this.hasSajda = false,
  });

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      id: json['id'],
      surahId: json['surah_id'],
      wordIds: json['word_ids'].cast<int>(),
      hasSajda: json['has_sajda'],
      rubNumber: json['rub_number'],
    );
  }

  factory Ayah.fromStr(
    String ayahIdStr, {
    bool hasSajda = false,
    List<int> wordIds = const [],
  }) {
    final parts = ayahIdStr.split(':');
    final surahId = int.parse(parts[0]);
    final ayahAndWords = parts[1].split('-');
    final ayahId = int.parse(ayahAndWords[0]);
    final wordIds = ayahAndWords.length > 1
        ? ayahAndWords.sublist(1).map((e) => int.parse(e)).toList()
        : <int>[];
    return Ayah(
      id: ayahId,
      surahId: surahId,
      wordIds: wordIds,
      hasSajda: hasSajda,
      rubNumber: null,
    );
  }

  @override
  String toString() {
    return '$surahId:$id';
  }

  operator <(Ayah other) {
    return surahId < other.surahId ||
        (surahId == other.surahId && id < other.id);
  }

  operator <=(Ayah other) {
    return other.surahId > surahId ||
        (surahId == other.surahId && other.id >= id);
  }

  operator >(Ayah other) {
    return surahId > other.surahId ||
        (surahId == other.surahId && id > other.id);
  }

  operator >=(Ayah other) {
    return surahId > other.surahId ||
        (surahId == other.surahId && id >= other.id);
  }
}
