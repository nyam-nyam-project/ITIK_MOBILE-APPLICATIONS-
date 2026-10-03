import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/kuis.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import 'kuis_detail_screen.dart';

/// Form tambah/edit kuis. Jika [kuisId] diisi -> mode edit.
class KuisFormScreen extends StatefulWidget {
  final String? kuisId;
  const KuisFormScreen({super.key, this.kuisId});

  @override
  State<KuisFormScreen> createState() => _KuisFormScreenState();
}

class _KuisFormScreenState extends State<KuisFormScreen> {
  late final TextEditingController judulCtrl;
  late final TextEditingController waktuCtrl;
  late final TextEditingController kkmCtrl;
  String? materiId;
  String level = 'Mudah';
  static const levels = ['Mudah', 'Sedang', 'Sulit'];

  bool get isEdit => widget.kuisId != null;

  @override
  void initState() {
    super.initState();
    final app = context.read<AppProvider>();
    final existing = widget.kuisId != null ? app.kuisById(widget.kuisId!) : null;
    judulCtrl = TextEditingController(text: existing?.judul ?? '');
    waktuCtrl = TextEditingController(text: '${existing?.waktu ?? 10}');
    kkmCtrl = TextEditingController(text: '${existing?.kkm ?? 75}');
    materiId = existing?.materiId ?? (app.materiList.isNotEmpty ? app.materiList.first.id : null);
    level = existing?.level ?? 'Mudah';
  }

  @override
  void dispose() {
    judulCtrl.dispose();
    waktuCtrl.dispose();
    kkmCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    if (judulCtrl.text.trim().isEmpty) {
      showAppToast(context, 'Judul kuis wajib diisi');
      return;
    }
    final waktu = int.tryParse(waktuCtrl.text) ?? 0;
    final kkm = int.tryParse(kkmCtrl.text) ?? 0;
    if (waktu < 1) {
      showAppToast(context, 'Durasi kuis wajib diisi (minimal 1 menit)');
      return;
    }
    if (kkm < 1 || kkm > 100) {
      showAppToast(context, 'KKM wajib diisi, antara 1-100');
      return;
    }
    final app = context.read<AppProvider>();
    if (isEdit) {
      app.editKuisMeta(widget.kuisId!, judul: judulCtrl.text, materiId: materiId ?? '', level: level, waktu: waktu, kkm: kkm);
      showAppToast(context, 'Kuis berhasil diperbarui ✔');
      Navigator.pop(context);
    } else {
      final id = 'K${DateTime.now().millisecondsSinceEpoch}';
      app.tambahKuis(Kuis(
        id: id,
        judul: judulCtrl.text,
        materiId: materiId ?? '',
        level: level,
        oleh: app.currentUser!.nama,
        tanggal: 'Hari ini',
        waktu: waktu,
        kkm: kkm,
        soal: [],
      ));
      showAppToast(context, 'Kuis dibuat. Silakan tambahkan soal ✔');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => KuisDetailScreen(kuisId: id)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    return Scaffold(
      appBar: simpleAppBar(isEdit ? 'Edit Kuis' : 'Tambah Kuis Baru'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          children: [
            AppCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _label('Judul Kuis'),
                TextField(controller: judulCtrl, decoration: const InputDecoration(hintText: 'Contoh: Kuis Perangkat Lunak')),
                const SizedBox(height: 14),
                _label('Materi Terkait'),
                DropdownButtonFormField<String>(
                  value: materiId,
                  items: app.materiList
                      .map((m) => DropdownMenuItem(value: m.id, child: Text('${m.bab} — ${m.judul}', overflow: TextOverflow.ellipsis)))
                      .toList(),
                  onChanged: (v) => setState(() => materiId = v),
                  decoration: const InputDecoration(),
                ),
                const SizedBox(height: 14),
                _label('Tingkat Kesulitan'),
                DropdownButtonFormField<String>(
                  value: level,
                  items: levels.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                  onChanged: (v) => setState(() => level = v ?? 'Mudah'),
                  decoration: const InputDecoration(),
                ),
                const SizedBox(height: 14),
                Row(children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      _label('Alokasi Waktu (menit)'),
                      TextField(controller: waktuCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration()),
                    ]),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      _label('KKM (nilai minimum)'),
                      TextField(controller: kkmCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration()),
                    ]),
                  ),
                ]),
                const SizedBox(height: 6),
                const Text(
                  'Siswa tidak melihat hitung mundur. Waktu pengerjaan dicatat otomatis dan dibandingkan dengan alokasi ini di halaman Validasi.',
                  style: TextStyle(fontSize: 11, color: AppColors.muted),
                ),
              ]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.purple),
              onPressed: _simpan,
              child: Text(isEdit ? 'Simpan Perubahan' : 'Buat Kuis & Tambah Soal'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ],
        ),
      ),
    );
  }

  Widget _label(String s) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(s, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
      );
}
