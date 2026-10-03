import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/user.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import '../guru/guru_validasi_screen.dart';
import '../siswa/kuis_play_screen.dart';

class NotifikasiScreen extends StatelessWidget {
  const NotifikasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final isSiswa = app.currentUser!.role == UserRole.siswa;
    final items = isSiswa
        ? app.hasilList.where((h) => app.milikSiswaIni(h) && h.remedialDitugaskan && !h.remedialSelesai).toList()
        : app.menungguValidasi;

    return Scaffold(
      appBar: simpleAppBar('Notifikasi'),
      body: SafeArea(
        child: items.isEmpty
            ? const EmptyState(text: 'Belum ada notifikasi baru.')
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final h = items[i];
                  if (isSiswa) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: NoticeBox(
                        title: 'Remedial Ditugaskan Guru',
                        color: AppColors.red,
                        background: AppColors.redLight,
                        borderColor: const Color(0xFFF6C6C8),
                        message:
                            'Nilai kamu (${h.nilai}) pada ${h.kuis} belum mencapai KKM (${h.kkm}). Gurumu menugaskan kamu mengerjakan ulang kuis ini.',
                        action: SizedBox(
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
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 11),
                    child: AppCard(
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(h.siswa, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 2),
                                Text('${h.tanggal} • ${h.kuis} — nilai belum divalidasi',
                                    style: const TextStyle(fontSize: 11, color: AppColors.muted)),
                              ]),
                            ),
                            Text('${h.nilai}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.blue)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GuruValidasiScreen())),
                            icon: const Icon(Icons.check_circle_outline, size: 18),
                            label: const Text('Buka Validasi'),
                          ),
                        ),
                      ]),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
