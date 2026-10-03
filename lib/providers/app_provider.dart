import 'package:flutter/foundation.dart';
import '../data/dummy_data.dart';
import '../models/user.dart';
import '../models/materi.dart';
import '../models/kuis.dart';
import '../models/hasil_kuis.dart';

/// Provider utama aplikasi. Menyimpan "database" dummy (di memori) beserta
/// sesi pengguna yang sedang login, setara dengan `DB` + `S` pada prototipe.
/// Ganti isi method-method ini dengan pemanggilan API ketika backend sudah siap.
class AppProvider extends ChangeNotifier {
  final List<AppUser> users = DummyData.users();
  final List<Materi> materiList = DummyData.materi();
  final List<Kuis> kuisList = DummyData.kuis();
  final List<HasilKuis> hasilList = DummyData.hasil();

  /// key: 'userId_materiId' -> selesai atau tidak
  final Map<String, bool> progress = {};

  AppUser? currentUser;

  bool get isLoggedIn => currentUser != null;

  // ---------------- AUTH ----------------
  String? login(String emailOrNama, String password) {
    final input = emailOrNama.trim().toLowerCase();
    if (input.isEmpty || password.isEmpty) return 'Email/Nama & kata sandi wajib diisi';
    final match = users.where((u) =>
        (u.email.toLowerCase() == input || u.nama.toLowerCase() == input) &&
        u.password == password);
    if (match.isEmpty) return 'Email/Nama atau kata sandi salah';
    currentUser = match.first;
    notifyListeners();
    return null;
  }

  String? register({
    required String nama,
    required String email,
    required String password,
    required String konfirmasi,
    required UserRole role,
    String? kelas,
    String? induk,
  }) {
    if (nama.trim().isEmpty || email.trim().isEmpty) return 'Nama & email wajib diisi';
    if (password.length < 6) return 'Kata sandi wajib diisi, minimal 6 karakter';
    if (password != konfirmasi) return 'Konfirmasi kata sandi tidak cocok';
    final dipakai = users.any((u) => u.email.toLowerCase() == email.toLowerCase());
    if (dipakai) return 'Email sudah terdaftar, silakan masuk';
    if (role == UserRole.siswa && (kelas == null || kelas.trim().isEmpty)) {
      return 'Kelas wajib diisi';
    }
    final u = AppUser(
      id: 'U${DateTime.now().millisecondsSinceEpoch}',
      nama: nama,
      email: email,
      password: password,
      role: role,
      kelas: role == UserRole.siswa ? kelas : null,
      induk: role == UserRole.siswa ? (induk?.isEmpty ?? true ? '-' : induk) : null,
    );
    users.add(u);
    currentUser = u;
    notifyListeners();
    return null;
  }

  void logout() {
    currentUser = null;
    notifyListeners();
  }

  // ---------------- PROGRES MATERI (SISWA) ----------------
  bool isMateriSelesai(String materiId) {
    final key = '${currentUser?.id}_$materiId';
    return progress[key] == true;
  }

  void submitProgresMateri(String materiId) {
    final key = '${currentUser?.id}_$materiId';
    progress[key] = true;
    notifyListeners();
  }

  // ---------------- HASIL / NILAI SISWA ----------------
  bool milikSiswaIni(HasilKuis h) => h.siswaId == currentUser?.id;

  List<HasilKuis> get riwayatSiswaSaatIni =>
      hasilList.where(milikSiswaIni).toList();

  HasilKuis? get remedialAktifUntukSiswa {
    try {
      return hasilList.firstWhere(
          (h) => milikSiswaIni(h) && h.remedialDitugaskan && !h.remedialSelesai);
    } catch (_) {
      return null;
    }
  }

  List<HasilKuis> get menungguValidasi =>
      hasilList.where((h) => h.status == StatusValidasi.menungguValidasi).toList();

  HasilKuis submitHasilKuis({
    required Kuis kuis,
    required int nilai,
    required int benar,
    required int durasiDetik,
    required List<int> jawabanSiswa, // BARU
    String? remedialOfId,
  }) {
    final h = HasilKuis(
      id: 'H${DateTime.now().millisecondsSinceEpoch}',
      siswaId: currentUser!.id,
      siswa: currentUser!.nama,
      kuisId: kuis.id,
      kuis: kuis.judul,
      level: kuis.level,
      nilai: nilai,
      kkm: kuis.kkm,
      durasi: durasiDetik,
      benar: benar, // BARU
      jawabanSiswa: jawabanSiswa, // BARU
      remedial: remedialOfId != null,
      tanggal: 'Hari ini',
    );
    hasilList.insert(0, h);
    if (remedialOfId != null) {
      final asal = hasilList.where((x) => x.id == remedialOfId);
      if (asal.isNotEmpty) asal.first.remedialSelesai = true;
    }
    notifyListeners();
    return h;
  }

  // ---------------- GURU: VALIDASI & REMEDIAL ----------------
  void validasiNilai(String hasilId) {
    final h = hasilList.firstWhere((x) => x.id == hasilId);
    h.status = StatusValidasi.divalidasi;
    notifyListeners();
  }

  void tugaskanRemedial(String hasilId) {
    final h = hasilList.firstWhere((x) => x.id == hasilId);
    h.remedialDitugaskan = true;
    notifyListeners();
  }

  void batalkanRemedial(String hasilId) {
    final h = hasilList.firstWhere((x) => x.id == hasilId);
    h.remedialDitugaskan = false;
    notifyListeners();
  }

  // ---------------- MATERI: CRUD (GURU) ----------------
  Materi? materiById(String id) {
    final r = materiList.where((m) => m.id == id);
    return r.isEmpty ? null : r.first;
  }

  void tambahMateri(Materi m) {
    m.createdAt ??= DateTime.now(); // BARU: catat waktu upload
    materiList.add(m);
    notifyListeners();
  }

  void editMateri(String id, Materi baru) {
    final idx = materiList.indexWhere((m) => m.id == id);
    if (idx != -1) {
      // BARU: waktu upload asli tidak hilang saat materi diedit
      baru.createdAt ??= materiList[idx].createdAt;
      materiList[idx] = baru;
    }
    notifyListeners();
  }

  void hapusMateri(String id) {
    materiList.removeWhere((m) => m.id == id);
    notifyListeners();
  }

  // ---------------- KUIS: CRUD (GURU) ----------------
  Kuis? kuisById(String id) {
    final r = kuisList.where((k) => k.id == id);
    return r.isEmpty ? null : r.first;
  }

  void tambahKuis(Kuis k) {
    k.createdAt ??= DateTime.now(); // BARU: catat waktu upload
    kuisList.add(k);
    notifyListeners();
  }

  void editKuisMeta(String id, {required String judul, required String materiId, required String level, required int waktu, required int kkm}) {
    final k = kuisById(id);
    if (k == null) return;
    k.judul = judul;
    k.materiId = materiId;
    k.level = level;
    k.waktu = waktu;
    k.kkm = kkm;
    notifyListeners();
  }

  void hapusKuis(String id) {
    kuisList.removeWhere((k) => k.id == id);
    notifyListeners();
  }

  void tambahSoal(String kuisId, Soal soal) {
    kuisById(kuisId)?.soal.add(soal);
    notifyListeners();
  }

  void editSoal(String kuisId, int index, Soal soal) {
    final k = kuisById(kuisId);
    if (k != null && index >= 0 && index < k.soal.length) {
      k.soal[index] = soal;
      notifyListeners();
    }
  }

  void hapusSoal(String kuisId, int index) {
    kuisById(kuisId)?.soal.removeAt(index);
    notifyListeners();
  }
}