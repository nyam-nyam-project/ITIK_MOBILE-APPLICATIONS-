import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/kuis.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';

/// Form tambah/edit soal. Jika [index] diisi -> mode edit soal ke-[index]
/// pada kuis [kuisId].
class SoalFormScreen extends StatefulWidget {
  final String kuisId;
  final int? index;
  const SoalFormScreen({super.key, required this.kuisId, this.index});

  @override
  State<SoalFormScreen> createState() => _SoalFormScreenState();
}

class _SoalFormScreenState extends State<SoalFormScreen> {
  late final TextEditingController pertanyaanCtrl;
  late final TextEditingController aCtrl, bCtrl, cCtrl, dCtrl;
  int jawaban = 0;
  String? gambar;

  bool get isEdit => widget.index != null;

  @override
  void initState() {
    super.initState();
    final app = context.read<AppProvider>();
    final k = app.kuisById(widget.kuisId);
    final existing = (isEdit && k != null) ? k.soal[widget.index!] : null;
    String opsiAt(int i) => (existing != null && i < existing.opsi.length) ? existing.opsi[i] : '';
    pertanyaanCtrl = TextEditingController(text: existing?.pertanyaan ?? '');
    aCtrl = TextEditingController(text: opsiAt(0));
    bCtrl = TextEditingController(text: opsiAt(1));
    cCtrl = TextEditingController(text: opsiAt(2));
    dCtrl = TextEditingController(text: opsiAt(3));
    jawaban = existing?.jawaban ?? 0;
    gambar = existing?.gambar;
  }

  @override
  void dispose() {
    pertanyaanCtrl.dispose();
    aCtrl.dispose();
    bCtrl.dispose();
    cCtrl.dispose();
    dCtrl.dispose();
    super.dispose();
  }

  void _pilihGambar() {
    // Placeholder pemilihan gambar — sambungkan ke `image_picker` saat integrasi backend.
    setState(() => gambar = 'gambar_soal_contoh.png');
    showAppToast(context, 'Gambar ditambahkan (contoh) ✔');
  }

  void _simpan() {
    if (pertanyaanCtrl.text.trim().isEmpty || aCtrl.text.trim().isEmpty || bCtrl.text.trim().isEmpty) {
      showAppToast(context, 'Pertanyaan serta opsi A & B wajib diisi');
      return;
    }
    final soal = Soal(
      pertanyaan: pertanyaanCtrl.text,
      opsi: [aCtrl.text, bCtrl.text, cCtrl.text.isEmpty ? '-' : cCtrl.text, dCtrl.text.isEmpty ? '-' : dCtrl.text],
      jawaban: jawaban,
      gambar: gambar,
    );
    final app = context.read<AppProvider>();
    if (isEdit) {
      app.editSoal(widget.kuisId, widget.index!, soal);
      showAppToast(context, 'Soal berhasil diperbarui ✔');
    } else {
      app.tambahSoal(widget.kuisId, soal);
      showAppToast(context, 'Soal berhasil ditambahkan ✔');
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final k = app.kuisById(widget.kuisId);

    return Scaffold(
      appBar: simpleAppBar(isEdit ? 'Edit Soal' : 'Tambah Soal'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          children: [
            if (k != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text.rich(TextSpan(
                  style: const TextStyle(fontSize: 12.5, color: AppColors.muted),
                  children: [
                    const TextSpan(text: 'Kuis: '),
                    TextSpan(text: k.judul, style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w700)),
                  ],
                )),
              ),
            AppCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _label('Pertanyaan'),
                TextField(controller: pertanyaanCtrl, maxLines: 3, decoration: const InputDecoration(hintText: 'Tulis pertanyaan kuis...')),
                const SizedBox(height: 14),
                _label('Gambar Soal (opsional)'),
                if (gambar != null)
                  Column(children: [
                    Container(
                      height: 90,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.image_rounded, color: AppColors.muted, size: 30),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(foregroundColor: AppColors.red, side: const BorderSide(color: AppColors.redLight)),
                        onPressed: () => setState(() => gambar = null),
                        icon: const Icon(Icons.delete_outline, size: 17),
                        label: const Text('Hapus Gambar'),
                      ),
                    ),
                  ])
                else
                  InkWell(
                    onTap: _pilihGambar,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(14)),
                      child: const Column(children: [
                        Icon(Icons.image_outlined, color: AppColors.muted, size: 24),
                        SizedBox(height: 6),
                        Text('Pilih gambar', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                        SizedBox(height: 2),
                        Text('JPG atau PNG • maksimal 5 MB', style: TextStyle(fontSize: 10.5, color: AppColors.muted)),
                      ]),
                    ),
                  ),
                const SizedBox(height: 14),
                Row(children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      _label('Opsi A'),
                      TextField(controller: aCtrl),
                    ]),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      _label('Opsi B'),
                      TextField(controller: bCtrl),
                    ]),
                  ),
                ]),
                const SizedBox(height: 14),
                Row(children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      _label('Opsi C'),
                      TextField(controller: cCtrl),
                    ]),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      _label('Opsi D'),
                      TextField(controller: dCtrl),
                    ]),
                  ),
                ]),
                const SizedBox(height: 14),
                _label('Jawaban Benar'),
                DropdownButtonFormField<int>(
                  value: jawaban,
                  items: const [
                    DropdownMenuItem(value: 0, child: Text('Opsi A')),
                    DropdownMenuItem(value: 1, child: Text('Opsi B')),
                    DropdownMenuItem(value: 2, child: Text('Opsi C')),
                    DropdownMenuItem(value: 3, child: Text('Opsi D')),
                  ],
                  onChanged: (v) => setState(() => jawaban = v ?? 0),
                  decoration: const InputDecoration(),
                ),
              ]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.purple),
              onPressed: _simpan,
              child: Text(isEdit ? 'Simpan Perubahan' : 'Simpan Soal'),
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
