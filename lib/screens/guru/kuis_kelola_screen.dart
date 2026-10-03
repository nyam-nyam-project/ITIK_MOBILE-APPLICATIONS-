import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/kuis.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import 'kuis_form_screen.dart';
import 'kuis_detail_screen.dart';

class KuisKelolaScreen extends StatelessWidget {
  const KuisKelolaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final list = app.kuisList.reversed.toList();

    return Scaffold(
      appBar: simpleAppBar('Kelola Kuis'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
          children: [
            const Text('Berikut kuis yang sudah dibuat. Pilih Edit untuk mengubah atau Hapus untuk menghapusnya.',
                style: TextStyle(fontSize: 12.5, color: AppColors.muted)),
            const SizedBox(height: 10),
            SectionTitle('Kuis Sebelumnya (${list.length})'),
            if (list.isEmpty)
              const EmptyState(text: 'Belum ada kuis yang dibuat.\nTekan tombol di bawah untuk membuat kuis pertama.')
            else
              ...list.map((k) => _KuisManageCard(kuis: k, app: app)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.purple,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KuisFormScreen())),
        icon: const Icon(Icons.add),
        label: const Text('Tambahkan Kuis'),
      ),
    );
  }
}

class _KuisManageCard extends StatelessWidget {
  final Kuis kuis;
  final AppProvider app;
  const _KuisManageCard({required this.kuis, required this.app});

  Future<void> _hapus(BuildContext context) async {
    final ok = await confirmDialog(context, 'Hapus "${kuis.judul}" beserta ${kuis.soal.length} soal di dalamnya?\n\nTindakan ini tidak dapat dibatalkan.');
    if (ok) {
      app.hapusKuis(kuis.id);
      if (context.mounted) showAppToast(context, 'Kuis telah dihapus');
    }
  }

  @override
  Widget build(BuildContext context) {
    final k = kuis;
    final m = app.materiById(k.materiId);
    final adaGambar = k.soal.where((s) => s.gambar != null).length;

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
                decoration: BoxDecoration(color: AppColors.orangeLight, borderRadius: BorderRadius.circular(11)),
                child: const Icon(Icons.quiz_rounded, color: AppColors.orange, size: 19),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Text(k.judul, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5))),
                    LevelPill(level: k.level),
                  ]),
                  const SizedBox(height: 2),
                  Text(m != null ? '${m.bab} — ${m.judul}' : 'Belum terkait materi', style: const TextStyle(fontSize: 11.5, color: AppColors.muted)),
                  const SizedBox(height: 6),
                  Wrap(spacing: 6, runSpacing: 4, children: [
                    Text('${k.soal.length} soal', style: const TextStyle(fontSize: 10.5, color: AppColors.muted)),
                    if (adaGambar > 0) Text('🖼 $adaGambar bergambar', style: const TextStyle(fontSize: 10.5, color: AppColors.muted)),
                    Text('oleh ${k.oleh}', style: const TextStyle(fontSize: 10.5, color: AppColors.muted)),
                  ]),
                ]),
              ),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => KuisDetailScreen(kuisId: k.id))),
                  icon: const Icon(Icons.visibility_outlined, size: 16),
                  label: const Text('Soal', style: TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => KuisFormScreen(kuisId: k.id))),
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
