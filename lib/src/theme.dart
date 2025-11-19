import 'package:fldraw/src/breakpoints.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

final radius = 0.8;

ToastTheme toastTheme(BuildContext context, ThemeData theme) {
  final isDesktop = AppBreakpoints.isDesktop(context);
  final scaling = theme.scaling;

  return ToastTheme(
    toastConstraints: BoxConstraints(
      minWidth: 0,
      maxWidth: isDesktop ? double.infinity : 320 * scaling,
      minHeight: 0,
      maxHeight: isDesktop ? double.infinity : 320 * scaling,
    ),
    maxStackedEntries: 3,
    spacing: 8.0,
    collapsedScale: 0.9,
    collapsedOpacity: 1.0,
    entryOpacity: 0.0,
    expandingDuration: const Duration(milliseconds: 500),
    expandingCurve: Curves.easeOutCubic,
    expandMode: ExpandMode.expandOnHover,
  );
}

Typography typography(BuildContext context) => Typography.geist().copyWith(
  sans: () => TextStyle(fontFamily: 'TuriumSans'),
  small: () => TextStyle(
    fontFamily: 'TuriumSans',
    fontSize: AppBreakpoints.isDesktop(context) ? 14 : 12,
  ),
  base: () => TextStyle(
    fontFamily: 'TuriumSans',
    fontSize: AppBreakpoints.isDesktop(context) ? 16 : 14,
  ),
  normal: () => TextStyle(
    fontFamily: 'TuriumSans',
    fontSize: AppBreakpoints.isDesktop(context) ? 16 : 14,
    fontWeight: FontWeight.w400,
  ),
  medium: () => TextStyle(
    fontFamily: 'TuriumSans',
    fontSize: AppBreakpoints.isDesktop(context) ? 14 : 12,
    fontWeight: FontWeight.w500,
  ),
  bold: () => TextStyle(
    fontFamily: 'TuriumSans',
    fontSize: AppBreakpoints.isDesktop(context) ? 14 : 12,
    fontWeight: FontWeight.w600,
  ),
  inlineCode: () => const TextStyle(fontFamily: 'monospace', fontSize: 13),
);

ThemeData themeLight(BuildContext context) {
  return ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      background: Color(0xffffffff),
      foreground: Color(0xff09090b),
      card: Color(0xffffffff),
      cardForeground: Color(0xff09090b),
      popover: Color(0xffffffff),
      popoverForeground: Color(0xff09090b),
      primary: Color(0xFF081020),
      primaryForeground: Color(0xfff5f3ff),
      secondary: Color(0xfff4f4f4),
      secondaryForeground: Color(0xff18181b),
      muted: Color(0xfff4f4f4),
      mutedForeground: Color(0xff71717b),
      accent: Color(0xfff4f4f4),
      accentForeground: Color(0xff18181b),
      destructive: Color(0xffe7000b),
      destructiveForeground: Color(0xfff4f4f4),
      border: Color.fromRGBO(13, 13, 13, 0.1),
      input: Color(0xffe4e4e7),
      ring: Color(0xFF081020),
      chart1: Color(0xff10b981),
      chart2: Color(0xffef4444),
      chart3: Color(0xff009689),
      chart4: Color(0xffffb900),
      chart5: Color(0xfffe9a00),
      // sidebar: Color(0x80e9e9e9),
      sidebar: Color(0xffffffff),
      sidebarForeground: Color(0xff09090b),
      sidebarPrimary: Color(0xFF081020),
      sidebarPrimaryForeground: Color(0xfff5f3ff),
      sidebarAccent: Color(0xfff4f4f4),
      sidebarAccentForeground: Color(0xff18181b),
      sidebarBorder: Color(0xffe4e4e4),
      sidebarRing: Color(0xFF081020),
    ),
    radius: radius,
    typography: typography(context),
    surfaceOpacity: 0.8,
    surfaceBlur: 11,
  );
}

ThemeData themeDark(BuildContext context) {
  return ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      background: Color(0xff212121),
      foreground: Color(0xfffafafa),
      card: Color(0xff181818),
      cardForeground: Color(0xfffafafa),
      popover: Color(0xff181818),
      popoverForeground: Color(0xfffafafa),
      primary: Color(0xFFF0F5FD),
      primaryForeground: Color(0xFF18181B),
      secondary: Color(0xd9323232),
      secondaryForeground: Color(0xfffafafa),
      muted: Color(0xff272727),
      mutedForeground: Color(0xff9f9f9f),
      accent: Color(0xff272727),
      accentForeground: Color(0xfffafafa),
      destructive: Color(0xffff6467),
      destructiveForeground: Color(0xff272727),
      border: Color(0x1affffff),
      input: Color(0x26ffffff),
      ring: Color(0xFFF0F5FD),
      chart1: Color(0xff34d399),
      chart2: Color(0xfff87171),
      chart3: Color(0xff00bc7d),
      chart4: Color(0xffad46ff),
      chart5: Color(0xffff2056),
      sidebar: Color(0xff181818),
      sidebarForeground: Color(0xfffafafa),
      sidebarPrimary: Color(0xFFF0F5FD),
      sidebarPrimaryForeground: Color(0xfff5f3ff),
      sidebarAccent: Color(0xff272727),
      sidebarAccentForeground: Color(0xfffafafa),
      sidebarBorder: Color(0x1affffff),
      sidebarRing: Color(0xFFF0F5FD),
    ),
    radius: radius,
    typography: typography(context),
    surfaceOpacity: 0.6,
    surfaceBlur: 12,
  );
}
