import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/user.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserRole selectedRole = UserRole.siswa;
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  void _isiDariAkun(String email, String password, UserRole role) {
    setState(() {
      selectedRole = role;
      emailCtrl.text = email;
      passCtrl.text = password;
    });
  }

  void _login() {
    final app = context.read<AppProvider>();
    final err = app.login(emailCtrl.text, passCtrl.text);
    if (err != null) {
      showAppToast(context, err);
    }
    // Navigasi otomatis ditangani oleh AuthGate lewat Consumer<AppProvider>.
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    // Hanya akun siswa & guru yang relevan untuk aplikasi mobile ini.
    final akunDemo = app.users.where((u) => u.role == UserRole.siswa || u.role == UserRole.guru);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.blueLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.menu_book_rounded, color: AppColors.blue, size: 30),
                    ),
                    const SizedBox(height: 14),
                    const Text('Edukasi TIK',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    const Text('Belajar Keterampilan TIK, Kapan Saja',
                        style: TextStyle(color: AppColors.muted, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const Text('Masuk sebagai',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _RoleCard(
                      icon: Icons.menu_book_rounded,
                      label: 'Siswa',
                      color: AppColors.blue,
                      active: selectedRole == UserRole.siswa,
                      onTap: () => setState(() => selectedRole = UserRole.siswa),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _RoleCard(
                      icon: Icons.emoji_events_rounded,
                      label: 'Guru',
                      color: AppColors.green,
                      active: selectedRole == UserRole.guru,
                      onTap: () => setState(() => selectedRole = UserRole.guru),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Email atau Nama Lengkap',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
              const SizedBox(height: 6),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(hintText: 'nama@sekolah.sch.id atau nama lengkap'),
              ),
              const SizedBox(height: 14),
              const Text('Kata Sandi', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
              const SizedBox(height: 6),
              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: const InputDecoration(hintText: 'Kata sandi'),
              ),
              const SizedBox(height: 18),
              ElevatedButton(onPressed: _login, child: const Text('Masuk')),
              const SizedBox(height: 24),
              const Text('Akun Demo',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
              const SizedBox(height: 4),
              const Text(
                'Tap salah satu akun untuk mengisi form otomatis. Sandi semua akun: 123456.',
                style: TextStyle(fontSize: 11.5, color: AppColors.muted),
              ),
              const SizedBox(height: 10),
              ...akunDemo.map((u) {
                final isGuru = u.role == UserRole.guru;
                return AppListItem(
                  icon: isGuru ? Icons.school_rounded : Icons.person_rounded,
                  iconColor: isGuru ? AppColors.green : AppColors.blue,
                  iconBg: isGuru ? AppColors.greenLight : AppColors.blueLight,
                  title: u.nama,
                  subtitle: u.kelas == null ? u.email : '${u.email} • ${u.kelas}',
                  trailing: AppPill(
                    label: isGuru ? 'Guru' : 'Siswa',
                    color: isGuru ? AppColors.green : AppColors.blue,
                    background: isGuru ? AppColors.greenLight : AppColors.blueLight,
                  ),
                  onTap: () => _isiDariAkun(u.email, u.password, u.role),
                );
              }),
              const SizedBox(height: 18),
              const Divider(),
              const SizedBox(height: 14),
              Center(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 13, color: AppColors.muted),
                    children: [
                      const TextSpan(text: 'Belum punya akun? '),
                      TextSpan(
                        text: 'Daftar di sini',
                        style: const TextStyle(color: AppColors.blue, fontWeight: FontWeight.w700),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const RegisterScreen()),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool active;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: active ? color.withOpacity(.08) : AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: active ? color : AppColors.border, width: active ? 1.6 : 1),
        ),
        child: Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: active ? Colors.white : AppColors.bg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
          ],
        ),
      ),
    );
  }
}
