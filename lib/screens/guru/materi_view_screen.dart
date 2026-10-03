import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import 'materi_form_screen.dart';

class MateriViewScreen extends StatelessWidget {
  final String materiId;
  const MateriViewScreen({super.key, required this.materiId});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final m = app.materiById(materiId);
    if (m == null) {
      return const Scaffold(body: Center(child: Text('Materi tidak ditemukan')));
    }

    return Scaffold(
      appBar: simpleAppBar(m.bab),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          children: [
            Text(m.judul, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            const SizedBox(height: 3),
            Text('${m.pdfName}${m.ukuran.isNotEmpty ? ' • ${m.ukuran}' : ''}',
                style: const TextStyle(fontSize: 12, color: AppColors.muted)),
            const SizedBox(height: 12),
            Container(
              height: 260,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(kRadius),
                border: Border.all(color: AppColors.border),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.picture_as_pdf_rounded, color: AppColors.red, size: 36),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(m.isi,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 11.5, color: AppColors.muted),
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.open_in_new_rounded, size: 17),
                  label: const Text('Buka Penuh'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MateriFormScreen(materiId: m.id))),
                  icon: const Icon(Icons.edit_outlined, size: 17),
                  label: const Text('Edit'),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
