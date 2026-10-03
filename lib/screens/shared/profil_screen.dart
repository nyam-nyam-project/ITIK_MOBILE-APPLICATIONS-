import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/user.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import 'a11y_settings_screen.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final user = app.currentUser!;
    final roleLabel = user.role == UserRole.siswa ? 'Siswa' : 'Guru Pengampu TIK';
    final color = RoleColors.of(user.role.value);

    return Scaffold(
      appBar: simpleAppBar('Profil'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          children: [
            AppCard(
              padding: const EdgeInsets.symmetric(vertical: 22),
              child: Column(children: [
                CircleAvatar(radius: 32, backgroundColor: color, child: Text(user.initials, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800))),
                const SizedBox(height: 10),
                Text(user.nama, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(user.email, style: const TextStyle(fontSize: 12.5, color: AppColors.muted)),
                const SizedBox(height: 8),
                AppPill(label: roleLabel, color: color, background: color.withOpacity(.12)),
              ]),
            ),
            const SizedBox(height: 16),
            AppCard(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              child: Column(children: [
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(backgroundColor: AppColors.bg, foregroundColor: AppColors.muted, child: Icon(Icons.settings_outlined, size: 18)),
                  title: Text('Pengaturan Akun', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                ),
                const Divider(height: 1),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(backgroundColor: AppColors.blueLight, foregroundColor: AppColors.blue, child: Icon(Icons.accessibility_new_rounded, size: 18)),
                  title: const Text('Aksesibilitas', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                  subtitle: const Text('Ukuran teks, kontras, pembaca layar', style: TextStyle(fontSize: 11.5)),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.muted, size: 20),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const A11ySettingsScreen())),
                ),
              ]),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.redLight, foregroundColor: AppColors.red),
              onPressed: () => app.logout(),
              icon: const Icon(Icons.logout_rounded, size: 18),
              label: const Text('Keluar'),
            ),
          ],
        ),
      ),
    );
  }
}
