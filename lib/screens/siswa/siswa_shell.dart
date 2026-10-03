import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../shared/profil_screen.dart';
import 'siswa_home_screen.dart';
import 'siswa_materi_screen.dart';
import 'kuis_level_screen.dart';
import 'siswa_nilai_screen.dart';

/// Bingkai (shell) dengan bottom navigation untuk akun Siswa,
/// setara `bottomNav()` pada prototipe untuk role siswa.
class SiswaShell extends StatefulWidget {
  const SiswaShell({super.key});

  @override
  State<SiswaShell> createState() => _SiswaShellState();
}

class _SiswaShellState extends State<SiswaShell> {
  int index = 0;

  final pages = const [
    SiswaHomeScreen(),
    SiswaMateriScreen(),
    KuisLevelScreen(),
    SiswaNilaiScreen(),
    ProfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        backgroundColor: AppColors.card,
        indicatorColor: AppColors.blueLight,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Beranda'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'Materi'),
          NavigationDestination(icon: Icon(Icons.quiz_outlined), selectedIcon: Icon(Icons.quiz), label: 'Kuis'),
          NavigationDestination(icon: Icon(Icons.bar_chart_outlined), selectedIcon: Icon(Icons.bar_chart), label: 'Nilai'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
