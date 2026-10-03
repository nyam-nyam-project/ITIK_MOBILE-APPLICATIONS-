import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../shared/profil_screen.dart';
import 'guru_home_screen.dart';
import 'materi_kelola_screen.dart';
import 'kuis_kelola_screen.dart';
import 'guru_validasi_screen.dart';

/// Bingkai (shell) dengan bottom navigation untuk akun Guru.
/// Guru berbagi layar kelola Materi & Kuis dengan yang dipakai operator di
/// prototipe asli (guru diberi akses penuh, sesuai perilaku SCREEN_ROLES
/// pada prototipe: `operatorMateri`/`operatorKuis` juga bisa diakses guru).
class GuruShell extends StatefulWidget {
  const GuruShell({super.key});

  @override
  State<GuruShell> createState() => _GuruShellState();
}

class _GuruShellState extends State<GuruShell> {
  int index = 0;

  final pages = const [
    GuruHomeScreen(),
    MateriKelolaScreen(),
    KuisKelolaScreen(),
    GuruValidasiScreen(),
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
        indicatorColor: AppColors.greenLight,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Beranda'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'Materi'),
          NavigationDestination(icon: Icon(Icons.quiz_outlined), selectedIcon: Icon(Icons.quiz), label: 'Kuis'),
          NavigationDestination(icon: Icon(Icons.assignment_outlined), selectedIcon: Icon(Icons.assignment), label: 'Nilai'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
