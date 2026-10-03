import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Setara `.list-item` pada desain: baris ikon + judul + subjudul + chevron.
class AppListItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const AppListItem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        padding: const EdgeInsets.all(12),
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconColor, size: 21),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(fontSize: 11.5, color: AppColors.muted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 6),
            trailing ?? const Icon(Icons.chevron_right, color: AppColors.muted, size: 20),
          ],
        ),
      ),
    );
  }
}

/// AppBar sederhana dengan tombol kembali, setara `backHeader()`.
PreferredSizeWidget simpleAppBar(String title, {List<Widget>? actions}) {
  return AppBar(title: Text(title), actions: actions);
}

/// Kotak notifikasi kuning untuk info remedial, setara `.notice-box` / `.remedial-box`.
class NoticeBox extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color color;
  final Color background;
  final Color borderColor;
  final Widget? action;

  const NoticeBox({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.error_outline,
    this.color = const Color(0xFFB9701C),
    this.background = const Color(0xFFFFF1E2),
    this.borderColor = const Color(0xFFFCE3B8),
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(kRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 13)),
          ]),
          const SizedBox(height: 6),
          Text(message, style: const TextStyle(fontSize: 12.5, height: 1.5, color: Color(0xFF5B4A2E))),
          if (action != null) ...[const SizedBox(height: 10), action!],
        ],
      ),
    );
  }
}

/// Tampilan kosong (empty state), setara `.empty`.
class EmptyState extends StatelessWidget {
  final String text;
  const EmptyState({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Text(text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted, fontSize: 13)),
      ),
    );
  }
}

/// Section title dengan link opsional di kanan, setara `.section-title`.
class SectionTitle extends StatelessWidget {
  final String title;
  final String? linkText;
  final VoidCallback? onLinkTap;
  const SectionTitle(this.title, {super.key, this.linkText, this.onLinkTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5)),
          if (linkText != null)
            GestureDetector(
              onTap: onLinkTap,
              child: Text(linkText!,
                  style: const TextStyle(
                      color: AppColors.blue, fontWeight: FontWeight.w700, fontSize: 12.5)),
            ),
        ],
      ),
    );
  }
}

/// Dialog konfirmasi kustom, setara `askConfirm()` pada prototipe.
Future<bool> confirmDialog(BuildContext context, String message) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadius)),
      content: Text(message, style: const TextStyle(fontSize: 13.5, height: 1.55)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.red),
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Ya, Lanjutkan'),
        ),
      ],
    ),
  );
  return result ?? false;
}

void showAppToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.text,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 2),
    ),
  );
}

String fmtWaktu(int detik) {
  final d = detik.clamp(0, 1 << 30);
  final m = d ~/ 60;
  final s = d % 60;
  return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
}

