import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/kuis.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import 'kuis_form_screen.dart';
import 'soal_form_screen.dart';

class KuisDetailScreen extends StatelessWidget {
  final String kuisId;
  const KuisDetailScreen({super.key, required this.kuisId});

  Future<void> _hapusKuis(BuildContext context, AppProvider app, Kuis k) async {
    final ok = await confirmDialog(context, 'Hapus "${k.judul}" beserta ${k.soal.length} soal di dalamnya?\n\nTindakan ini tidak dapat dibatalkan.');
    if (ok) {
      app.hapusKuis(k.id);
      if (context.mounted) {
        Navigator.pop(context);
        showAppToast(context, 'Kuis telah dihapus');
      }
    }
  }

  Future<void> _hapusSoal(BuildContext context, AppProvider app, String kuisId, int index) async {
    final ok = await confirmDialog(context, 'Hapus soal nomor ${index + 1} dari kuis ini?');
    if (ok) {
      app.hapusSoal(kuisId, index);
      if (context.mounted) showAppToast(context, 'Soal telah dihapus');
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final k = app.kuisById(kuisId);
    if (k == null) {
      return const Scaffold(body: Center(child: Text('Kuis tidak ditemukan')));
    }
    final m = app.materiById(k.materiId);
    const letters = ['A', 'B', 'C', 'D', 'E'];

    return Scaffold(
      appBar: simpleAppBar('Detail Kuis'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
          children: [
            AppCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(k.judul, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800))),
                  LevelPill(level: k.level),
                ]),
                const SizedBox(height: 4),
                Text(
                  '${m != null ? '${m.bab} — ${m.judul}' : 'Belum terkait materi'} • ${k.soal.length} soal • ⏱ ${k.waktu} menit • KKM ${k.kkm}',
                  style: const TextStyle(fontSize: 12, color: AppColors.muted),
                ),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => KuisFormScreen(kuisId: k.id))),
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: const Text('Edit Kuis', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(foregroundColor: AppColors.red, side: const BorderSide(color: AppColors.redLight)),
                      onPressed: () => _hapusKuis(context, app, k),
                      icon: const Icon(Icons.delete_outline, size: 16),
                      label: const Text('Hapus Kuis', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ]),
              ]),
            ),
            const SizedBox(height: 14),
            AppCard(
              color: AppColors.greenLight,
              borderColor: const Color(0xFFBFEBD6),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: const [
                  Icon(Icons.download_rounded, color: AppColors.green, size: 20),
                  SizedBox(width: 8),
                  Text('Template Excel Soal', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5)),
                ]),
                const SizedBox(height: 6),
                const Text(
                  'Unduh format kolom: No Soal, Pertanyaan, Opsi A–E, dan Jawaban. Isi sesuai contoh lalu gunakan sebagai acuan saat menambah soal.',
                  style: TextStyle(fontSize: 11.5, color: Color(0xFF2E7D5A), height: 1.5),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.green),
                    onPressed: () => showAppToast(context, 'Hubungkan ke package excel (mis. `excel`) untuk fitur unduh template'),
                    icon: const Icon(Icons.download_rounded, size: 18),
                    label: const Text('Unduh Template Excel'),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 8),
            SectionTitle('Daftar Soal (${k.soal.length})'),
            if (k.soal.isEmpty)
              const EmptyState(text: 'Belum ada soal pada kuis ini.')
            else
              ...List.generate(k.soal.length, (idx) {
                final s = k.soal[idx];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppCard(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('Soal ${idx + 1}', style: const TextStyle(fontSize: 11, color: AppColors.muted)),
                        if (s.gambar != null) const Text('🖼 bergambar', style: TextStyle(fontSize: 11, color: AppColors.muted)),
                      ]),
                      const SizedBox(height: 6),
                      Text(s.pertanyaan, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, height: 1.5)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: List.generate(s.opsi.length, (i) {
                          final benar = i == s.jawaban;
                          return AppPill(
                            label: '${letters[i]}. ${s.opsi[i]}',
                            color: benar ? AppColors.green : AppColors.muted,
                            background: benar ? AppColors.greenLight : AppColors.bg,
                          );
                        }),
                      ),
                      const SizedBox(height: 10),
                      Row(children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SoalFormScreen(kuisId: k.id, index: idx))),
                            icon: const Icon(Icons.edit_outlined, size: 16),
                            label: const Text('Edit Soal', style: TextStyle(fontSize: 12)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(foregroundColor: AppColors.red, side: const BorderSide(color: AppColors.redLight)),
                            onPressed: () => _hapusSoal(context, app, k.id, idx),
                            icon: const Icon(Icons.delete_outline, size: 16),
                            label: const Text('Hapus Soal', style: TextStyle(fontSize: 12)),
                          ),
                        ),
                      ]),
                    ]),
                  ),
                );
              }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SoalFormScreen(kuisId: k.id))),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Soal'),
      ),
    );
  }
}
