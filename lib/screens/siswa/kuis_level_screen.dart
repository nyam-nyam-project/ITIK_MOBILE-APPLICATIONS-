import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import 'kuis_play_screen.dart';

class KuisLevelScreen extends StatelessWidget {
  const KuisLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final riwayat = app.riwayatSiswaSaatIni;

    return Scaffold(
      appBar: simpleAppBar('Pilih Tingkat Kesulitan'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          children: [
            const Text('Pilih kuis sesuai bab materi yang telah kamu pelajari.',
                style: TextStyle(fontSize: 12.5, color: AppColors.muted)),
            const SizedBox(height: 14),
            ...app.kuisList.map((k) {
              final m = app.materiById(k.materiId);

              // Semua percobaan siswa ini pada kuis tersebut
              final percobaan = riwayat.where((h) => h.kuisId == k.id).toList();
              final sudahDikerjakan = percobaan.isNotEmpty;
              final nilaiTerbaik = sudahDikerjakan
                  ? percobaan.map((h) => h.nilai).reduce((a, b) => a > b ? a : b)
                  : 0;
              final lulus = sudahDikerjakan && nilaiTerbaik >= k.kkm;

              final subtitle =
                  '${m?.judul ?? ''} • ${k.soal.length} soal • KKM ${k.kkm}'
                  '${sudahDikerjakan ? ' • Nilai $nilaiTerbaik' : ''}';

              return AppListItem(
                icon: Icons.quiz_rounded,
                iconColor: AppColors.orange,
                iconBg: AppColors.orangeLight,
                title: k.judul,
                subtitle: subtitle,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (sudahDikerjakan) ...[
                      Icon(
                        lulus ? Icons.check_circle : Icons.error_outline_rounded,
                        color: lulus ? AppColors.green : AppColors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                    ],
                    LevelPill(level: k.level),
                  ],
                ),
                onTap: () {
                  if (k.soal.isEmpty) {
                    showAppToast(context, 'Kuis ini belum memiliki soal');
                    return;
                  }
                  Navigator.push(context, MaterialPageRoute(builder: (_) => KuisPlayScreen(kuis: k)));
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}