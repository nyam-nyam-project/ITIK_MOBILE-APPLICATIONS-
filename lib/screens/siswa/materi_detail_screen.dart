import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';

class MateriDetailScreen extends StatelessWidget {
  final String materiId;
  const MateriDetailScreen({super.key, required this.materiId});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final m = app.materiById(materiId);
    if (m == null) {
      return const Scaffold(body: Center(child: Text('Materi tidak ditemukan')));
    }
    final done = app.isMateriSelesai(m.id);

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
            AppCard(
              child: Text(m.deskripsi, style: const TextStyle(fontSize: 13, height: 1.6, color: AppColors.muted)),
            ),
            const SizedBox(height: 12),
            // Placeholder pratinjau PDF — sambungkan ke viewer PDF (mis. paket
            // `flutter_pdfview` / `syncfusion_flutter_pdfviewer`) saat file materi
            // sudah datang dari backend.
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(kRadius),
                border: Border.all(color: AppColors.border),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.picture_as_pdf_rounded, color: AppColors.red, size: 34),
                  const SizedBox(height: 8),
                  Text(m.isi, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11.5, color: AppColors.muted), maxLines: 4, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.open_in_new_rounded, size: 18),
              label: const Text('Buka PDF Layar Penuh'),
            ),
            const SizedBox(height: 12),
            if (done)
              AppCard(
                color: AppColors.greenLight,
                borderColor: AppColors.greenLight,
                child: const Center(
                  child: Text('✔ Progres materi ini sudah tercatat selesai',
                      style: TextStyle(color: AppColors.green, fontWeight: FontWeight.w800, fontSize: 13.5)),
                ),
              )
            else
              ElevatedButton(
                onPressed: () {
                  app.submitProgresMateri(m.id);
                  showAppToast(context, 'Progres berhasil disimpan ✔');
                },
                child: const Text('Submit Progres Belajar'),
              ),
          ],
        ),
      ),
    );
  }
}
