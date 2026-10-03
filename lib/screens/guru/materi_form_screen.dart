import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/materi.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';

/// Form tambah/edit materi. Jika [materiId] diisi -> mode edit.
class MateriFormScreen extends StatefulWidget {
  final String? materiId;
  const MateriFormScreen({super.key, this.materiId});

  @override
  State<MateriFormScreen> createState() => _MateriFormScreenState();
}

class _MateriFormScreenState extends State<MateriFormScreen> {
  late final TextEditingController babCtrl;
  late final TextEditingController judulCtrl;
  late final TextEditingController deskripsiCtrl;
  String? pdfNameTerpilih;

  bool get isEdit => widget.materiId != null;

  @override
  void initState() {
    super.initState();
    final app = context.read<AppProvider>();
    final existing = widget.materiId != null ? app.materiById(widget.materiId!) : null;
    babCtrl = TextEditingController(text: existing?.bab ?? '');
    judulCtrl = TextEditingController(text: existing?.judul ?? '');
    deskripsiCtrl = TextEditingController(text: existing?.deskripsi ?? '');
    pdfNameTerpilih = existing?.pdfName;
  }

  @override
  void dispose() {
    babCtrl.dispose();
    judulCtrl.dispose();
    deskripsiCtrl.dispose();
    super.dispose();
  }

  void _pilihPdf() {
    // Placeholder pemilihan file — sambungkan ke paket `file_picker` saat
    // integrasi backend dilakukan.
    setState(() => pdfNameTerpilih = '${judulCtrl.text.isEmpty ? 'materi' : judulCtrl.text}.pdf');
    showAppToast(context, 'File PDF dipilih (contoh) ✔');
  }

  void _simpan() {
    if (babCtrl.text.trim().isEmpty || judulCtrl.text.trim().isEmpty) {
      showAppToast(context, 'Nama bab & judul materi wajib diisi');
      return;
    }
    final app = context.read<AppProvider>();
    if (isEdit) {
      final existing = app.materiById(widget.materiId!)!;
      app.editMateri(
        widget.materiId!,
        Materi(
          id: existing.id,
          bab: babCtrl.text,
          judul: judulCtrl.text,
          kelas: existing.kelas,
          deskripsi: deskripsiCtrl.text,
          isi: existing.isi,
          pdfName: pdfNameTerpilih ?? existing.pdfName,
          ukuran: existing.ukuran,
          oleh: existing.oleh,
          tanggal: existing.tanggal,
        ),
      );
      showAppToast(context, 'Materi berhasil diperbarui ✔');
    } else {
      final user = app.currentUser!;
      app.tambahMateri(Materi(
        id: 'M${DateTime.now().millisecondsSinceEpoch}',
        bab: babCtrl.text,
        judul: judulCtrl.text,
        kelas: 'X TKJ',
        deskripsi: deskripsiCtrl.text,
        isi: deskripsiCtrl.text,
        pdfName: pdfNameTerpilih ?? 'materi.pdf',
        ukuran: '—',
        oleh: user.nama,
        tanggal: 'Hari ini',
      ));
      showAppToast(context, 'Materi berhasil disimpan ✔');
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(isEdit ? 'Edit Materi' : 'Tambah Materi Baru'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          children: [
            AppCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _label('Nama Bab'),
                TextField(controller: babCtrl, decoration: const InputDecoration(hintText: 'Contoh: Bab 5')),
                const SizedBox(height: 14),
                _label('Judul Materi'),
                TextField(controller: judulCtrl, decoration: const InputDecoration(hintText: 'Contoh: Dasar PowerPoint')),
                const SizedBox(height: 14),
                _label('Deskripsi Singkat'),
                TextField(controller: deskripsiCtrl, maxLines: 3, decoration: const InputDecoration(hintText: 'Ringkasan isi materi...')),
                const SizedBox(height: 14),
                _label('File Materi (PDF)'),
                if (pdfNameTerpilih != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(12)),
                    child: Row(children: [
                      const Icon(Icons.picture_as_pdf_rounded, color: AppColors.red),
                      const SizedBox(width: 10),
                      Expanded(child: Text(pdfNameTerpilih!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5), overflow: TextOverflow.ellipsis)),
                      IconButton(onPressed: () => setState(() => pdfNameTerpilih = null), icon: const Icon(Icons.close, size: 18)),
                    ]),
                  )
                else
                  InkWell(
                    onTap: _pilihPdf,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 22),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Column(children: [
                        Icon(Icons.upload_file_rounded, color: AppColors.muted, size: 26),
                        SizedBox(height: 6),
                        Text('Pilih file PDF', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                        SizedBox(height: 2),
                        Text('Hanya format .pdf • maksimal 20 MB', style: TextStyle(fontSize: 10.5, color: AppColors.muted)),
                      ]),
                    ),
                  ),
              ]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.purple),
              onPressed: _simpan,
              child: Text(isEdit ? 'Simpan Perubahan' : 'Simpan Materi'),
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
