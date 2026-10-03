import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import 'materi_detail_screen.dart';

class SiswaMateriScreen extends StatelessWidget {
  const SiswaMateriScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    return Scaffold(
      appBar: simpleAppBar('Materi Pembelajaran'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          children: [
            const Text('Pilih bab materi untuk mulai belajar TIK dasar.',
                style: TextStyle(fontSize: 12.5, color: AppColors.muted)),
            const SizedBox(height: 14),
            ...app.materiList.map((m) => AppListItem(
                  icon: Icons.picture_as_pdf_rounded,
                  iconColor: AppColors.red,
                  iconBg: AppColors.redLight,
                  title: '${m.bab} — ${m.judul}',
                  subtitle: '${m.pdfName}${m.ukuran.isNotEmpty ? ' • ${m.ukuran}' : ''}',
                  trailing: app.isMateriSelesai(m.id)
                      ? const Icon(Icons.check_circle, color: AppColors.green, size: 20)
                      : const Icon(Icons.chevron_right, color: AppColors.muted, size: 20),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MateriDetailScreen(materiId: m.id))),
                )),
          ],
        ),
      ),
    );
  }
}
