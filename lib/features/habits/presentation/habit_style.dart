import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

const habitIcons = <String, IconData>{
  'check': Icons.check_circle_outline,
  'water': Icons.water_drop_outlined,
  'book': Icons.menu_book_outlined,
  'walk': Icons.directions_walk,
  'run': Icons.directions_run,
  'meditate': Icons.self_improvement,
  'sleep': Icons.bedtime_outlined,
  'food': Icons.restaurant_outlined,
  'heart': Icons.favorite_outline,
  'star': Icons.star_outline,
};

IconData habitIcon(String key) => habitIcons[key] ?? Icons.check_circle_outline;

const habitColorKeys = <String>[
  'hayati',
  'sea',
  'dawn',
  'dusk',
  'blossom',
  'ink',
];

Color habitColor(String key) {
  return switch (key) {
    'sea' => const Color(0xFF0369A1),
    'dawn' => const Color(0xFFD97706),
    'dusk' => const Color(0xFF4F46E5),
    'blossom' => const Color(0xFFE11D48),
    'ink' => const Color(0xFF334155),
    _ => const Color(0xFF10B981),
  };
}

/// A two-stop gradient from [color] toward a lighter, slightly shifted hue.
LinearGradient habitGradient(Color color) {
  final hsl = HSLColor.fromColor(color);
  final light = hsl
      .withHue((hsl.hue + 18) % 360)
      .withLightness((hsl.lightness + 0.14).clamp(0, 0.8))
      .toColor();
  return LinearGradient(
    begin: AlignmentDirectional.topStart,
    end: AlignmentDirectional.bottomEnd,
    colors: [light, color],
  );
}

/// A rounded tile with the habit icon on its gradient.
class HabitBadge extends StatelessWidget {
  const HabitBadge({
    required this.icon,
    required this.colorKey,
    this.size = 44,
    super.key,
  });

  final String icon;
  final String colorKey;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = habitColor(colorKey);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: habitGradient(color),
        borderRadius: BorderRadius.circular(size * 0.32),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.28),
            blurRadius: size * 0.25,
            offset: Offset(0, size * 0.1),
          ),
        ],
      ),
      child: Icon(habitIcon(icon), color: Colors.white, size: size * 0.52),
    );
  }
}

String habitColorLabel(AppLocalizations l10n, String key) {
  return switch (key) {
    'sea' => l10n.themeSea,
    'dawn' => l10n.themeDawn,
    'dusk' => l10n.themeDusk,
    'blossom' => l10n.themeBlossom,
    'ink' => l10n.themeInk,
    _ => l10n.themeHayati,
  };
}
