import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/user.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import '../shared/notifikasi_screen.dart';
import 'guru_validasi_screen.dart';
import 'materi_kelola_screen.dart';
import 'kuis_kelola_screen.dart';

class GuruHomeScreen extends StatelessWidget {
  const GuruHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final user = app.currentUser;

    // Antisipasi: user belum ter-load / sudah logout
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final pending = app.menungguValidasi.length;
    // CATATAN: "+ 2" dari kode aslimu dipertahankan (sepertinya penyesuaian data dummy).
    // Hapus kalau jumlah siswa sudah diambil sepenuhnya dari data asli.
    final totalSiswa = app.users.where((u) => u.role == UserRole.siswa).length + 2;
    final totalKuis = app.kuisList.length;
    final totalMateri = app.materiList.length;

    // Antisipasi: nama kosong
    final nama = user.nama.trim().isEmpty ? 'Guru' : user.nama.trim();

    return Scaffold(
      body: SafeArea(
        top: false, // header hijau menembus sampai status bar
        child: CustomScrollView(
          slivers: [
            // ===== HEADER HIJAU (sudah berisi kartu statistik) =====
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
                      colors: [AppColors.green, Color(0xFF0D8F55)],
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
                                          const Text('Dashboard', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                          Text(
                                            nama,
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
                                _BellButton(showDot: pending > 0),
                              ],
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              'Pantau perkembangan siswa Anda',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Guru Pengampu TIK',
                              style: TextStyle(color: Colors.white70, fontSize: 12.5),
                            ),
                            const SizedBox(height: 18),
                            // ===== 3 KARTU STATISTIK di dalam area hijau =====
                            Row(
                              children: [
                                Expanded(child: _StatCard(value: '$totalSiswa', label: 'Siswa')),
                                const SizedBox(width: 10),
                                Expanded(child: _StatCard(value: '$totalKuis', label: 'Kuis')),
                                const SizedBox(width: 10),
                                Expanded(child: _StatCard(value: '$pending', label: 'Perlu Validasi')),
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
                  const SectionTitle('Kelola'),
                  AppListItem(
                    icon: Icons.fact_check_rounded,
                    iconColor: AppColors.green,
                    iconBg: AppColors.greenLight,
                    title: 'Validasi Nilai Siswa',
                    subtitle: '$pending nilai menunggu validasi',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GuruValidasiScreen()),
                    ),
                  ),
                  AppListItem(
                    icon: Icons.picture_as_pdf_rounded,
                    iconColor: AppColors.red,
                    iconBg: AppColors.redLight,
                    title: 'Kelola Materi',
                    subtitle: '$totalMateri materi PDF tersedia',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MateriKelolaScreen()),
                    ),
                  ),
                  AppListItem(
                    icon: Icons.quiz_rounded,
                    iconColor: AppColors.orange,
                    iconBg: AppColors.orangeLight,
                    title: 'Kelola Kuis',
                    subtitle: '$totalKuis kuis dapat diedit atau dihapus',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const KuisKelolaScreen()),
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

/// Kartu putih statistik (Siswa / Kuis / Perlu Validasi)
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
  final bool showDot;
  const _BellButton({required this.showDot});

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
        if (showDot)
          const Positioned(
            top: -2,
            right: -2,
            child: CircleAvatar(radius: 5, backgroundColor: AppColors.red),
          ),
      ]),
    );
  }
}
