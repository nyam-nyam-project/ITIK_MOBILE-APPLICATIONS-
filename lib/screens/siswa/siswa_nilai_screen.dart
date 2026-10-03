import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/hasil_kuis.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import 'kuis_play_screen.dart';
import 'kuis_result_screen.dart';

class SiswaNilaiScreen extends StatelessWidget {
  const SiswaNilaiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final list = app.riwayatSiswaSaatIni;

    return Scaffold(
      appBar: simpleAppBar('Nilai & Riwayat Kuis'),
      body: SafeArea(
        child: list.isEmpty
            ? const EmptyState(text: 'Belum ada riwayat kuis.\nYuk kerjakan kuis pertamamu!')
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final h = list[i];
                  return _HasilCard(hasil: h, app: app);
                },
              ),
      ),
    );
  }
}

class _HasilCard extends StatelessWidget {
  final HasilKuis hasil;
  final AppProvider app;
  const _HasilCard({required this.hasil, required this.app});

  // BARU: buka detail hasil (KuisResultScreen) dari riwayat
  void _lihatDetail(BuildContext context) {
    final kuis = app.kuisById(hasil.kuisId);
    if (kuis == null) {
      showAppToast(context, 'Data kuis tidak ditemukan');
      return;
    }
    final salah = kuis.soal.length - hasil.benar;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => KuisResultScreen(
          kuis: kuis,
          nilai: hasil.nilai,
          benar: hasil.benar,
          salah: salah,
          jawabanSiswa: hasil.jawabanSiswa,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = hasil;
    final dibawahKkm = h.dibawahKkm;
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(crossAxisAlignment: WrapCrossAlignment.center, spacing: 6, children: [
                        Text(h.kuis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                        if (h.remedial) const AppPill(label: 'Remedial', color: AppColors.red, background: AppColors.redLight),
                      ]),
                      const SizedBox(height: 3),
                      Text('${h.tanggal} • KKM ${h.kkm}', style: const TextStyle(fontSize: 11.5, color: AppColors.muted)),
                    ],
                  ),
                ),
                Text('${h.nilai}',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w800, color: dibawahKkm ? AppColors.red : AppColors.blue)),
              ],
            ),
            const Divider(height: 22),

            // Level di kiri; status + tombol detail di kanan (sejajar, ukuran setara pill)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LevelPill(level: h.level),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  children: [
                    
                    InkWell(
                      onTap: () => _lihatDetail(context),
                      borderRadius: BorderRadius.circular(99),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.blueLight,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          const Icon(Icons.visibility_outlined, size: 13, color: AppColors.blue),
                          const SizedBox(width: 4),
                          const Text('Detail',
                              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.blue)),
                        ]),
                      ),
                    ),
                      
                      AppPill(
                      label: h.status.label,
                      color: h.status == StatusValidasi.divalidasi ? AppColors.green : const Color(0xFFB9701C),
                      background: h.status == StatusValidasi.divalidasi ? AppColors.greenLight : const Color(0xFFFFF1E2),
                    ),

                  ],
                ),
              ],
            ),

            if (dibawahKkm && h.remedialDitugaskan && !h.remedialSelesai) ...[
              const Divider(height: 22),
              const Row(children: [
                Icon(Icons.error_outline, size: 14, color: Color(0xFFB9701C)),
                SizedBox(width: 5),
                Text('Remedial ditugaskan guru',
                    style: TextStyle(fontSize: 11.5, color: Color(0xFFB9701C), fontWeight: FontWeight.w700)),
              ]),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
                  onPressed: () {
                    final kuis = app.kuisById(h.kuisId);
                    if (kuis != null) {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => KuisPlayScreen(kuis: kuis, remedialOfId: h.id)));
                    }
                  },
                  icon: const Icon(Icons.trending_up, size: 18),
                  label: const Text('Kerjakan Remedial Sekarang'),
                ),
              ),
            ] else if (dibawahKkm) ...[
              const Divider(height: 22),
              const Text('Di bawah KKM — menunggu tinjauan guru',
                  style: TextStyle(fontSize: 11.5, color: AppColors.red, fontWeight: FontWeight.w700)),
            ],
          ],
        ),
      ),
    );
  }
}