import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens diambil langsung dari prototipe HTML (variabel CSS :root)
/// supaya tampilan Flutter konsisten dengan desain asli.
class AppColors {
  static const blue = Color(0xFF2F6FED);
  static const blueLight = Color(0xFFE9F0FF);
  static const blueDark = Color(0xFF1F4FC4);

  static const green = Color(0xFF12B76A);
  static const greenLight = Color(0xFFE6F9F1);

  static const purple = Color(0xFF7C5CFC);
  static const purpleLight = Color(0xFFF1ECFF);

  static const orange = Color(0xFFFF9A3D);
  static const orangeLight = Color(0xFFFFF1E2);

  static const bg = Color(0xFFF3F5FA);
  static const card = Color(0xFFFFFFFF);
  static const text = Color(0xFF12172B);
  static const muted = Color(0xFF7A8194);
  static const border = Color(0xFFE9ECF5);

  static const red = Color(0xFFE5484D);
  static const redLight = Color(0xFFFDE8E8);
}

/// Warna per-role, dipakai untuk avatar, header beranda, dan badge peran.
class RoleColors {
  static Color of(String role) {
    switch (role) {
      case 'siswa':
        return AppColors.blue;
      case 'guru':
        return AppColors.green;
      default:
        return AppColors.purple;
    }
  }
}

const double kRadius = 18;
final kCardShadow = [
  BoxShadow(
    color: const Color(0xFF14163C).withOpacity(.08),
    blurRadius: 28,
    offset: const Offset(0, 12),
  ),
];

class AppTheme {
  static ThemeData light() {
    final base = ThemeData(useMaterial3: true, colorSchemeSeed: AppColors.blue);
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(base.textTheme).apply(
      bodyColor: AppColors.text,
      displayColor: AppColors.text,
    );
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.bg,
      textTheme: textTheme,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.blue,
        secondary: AppColors.purple,
        surface: AppColors.card,
        error: AppColors.red,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bg,
        foregroundColor: AppColors.text,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.text,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.3,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(50),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.blue,
          minimumSize: const Size.fromHeight(50),
          side: const BorderSide(color: AppColors.blueLight, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5),
          backgroundColor: Colors.white,
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 1, space: 1),
    );
  }
}

/// Kartu putih dengan radius & shadow standar sesuai `.card` pada desain asli.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Color? borderColor;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.borderColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? AppColors.card,
        borderRadius: BorderRadius.circular(kRadius),
        border: Border.all(color: borderColor ?? AppColors.border),
        boxShadow: color == null ? kCardShadow : null,
      ),
      child: child,
    );
    if (onTap == null) return content;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(kRadius),
      child: content,
    );
  }
}

/// Badge/pill kecil untuk status, level, dsb (`.pill` pada desain asli).
class AppPill extends StatelessWidget {
  final String label;
  final Color color;
  final Color background;
  const AppPill({super.key, required this.label, required this.color, required this.background});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(999)),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11.5, fontWeight: FontWeight.w700),
      ),
    );
  }
}

/// Pill level kesulitan kuis: Mudah / Sedang / Sulit.
class LevelPill extends StatelessWidget {
  final String level;
  const LevelPill({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    late Color fg, bg;
    switch (level) {
      case 'Mudah':
        fg = AppColors.green;
        bg = AppColors.greenLight;
        break;
      case 'Sedang':
        fg = const Color(0xFFB9701C);
        bg = const Color(0xFFFFF1E2);
        break;
      default:
        fg = AppColors.red;
        bg = AppColors.redLight;
    }
    return AppPill(label: level, color: fg, background: bg);
  }
}
