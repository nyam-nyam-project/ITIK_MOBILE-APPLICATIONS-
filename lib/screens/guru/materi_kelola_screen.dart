import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/materi.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import 'materi_form_screen.dart';
import 'materi_view_screen.dart';

class MateriKelolaScreen extends StatelessWidget {
  const MateriKelolaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final list = app.materiList.reversed.toList();

    return Scaffold(
      appBar: simpleAppBar('Kelola Materi'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
          children: [
            const Text('Materi diunggah dalam bentuk file PDF. Berikut materi yang sudah tersedia untuk siswa.',
                style: TextStyle(fontSize: 12.5, color: AppColors.muted)),
            const SizedBox(height: 10),
            SectionTitle('Materi Sebelumnya (${list.length})'),
            if (list.isEmpty)
              const EmptyState(text: 'Belum ada materi yang diunggah.\nTekan tombol di bawah untuk menambahkan.')
            else
              ...list.map((m) => _MateriManageCard(materi: m, app: app)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.purple,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MateriFormScreen())),
        icon: const Icon(Icons.add),
        label: const Text('Tambahkan Materi'),
      ),
    );
  }
}

class _MateriManageCard extends StatelessWidget {
  final Materi materi;
  final AppProvider app;
  const _MateriManageCard({required this.materi, required this.app});

  Future<void> _hapus(BuildContext context) async {
    final ok = await confirmDialog(context, 'Hapus "${materi.judul}"?\n\nTindakan ini tidak dapat dibatalkan.');
    if (ok) {
      app.hapusMateri(materi.id);
      if (context.mounted) showAppToast(context, 'Materi telah dihapus');
    }
  }

  @override
  Widget build(BuildContext context) {
    final m = materi;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: AppColors.redLight, borderRadius: BorderRadius.circular(11)),
                child: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.red, size: 19),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${m.bab} — ${m.judul}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                  const SizedBox(height: 2),
                  Text(m.deskripsi, style: const TextStyle(fontSize: 11.5, color: AppColors.muted)),
                  const SizedBox(height: 6),
                  Wrap(spacing: 6, runSpacing: 4, children: [
                    Text('📄 ${m.pdfName}', style: const TextStyle(fontSize: 10.5, color: AppColors.muted)),
                    if (m.ukuran.isNotEmpty) Text(m.ukuran, style: const TextStyle(fontSize: 10.5, color: AppColors.muted)),
                    Text('oleh ${m.oleh}', style: const TextStyle(fontSize: 10.5, color: AppColors.muted)),
                  ]),
                ]),
              ),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MateriViewScreen(materiId: m.id))),
                  icon: const Icon(Icons.visibility_outlined, size: 16),
                  label: const Text('Lihat', style: TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MateriFormScreen(materiId: m.id))),
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('Edit', style: TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.red, side: const BorderSide(color: AppColors.redLight)),
                  onPressed: () => _hapus(context),
                  icon: const Icon(Icons.delete_outline, size: 16),
                  label: const Text('Hapus', style: TextStyle(fontSize: 12)),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
