class Soal {
  String pertanyaan;
  List<String> opsi; // A..D
  int jawaban; // index opsi yang benar
  String? gambar; // path gambar lokal, opsional

  Soal({
    required this.pertanyaan,
    required this.opsi,
    required this.jawaban,
    this.gambar,
  });
}

class Kuis {
  final String id;
  String judul;
  String materiId;
  String level; // Mudah | Sedang | Sulit
  String oleh;
  String tanggal;
  int waktu; // alokasi waktu (menit)
  int kkm;
  List<Soal> soal;
  DateTime? createdAt; // BARU
 
  Kuis({
    required this.id,
    required this.judul,
    required this.materiId,
    required this.level,
    required this.oleh,
    required this.tanggal,
    required this.waktu,
    required this.kkm,
    required this.soal,
    this.createdAt, // BARU

  });
}
