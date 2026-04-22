import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light({
    String themeKey = 'foodwin',
    String? primaryColorHex,
    String? accentColorHex,
  }) {
    final palette = _paletteFor(
      themeKey: themeKey,
      primaryColorHex: primaryColorHex,
      accentColorHex: accentColorHex,
    );
    final base = ThemeData(
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: palette.primary,
            brightness: Brightness.light,
          ).copyWith(
            primary: palette.primary,
            secondary: palette.accent,
            surface: palette.surface,
          ),
      scaffoldBackgroundColor: palette.scaffold,
      useMaterial3: true,
    );

    final textTheme = GoogleFonts.dmSansTextTheme(base.textTheme).copyWith(
      displayLarge: GoogleFonts.dmSerifDisplay(
        fontSize: 52,
        fontWeight: FontWeight.w400,
        color: palette.heading,
      ),
      displayMedium: GoogleFonts.dmSerifDisplay(
        fontSize: 34,
        fontWeight: FontWeight.w400,
        color: palette.heading,
      ),
      headlineMedium: GoogleFonts.dmSerifDisplay(
        fontSize: 26,
        fontWeight: FontWeight.w400,
        color: palette.heading,
      ),
      titleLarge: GoogleFonts.dmSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: palette.heading,
      ),
      bodyLarge: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: palette.body,
      ),
      bodyMedium: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: palette.bodyMuted,
      ),
    );

    return base.copyWith(
      textTheme: textTheme,
      extensions: [StoreThemeTokens._fromPalette(palette)],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: palette.heading),
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: palette.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: palette.accent, width: 1.2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.accent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: palette.accent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        side: BorderSide(color: palette.border),
        selectedColor: palette.primary.withValues(alpha: 0.12),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: palette.primary.withValues(alpha: 0.12),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: palette.accent);
          }

          return IconThemeData(color: palette.bodyMuted);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          return textTheme.labelMedium?.copyWith(
            color: states.contains(WidgetState.selected)
                ? palette.accent
                : palette.bodyMuted,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w600,
          );
        }),
      ),
    );
  }

  static _ThemePalette _paletteFor({
    required String themeKey,
    String? primaryColorHex,
    String? accentColorHex,
  }) {
    final defaults = switch (themeKey) {
      'jansa' => const _ThemePalette(
        primary: Color(0xFF8E4A61),
        accent: Color(0xFF26415F),
        scaffold: Color(0xFFF8F3F6),
        surface: Color(0xFFFFFCFD),
        heading: Color(0xFF231B21),
        body: Color(0xFF433640),
        bodyMuted: Color(0xFF6B5A66),
        border: Color(0xFFE5D7DF),
      ),
      'ygold' => const _ThemePalette(
        primary: Color(0xFFB98A2F),
        accent: Color(0xFF3D2E12),
        scaffold: Color(0xFFFAF5E9),
        surface: Color(0xFFFFFDF8),
        heading: Color(0xFF241B10),
        body: Color(0xFF433729),
        bodyMuted: Color(0xFF6E6253),
        border: Color(0xFFEADFC8),
      ),
      'nova' => const _ThemePalette(
        primary: Color(0xFF2E72B8),
        accent: Color(0xFF1C3A5A),
        scaffold: Color(0xFFF4F8FC),
        surface: Color(0xFFFBFDFF),
        heading: Color(0xFF172331),
        body: Color(0xFF304152),
        bodyMuted: Color(0xFF5A6B7C),
        border: Color(0xFFD9E4F0),
      ),
      _ => const _ThemePalette(
        primary: Color(0xFFB45C2F),
        accent: Color(0xFF204F46),
        scaffold: Color(0xFFF8F2EA),
        surface: Color(0xFFFFFCF8),
        heading: Color(0xFF1E1A16),
        body: Color(0xFF3A342F),
        bodyMuted: Color(0xFF5C554F),
        border: Color(0xFFE8DDD1),
      ),
    };

    final primary = _parseHexColor(primaryColorHex) ?? defaults.primary;
    final accent = _parseHexColor(accentColorHex) ?? defaults.accent;

    return defaults.copyWith(primary: primary, accent: accent);
  }

  static Color? _parseHexColor(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }

    final normalized = raw.replaceAll('#', '').trim();
    if (normalized.length != 6) {
      return null;
    }

    final value = int.tryParse('FF$normalized', radix: 16);
    if (value == null) {
      return null;
    }

    return Color(value);
  }
}

class StoreThemeTokens extends ThemeExtension<StoreThemeTokens> {
  const StoreThemeTokens({
    required this.heroGradientStart,
    required this.heroGradientEnd,
    required this.heroOverlayStrong,
    required this.heroOverlaySoft,
    required this.onHero,
    required this.onHeroMuted,
    required this.softSurface,
    required this.softSurfaceAlt,
    required this.imagePlaceholder,
    required this.indicatorActive,
    required this.indicatorInactive,
    required this.categoryFallback,
    required this.danger,
    required this.dangerSoft,
  });

  static StoreThemeTokens _fromPalette(_ThemePalette palette) {
    return StoreThemeTokens(
      heroGradientStart: palette.accent,
      heroGradientEnd: palette.primary,
      heroOverlayStrong: palette.heading.withValues(alpha: 0.58),
      heroOverlaySoft: palette.accent.withValues(alpha: 0.18),
      onHero: Colors.white,
      onHeroMuted: Colors.white.withValues(alpha: 0.78),
      softSurface: palette.primary.withValues(alpha: 0.1),
      softSurfaceAlt: palette.surface,
      imagePlaceholder: Color.alphaBlend(
        palette.primary.withValues(alpha: 0.14),
        palette.surface,
      ),
      indicatorActive: palette.accent,
      indicatorInactive: palette.border,
      categoryFallback: Color.alphaBlend(
        palette.primary.withValues(alpha: 0.55),
        palette.accent.withValues(alpha: 0.45),
      ),
      danger: const Color(0xFF8D3A2C),
      dangerSoft: const Color(0xFFF6E7E2),
    );
  }

  final Color heroGradientStart;
  final Color heroGradientEnd;
  final Color heroOverlayStrong;
  final Color heroOverlaySoft;
  final Color onHero;
  final Color onHeroMuted;
  final Color softSurface;
  final Color softSurfaceAlt;
  final Color imagePlaceholder;
  final Color indicatorActive;
  final Color indicatorInactive;
  final Color categoryFallback;
  final Color danger;
  final Color dangerSoft;

  @override
  StoreThemeTokens copyWith({
    Color? heroGradientStart,
    Color? heroGradientEnd,
    Color? heroOverlayStrong,
    Color? heroOverlaySoft,
    Color? onHero,
    Color? onHeroMuted,
    Color? softSurface,
    Color? softSurfaceAlt,
    Color? imagePlaceholder,
    Color? indicatorActive,
    Color? indicatorInactive,
    Color? categoryFallback,
    Color? danger,
    Color? dangerSoft,
  }) {
    return StoreThemeTokens(
      heroGradientStart: heroGradientStart ?? this.heroGradientStart,
      heroGradientEnd: heroGradientEnd ?? this.heroGradientEnd,
      heroOverlayStrong: heroOverlayStrong ?? this.heroOverlayStrong,
      heroOverlaySoft: heroOverlaySoft ?? this.heroOverlaySoft,
      onHero: onHero ?? this.onHero,
      onHeroMuted: onHeroMuted ?? this.onHeroMuted,
      softSurface: softSurface ?? this.softSurface,
      softSurfaceAlt: softSurfaceAlt ?? this.softSurfaceAlt,
      imagePlaceholder: imagePlaceholder ?? this.imagePlaceholder,
      indicatorActive: indicatorActive ?? this.indicatorActive,
      indicatorInactive: indicatorInactive ?? this.indicatorInactive,
      categoryFallback: categoryFallback ?? this.categoryFallback,
      danger: danger ?? this.danger,
      dangerSoft: dangerSoft ?? this.dangerSoft,
    );
  }

  @override
  StoreThemeTokens lerp(ThemeExtension<StoreThemeTokens>? other, double t) {
    if (other is! StoreThemeTokens) {
      return this;
    }

    return StoreThemeTokens(
      heroGradientStart:
          Color.lerp(heroGradientStart, other.heroGradientStart, t) ??
          heroGradientStart,
      heroGradientEnd:
          Color.lerp(heroGradientEnd, other.heroGradientEnd, t) ??
          heroGradientEnd,
      heroOverlayStrong:
          Color.lerp(heroOverlayStrong, other.heroOverlayStrong, t) ??
          heroOverlayStrong,
      heroOverlaySoft:
          Color.lerp(heroOverlaySoft, other.heroOverlaySoft, t) ??
          heroOverlaySoft,
      onHero: Color.lerp(onHero, other.onHero, t) ?? onHero,
      onHeroMuted: Color.lerp(onHeroMuted, other.onHeroMuted, t) ?? onHeroMuted,
      softSurface: Color.lerp(softSurface, other.softSurface, t) ?? softSurface,
      softSurfaceAlt:
          Color.lerp(softSurfaceAlt, other.softSurfaceAlt, t) ?? softSurfaceAlt,
      imagePlaceholder:
          Color.lerp(imagePlaceholder, other.imagePlaceholder, t) ??
          imagePlaceholder,
      indicatorActive:
          Color.lerp(indicatorActive, other.indicatorActive, t) ??
          indicatorActive,
      indicatorInactive:
          Color.lerp(indicatorInactive, other.indicatorInactive, t) ??
          indicatorInactive,
      categoryFallback:
          Color.lerp(categoryFallback, other.categoryFallback, t) ??
          categoryFallback,
      danger: Color.lerp(danger, other.danger, t) ?? danger,
      dangerSoft: Color.lerp(dangerSoft, other.dangerSoft, t) ?? dangerSoft,
    );
  }
}

extension StoreThemeContext on BuildContext {
  StoreThemeTokens get storeTheme =>
      Theme.of(this).extension<StoreThemeTokens>() ??
      StoreThemeTokens._fromPalette(
        const _ThemePalette(
          primary: Color(0xFFB45C2F),
          accent: Color(0xFF204F46),
          scaffold: Color(0xFFF8F2EA),
          surface: Color(0xFFFFFCF8),
          heading: Color(0xFF1E1A16),
          body: Color(0xFF3A342F),
          bodyMuted: Color(0xFF5C554F),
          border: Color(0xFFE8DDD1),
        ),
      );
}

class _ThemePalette {
  const _ThemePalette({
    required this.primary,
    required this.accent,
    required this.scaffold,
    required this.surface,
    required this.heading,
    required this.body,
    required this.bodyMuted,
    required this.border,
  });

  final Color primary;
  final Color accent;
  final Color scaffold;
  final Color surface;
  final Color heading;
  final Color body;
  final Color bodyMuted;
  final Color border;

  _ThemePalette copyWith({
    Color? primary,
    Color? accent,
    Color? scaffold,
    Color? surface,
    Color? heading,
    Color? body,
    Color? bodyMuted,
    Color? border,
  }) {
    return _ThemePalette(
      primary: primary ?? this.primary,
      accent: accent ?? this.accent,
      scaffold: scaffold ?? this.scaffold,
      surface: surface ?? this.surface,
      heading: heading ?? this.heading,
      body: body ?? this.body,
      bodyMuted: bodyMuted ?? this.bodyMuted,
      border: border ?? this.border,
    );
  }
}
