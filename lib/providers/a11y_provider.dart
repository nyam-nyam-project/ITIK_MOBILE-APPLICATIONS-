import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Setara objek `A11Y` pada prototipe: ukuran teks, mode kontras tinggi,
/// dan pembaca layar (text-to-speech).
class A11yProvider extends ChangeNotifier {
  double fontScale = 1.0;
  bool highContrast = false;
  bool autoRead = false; // BARU

  final FlutterTts _tts = FlutterTts(); // BARU

  static const List<Map<String, dynamic>> opsiUkuran = [
    {'v': 1.0, 'label': 'Normal'},
    {'v': 1.15, 'label': 'Besar'},
    {'v': 1.3, 'label': 'Lebih Besar'},
    {'v': 1.5, 'label': 'Sangat Besar'},
  ];

  void setFontScale(double v) {
    fontScale = v;
    notifyListeners();
  }

  void toggleContrast() {
    highContrast = !highContrast;
    notifyListeners();
  }

  // ---------- BARU ----------
  void toggleAutoRead() {
    autoRead = !autoRead;
    if (!autoRead) _tts.stop();
    notifyListeners();
  }

  Future<void> speakPage([String? text]) async {
    await _tts.setLanguage('id-ID');
    await _tts.stop();
    await _tts.speak(text ?? 'Halaman aksesibilitas');
  }

  Future<void> stopSpeaking() => _tts.stop();
  // --------------------------

  void reset() {
    fontScale = 1.0;
    highContrast = false;
    autoRead = false; // BARU
    _tts.stop(); // BARU
    notifyListeners();
  }
}

/// BARU: membaca otomatis saat pindah halaman jika autoRead aktif.
class A11yRouteObserver extends NavigatorObserver {
  final A11yProvider a11y;
  A11yRouteObserver(this.a11y);

  @override
  void didPush(Route route, Route? previousRoute) {
    if (a11y.autoRead) {
      a11y.speakPage(route.settings.name ?? 'Halaman baru');
    }
  }
}