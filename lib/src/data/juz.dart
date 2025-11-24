import 'ayah.dart';

class Juz {
  final int juzNumber;
  final String firstAyah;
  final String lastAyah;

  Juz({
    required this.juzNumber,
    required this.firstAyah,
    required this.lastAyah,
  });

  factory Juz.fromJson(Map<String, dynamic> json) {
    return Juz(
      juzNumber: json['juz_number'],
      firstAyah: json['first_verse_key'],
      lastAyah: json['last_verse_key'],
    );
  }

  bool contains(Ayah ayahId) {
    return Ayah.fromStr(firstAyah) <= ayahId &&
        ayahId <= Ayah.fromStr(lastAyah);
  }
}
