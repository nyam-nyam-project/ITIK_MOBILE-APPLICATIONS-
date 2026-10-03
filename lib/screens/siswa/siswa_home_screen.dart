import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import '../shared/notifikasi_screen.dart';
import 'materi_detail_screen.dart';
import 'kuis_play_screen.dart';
import 'kuis_level_screen.dart';
import 'siswa_materi_screen.dart';

class SiswaHomeScreen extends StatelessWidget {
  const SiswaHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final user = app.currentUser;

    // Antisipasi: user belum ter-load / sudah logout
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final totalMateri = app.materiList.length;
    final totalKuis = app.kuisList.length;
    final doneCount = app.progress.values.where((v) => v == true).length;
    // Antisipasi: pembagian dengan nol & progres > 100%
    final pct = totalMateri == 0
        ? 0
        : ((doneCount / totalMateri) * 100).round().clamp(0, 100);
    final tugasRemedial = app.remedialAktifUntukSiswa;

    // Materi yang belum dipelajari (belum ditandai selesai)
    final materiBelum =
        app.materiList.where((m) => !app.isMateriSelesai(m.id)).toList();

    // Kuis yang belum pernah dikerjakan siswa ini
    final riwayat = app.riwayatSiswaSaatIni;
    final kuisBelum = app.kuisList
        .where((k) => !riwayat.any((h) => h.kuisId == k.id))
        .toList();

    // Antisipasi: nama kosong / hanya spasi
    final namaTrim = user.nama.trim();
    final namaDepan = namaTrim.isEmpty ? 'Siswa' : namaTrim.split(RegExp(r'\s+')).first;
    final kelas = (user.kelas ?? '').trim();
    final infoKelas = kelas.isEmpty ? 'Semester Ganjil 2026' : '$kelas • Semester Ganjil 2026';

    return Scaffold(
      body: SafeArea(
        top: false, // header biru menembus sampai status bar
        child: CustomScrollView(
          slivers: [
            // ===== HEADER BIRU (sudah berisi kartu statistik) =====
            SliverToBoxAdapter(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.blue, AppColors.blueDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Lingkaran dekoratif kanan atas
                      Positioned(
                        top: -50,
                        right: -40,
                        child: Container(
                          width: 170,
                          height: 170,
                          decoration: const BoxDecoration(
                            color: Colors.white10,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          20,
                          MediaQuery.of(context).padding.top + 18,
                          20,
                          22,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.white24,
                                      child: Text(
                                        user.initials,
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Halo,', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                          Text(
                                            '$namaDepan!',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                                ),
                                const SizedBox(width: 8),
                                _BellButton(count: tugasRemedial == null ? 0 : 1),
                              ],
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              'Terus tingkatkan kemampuan TIK-mu 🚀',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              infoKelas,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white70, fontSize: 12.5),
                            ),
                            const SizedBox(height: 18),
                            // ===== 3 KARTU STATISTIK di dalam area biru =====
                            Row(
                              children: [
                                Expanded(child: _StatCard(value: '$totalMateri', label: 'Materi')),
                                const SizedBox(width: 10),
                                Expanded(child: _StatCard(value: '$totalKuis', label: 'Kuis Tersedia')),
                                const SizedBox(width: 10),
                                Expanded(child: _StatCard(value: '$pct%', label: 'Progres')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ===== KONTEN =====
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  if (tugasRemedial != null)
                    NoticeBox(
                      title: 'Remedial Ditugaskan Guru',
                      color: AppColors.red,
                      background: AppColors.redLight,
                      borderColor: const Color(0xFFF6C6C8),
                      message:
                          'Nilai kamu (${tugasRemedial.nilai}) pada ${tugasRemedial.kuis} belum mencapai KKM (${tugasRemedial.kkm}). Gurumu menugaskan kamu mengerjakan ulang kuis ini.',
                      action: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
                          onPressed: () {
                            final kuis = app.kuisById(tugasRemedial.kuisId);
                            if (kuis == null) {
                              // Antisipasi: kuis sudah dihapus guru
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Kuis remedial tidak ditemukan.')),
                              );
                              return;
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => KuisPlayScreen(kuis: kuis, remedialOfId: tugasRemedial.id),
                              ),
                            );
                          },
                          icon: const Icon(Icons.trending_up, size: 18),
                          label: const Text('Kerjakan Remedial Sekarang'),
                        ),
                      ),
                    ),
                  // ===== BAGIAN 1: MATERI BELUM DIPELAJARI =====
                  SectionTitle(
                    'Belum Dipelajari',
                    linkText: 'Lihat Semua',
                    onLinkTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SiswaMateriScreen()),
                    ),
                  ),
                  if (materiBelum.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: Center(
                        child: Text(
                          totalMateri == 0
                              ? 'Belum ada materi.'
                              : 'Semua materi sudah dipelajari 🎉',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.muted),
                        ),
                      ),
                    )
                  else
                    ...materiBelum.map(
                      (m) => AppListItem(
                        icon: Icons.picture_as_pdf_rounded,
                        iconColor: AppColors.red,
                        iconBg: AppColors.redLight,
                        title: '${m.bab} — ${m.judul}',
                        subtitle:
                            '${m.pdfName}${m.ukuran.isNotEmpty ? ' • ${m.ukuran}' : ''}',
                        trailing: const Icon(Icons.chevron_right, color: AppColors.muted, size: 20),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => MateriDetailScreen(materiId: m.id)),
                        ),
                      ),
                    ),

                  // ===== BAGIAN 2: KUIS BELUM DIKERJAKAN =====
                  SectionTitle(
                    'Belum Dikerjakan',
                    linkText: 'Lihat Semua',
                    onLinkTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const KuisLevelScreen()),
                    ),
                  ),
                  if (kuisBelum.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: Center(
                        child: Text(
                          totalKuis == 0
                              ? 'Belum ada kuis.'
                              : 'Semua kuis sudah dikerjakan 🎉',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.muted),
                        ),
                      ),
                    )
                  else
                    ...kuisBelum.map(
                      (k) => AppListItem(
                        icon: Icons.quiz_rounded,
                        iconColor: AppColors.orange,
                        iconBg: AppColors.orange.withOpacity(0.12),
                        title: k.judul,
                        subtitle: '${k.soal.length} soal • ${k.level}',
                        trailing: const Icon(Icons.chevron_right, color: AppColors.muted, size: 20),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => KuisPlayScreen(kuis: k)),
                        ),
                      ),
                    ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kartu putih statistik (Materi / Kuis Tersedia / Progres)
class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10.5, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class _BellButton extends StatelessWidget {
  final int count;
  const _BellButton({required this.count});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const NotifikasiScreen()),
      ),
      child: Stack(clipBehavior: Clip.none, children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 20),
        ),
        if (count > 0)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(color: AppColors.red, shape: BoxShape.circle),
            ),
          ),
      ]),
    );
  }
}