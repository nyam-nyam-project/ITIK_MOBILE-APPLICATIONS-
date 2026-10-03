import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/user.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  UserRole role = UserRole.siswa;
  final namaCtrl = TextEditingController();
  final kelasCtrl = TextEditingController(text: 'X TKJ 1');
  final indukCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final konfirmasiCtrl = TextEditingController();

  @override
  void dispose() {
    namaCtrl.dispose();
    kelasCtrl.dispose();
    indukCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    konfirmasiCtrl.dispose();
    super.dispose();
  }

  void _daftar() {
    final app = context.read<AppProvider>();
    final err = app.register(
      nama: namaCtrl.text,
      email: emailCtrl.text,
      password: passCtrl.text,
      konfirmasi: konfirmasiCtrl.text,
      role: role,
      kelas: kelasCtrl.text,
      induk: indukCtrl.text,
    );
    if (err != null) {
      showAppToast(context, err);
      return;
    }
    showAppToast(context, 'Akun berhasil dibuat, selamat datang ✔');
    Navigator.of(context).popUntil((r) => r.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar('Buat Akun Baru'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Daftar sebagai', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(
                  child: _RoleChoice(
                    icon: Icons.menu_book_rounded,
                    label: 'Siswa',
                    color: AppColors.blue,
                    active: role == UserRole.siswa,
                    onTap: () => setState(() => role = UserRole.siswa),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _RoleChoice(
                    icon: Icons.emoji_events_rounded,
                    label: 'Guru',
                    color: AppColors.green,
                    active: role == UserRole.guru,
                    onTap: () => setState(() => role = UserRole.guru),
                  ),
                ),
              ]),
              const SizedBox(height: 16),
              _label('Nama Lengkap'),
              TextField(controller: namaCtrl, decoration: const InputDecoration(hintText: 'Contoh: Andi Wirawan')),
              if (role == UserRole.siswa) ...[
                const SizedBox(height: 14),
                Row(children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      _label('Kelas'),
                      TextField(controller: kelasCtrl, decoration: const InputDecoration(hintText: 'X TKJ 1')),
                    ]),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      _label('NIS / No. Induk'),
                      TextField(controller: indukCtrl, decoration: const InputDecoration(hintText: 'E41250266')),
                    ]),
                  ),
                ]),
              ],
              const SizedBox(height: 14),
              _label('Email'),
              TextField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'nama@sekolah.sch.id'),
              ),
              const SizedBox(height: 14),
              Row(children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _label('Kata Sandi'),
                    TextField(
                        controller: passCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(hintText: 'Minimal 6 karakter')),
                  ]),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _label('Konfirmasi Sandi'),
                    TextField(
                        controller: konfirmasiCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(hintText: 'Ulangi kata sandi')),
                  ]),
                ),
              ]),
              const SizedBox(height: 18),
              ElevatedButton(onPressed: _daftar, child: const Text('Daftar & Masuk')),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Sudah punya akun? Masuk di sini'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String s) => Padding(
        padding: const EdgeInsets.only(bottom: 6, top: 2),
        child: Text(s, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
      );
}

class _RoleChoice extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool active;
  final VoidCallback onTap;
  const _RoleChoice({
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
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: active ? color.withOpacity(.08) : AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: active ? color : AppColors.border, width: active ? 1.6 : 1),
        ),
        child: Column(children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
        ]),
      ),
    );
  }
}
