import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/hasil_kuis.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';

class GuruValidasiScreen extends StatelessWidget {
  const GuruValidasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final perluRemedial = app.hasilList.where((h) => h.dibawahKkm).length;

    return Scaffold(
      appBar: simpleAppBar('Validasi & Remedial'),
      body: SafeArea(
        child: app.hasilList.isEmpty
            ? const EmptyState(text: 'Belum ada nilai kuis yang masuk.')
            : ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                children: [
                  Text('Pantau nilai, waktu pengerjaan tiap siswa, dan tugaskan remedial untuk yang di bawah KKM ($perluRemedial siswa).',
                      style: const TextStyle(fontSize: 12.5, color: AppColors.muted)),
                  const SizedBox(height: 12),
                  ...app.hasilList.map((h) => _ValidasiCard(hasil: h, app: app)),
                ],
              ),
      ),
    );
  }
}

class _ValidasiCard extends StatelessWidget {
  final HasilKuis hasil;
  final AppProvider app;
  const _ValidasiCard({required this.hasil, required this.app});

  Future<void> _tugaskanRemedial(BuildContext context) async {
    final ok = await confirmDialog(
        context, 'Tugaskan kuis remedial "${hasil.kuis}" untuk ${hasil.siswa}?\n\nSiswa akan melihat notifikasi di Beranda untuk mengerjakan ulang.');
    if (ok) {
      app.tugaskanRemedial(hasil.id);
      if (context.mounted) showAppToast(context, 'Remedial ditugaskan ke ${hasil.siswa} ✔');
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = hasil;
    final dibawahKkm = h.dibawahKkm;
    final kuisRef = app.kuisById(h.kuisId);
    final alokasi = kuisRef?.waktu ?? 10;
    final rasio = h.durasi / (alokasi * 60);
    final kecepatanLabel = rasio <= 0.6 ? '⚡ Cepat' : rasio <= 1.0 ? 'Sesuai alokasi' : '🐢 Lambat';
    final kecepatanColor = rasio <= 0.6 ? AppColors.green : rasio <= 1.0 ? AppColors.blue : AppColors.red;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(h.siswa, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text('${h.tanggal} • ${h.kuis}${h.remedial ? ' • Remedial' : ''}',
                        style: const TextStyle(fontSize: 11, color: AppColors.muted)),
                  ]),
                ),
                Text('${h.nilai}',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: dibawahKkm ? AppColors.red : AppColors.blue)),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(spacing: 6, runSpacing: 6, children: [
              LevelPill(level: h.level),
              dibawahKkm
                  ? AppPill(label: '↓ KKM ${h.kkm}', color: AppColors.red, background: AppColors.redLight)
                  : AppPill(label: '✔ KKM ${h.kkm}', color: AppColors.green, background: AppColors.greenLight),
              Text('⏱ ${fmtWaktu(h.durasi)}', style: const TextStyle(fontSize: 11, color: AppColors.muted)),
              AppPill(label: kecepatanLabel, color: kecepatanColor, background: kecepatanColor.withOpacity(.12)),
              AppPill(
                label: h.status.label,
                color: h.status == StatusValidasi.divalidasi ? AppColors.green : const Color(0xFFB9701C),
                background: h.status == StatusValidasi.divalidasi ? AppColors.greenLight : const Color(0xFFFFF1E2),
              ),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: h.status == StatusValidasi.divalidasi
                    ? const _StaticBadge(label: 'Sudah Valid', color: AppColors.green, bg: AppColors.greenLight)
                    : OutlinedButton.icon(
                        onPressed: () {
                          app.validasiNilai(h.id);
                          showAppToast(context, 'Nilai siswa telah divalidasi ✔');
                        },
                        icon: const Icon(Icons.check_circle_outline, size: 17),
                        label: const Text('Validasi', style: TextStyle(fontSize: 12.5)),
                      ),
              ),
              if (dibawahKkm) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: h.remedialSelesai
                      ? const _StaticBadge(label: 'Remedial Selesai', color: AppColors.green, bg: AppColors.greenLight)
                      : h.remedialDitugaskan
                          ? OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(foregroundColor: AppColors.red, side: const BorderSide(color: AppColors.redLight)),
                              onPressed: () {
                                app.batalkanRemedial(h.id);
                                showAppToast(context, 'Penugasan remedial dibatalkan');
                              },
                              icon: const Icon(Icons.close_rounded, size: 17),
                              label: const Text('Batalkan', style: TextStyle(fontSize: 12.5)),
                            )
                          : ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
                              onPressed: () => _tugaskanRemedial(context),
                              icon: const Icon(Icons.error_outline, size: 17),
                              label: const Text('Remedial', style: TextStyle(fontSize: 12.5)),
                            ),
                ),
              ],
            ]),
          ],
        ),
      ),
    );
  }
}

class _StaticBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color bg;
  const _StaticBadge({required this.label, required this.color, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.check, size: 15, color: color),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12.5)),
      ]),
    );
  }
}
