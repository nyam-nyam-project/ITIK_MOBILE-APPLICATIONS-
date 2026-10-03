import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/a11y_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';

class A11ySettingsScreen extends StatelessWidget {
  const A11ySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final a11y = context.watch<A11yProvider>();

    return Scaffold(
      appBar: simpleAppBar('Aksesibilitas'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          children: [
            // ---------------- Ukuran Teks ----------------
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ukuran Teks', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5)),
                  const SizedBox(height: 4),
                  const Text('Perbesar teks pada halaman agar lebih mudah dibaca.',
                      style: TextStyle(fontSize: 12, color: AppColors.muted)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: A11yProvider.opsiUkuran.map((o) {
                      final active = a11y.fontScale == o['v'];
                      return ChoiceChip(
                        label: Text(o['label'] as String),
                        selected: active,
                        onSelected: (_) => a11y.setFontScale(o['v'] as double),
                        selectedColor: AppColors.blue,
                        labelStyle: TextStyle(color: active ? Colors.white : AppColors.text, fontWeight: FontWeight.w700, fontSize: 12),
                        backgroundColor: AppColors.bg,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ---------------- Kontras Tinggi ----------------
            AppCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mode Kontras Tinggi', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5)),
                        SizedBox(height: 4),
                        Text('Kombinasi hitam-kuning untuk pengguna low vision.',
                            style: TextStyle(fontSize: 12, color: AppColors.muted)),
                      ],
                    ),
                  ),
                  Switch(value: a11y.highContrast, onChanged: (_) => a11y.toggleContrast(), activeColor: AppColors.blue),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ---------------- Pembaca Layar (TTS) ----------------
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pembaca Layar (Text-to-Speech)',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5)),
                  const SizedBox(height: 4),
                  const Text(
                    'Dengarkan isi halaman ini dibacakan oleh sistem, cocok untuk pengguna tunanetra/low vision.',
                    style: TextStyle(fontSize: 12, color: AppColors.muted),
                  ),
                  const SizedBox(height: 12),

                  // Tombol: tinggi seragam, teks tidak terpotong
                  Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          button: true,
                          label: 'Baca halaman ini dengan suara',
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () => a11y.speakPage(),
                            icon: const Icon(Icons.volume_up_rounded, size: 18),
                            label: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text('Baca Halaman',
                                  maxLines: 1, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Semantics(
                          button: true,
                          label: 'Hentikan pembacaan',
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () => a11y.stopSpeaking(),
                            icon: const Icon(Icons.stop_rounded, size: 18),
                            label: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text('Hentikan',
                                  maxLines: 1, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),
                  const Divider(height: 1),
                  const SizedBox(height: 10),

                  // Baca otomatis saat pindah halaman
                  Row(
                    children: [
                      const Expanded(
                        child: Text('Baca Otomatis Saat Pindah Halaman',
                            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                      ),
                      const SizedBox(width: 8),
                      Semantics(
                        label: 'Baca otomatis saat pindah halaman',
                        toggled: a11y.autoRead,
                        child: Switch(
                          value: a11y.autoRead,
                          onChanged: (_) => a11y.toggleAutoRead(),
                          activeColor: AppColors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ---------------- Navigasi Keyboard & Screen Reader ----------------
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Navigasi Keyboard & Screen Reader',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5)),
                  const SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                      style: const TextStyle(fontSize: 12, color: AppColors.muted, height: 1.6),
                      children: const [
                        TextSpan(text: 'Gunakan tombol '),
                        TextSpan(text: 'Tab', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.text)),
                        TextSpan(text: ' untuk berpindah antar tombol/menu, dan '),
                        TextSpan(text: 'Enter', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.text)),
                        TextSpan(text: ' atau '),
                        TextSpan(text: 'Spasi', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.text)),
                        TextSpan(
                          text: ' untuk memilihnya. Setiap tombol dan ikon pada aplikasi ini memiliki label '
                              'yang dapat dibacakan oleh pembaca layar seperti TalkBack (Android), '
                              'VoiceOver (iOS/Mac), dan NVDA (Windows).',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ---------------- Reset ----------------
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.red,
                side: const BorderSide(color: AppColors.redLight),
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () async {
                final ok = await confirmDialog(context, 'Kembalikan semua pengaturan aksesibilitas ke default?');
                if (ok) a11y.reset();
              },
              child: const Text('Reset ke Pengaturan Default'),
            ),
          ],
        ),
      ),
    );
  }
}