class Surah {
  final int id;
  final List<int> ayahIds;

  Surah({required this.id, required this.ayahIds});

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(id: json['id'], ayahIds: json['ayah_ids'].cast<int>());
  }
}
