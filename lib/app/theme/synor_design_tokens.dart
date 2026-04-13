import 'package:flutter/material.dart';

abstract final class SynorColors {
  static const appBlack = Color(0xFF050505);
  static const surfaceBlack = Color(0xFF0A0A0A);
  static const deepBlack = Color(0xFF111111);
  static const panelBlack = Color(0xFF1A1A1A);

  static const lightBackground = Color(0xFFF8FAFC);
  static const lightSurface = Colors.white;
  static const lightSurfaceMuted = Color(0xFFF1F5F9);

  static const slate900 = Color(0xFF0F172A);
  static const slate800 = Color(0xFF1E293B);
  static const slate700 = Color(0xFF334155);
  static const slate600 = Color(0xFF475569);
  static const slate500 = Color(0xFF64748B);
  static const slate400 = Color(0xFF94A3B8);
  static const slate300 = Color(0xFFCBD5E1);
  static const slate200 = Color(0xFFE2E8F0);
  static const slate100 = Color(0xFFF1F5F9);
  static const slate50 = Color(0xFFF8FAFC);

  static const neutral200 = Color(0xFFE5E5E5);
  static const neutral300 = Color(0xFFD4D4D4);
  static const neutral400 = Color(0xFFA3A3A3);
  static const neutral500 = Color(0xFF737373);
  static const neutral600 = Color(0xFF525252);
  static const neutral700 = Color(0xFF404040);
  static const neutral800 = Color(0xFF262626);

  static const indigo50 = Color(0xFFEEF2FF);
  static const indigo100 = Color(0xFFE0E7FF);
  static const indigo200 = Color(0xFFC7D2FE);
  static const indigo300 = Color(0xFFA5B4FC);
  static const indigo400 = Color(0xFF818CF8);
  static const indigo500 = Color(0xFF6366F1);
  static const indigo600 = Color(0xFF4F46E5);
  static const indigo700 = Color(0xFF4338CA);
  static const indigo900 = Color(0xFF312E81);
  static const indigo950 = Color(0xFF1E1B4B);

  static const violet400 = Color(0xFFA78BFA);
  static const violet500 = Color(0xFF8B5CF6);
  static const violet600 = Color(0xFF7C3AED);

  static const blue400 = Color(0xFF60A5FA);
  static const blue500 = Color(0xFF3B82F6);
  static const blue600 = Color(0xFF2563EB);

  static const rose50 = Color(0xFFFFF1F2);
  static const rose100 = Color(0xFFFFE4E6);
  static const rose200 = Color(0xFFFECDD3);
  static const rose300 = Color(0xFFFDA4AF);
  static const rose400 = Color(0xFFFB7185);
  static const rose500 = Color(0xFFF43F5E);
  static const rose600 = Color(0xFFE11D48);
  static const rose700 = Color(0xFFBE123C);
  static const rose900 = Color(0xFF881337);

  static const emerald50 = Color(0xFFECFDF5);
  static const emerald100 = Color(0xFFD1FAE5);
  static const emerald200 = Color(0xFFA7F3D0);
  static const emerald300 = Color(0xFF6EE7B7);
  static const emerald400 = Color(0xFF34D399);
  static const emerald500 = Color(0xFF10B981);
  static const emerald600 = Color(0xFF059669);
  static const emerald900 = Color(0xFF064E3B);

  static const amber50 = Color(0xFFFFFBEB);
  static const amber100 = Color(0xFFFEF3C7);
  static const amber400 = Color(0xFFFBBF24);
  static const amber500 = Color(0xFFF59E0B);
  static const amber600 = Color(0xFFD97706);

  static const yellow400 = Color(0xFFFACC15);
  static const yellow500 = Color(0xFFEAB308);

  static const cyan500 = Color(0xFF06B6D4);
  static const cyan600 = Color(0xFF0891B2);

  static const purple50 = Color(0xFFFAF5FF);
  static const purple500 = Color(0xFFA855F7);
  static const purple600 = Color(0xFF9333EA);

  static const teal600 = Color(0xFF0D9488);

  static const white5 = Color(0x0DFFFFFF);
  static const white8 = Color(0x14FFFFFF);
  static const white10 = Color(0x1AFFFFFF);
  static const white15 = Color(0x26FFFFFF);
  static const white20 = Color(0x33FFFFFF);
  static const white40 = Color(0x66FFFFFF);
  static const white50 = Color(0x80FFFFFF);
  static const white60 = Color(0x99FFFFFF);
  static const white80 = Color(0xCCFFFFFF);

  static const black10 = Color(0x1A000000);
  static const black30 = Color(0x4D000000);
  static const black40 = Color(0x66000000);
  static const black60 = Color(0x99000000);
}

abstract final class SynorGradients {
  static const authButton = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [SynorColors.indigo600, SynorColors.violet600],
  );

  static const activePill = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      SynorColors.slate800,
      SynorColors.surfaceBlack,
      SynorColors.indigo950,
    ],
  );

  static const glassDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [SynorColors.white8, SynorColors.white5],
  );

  static const serviceBalance = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [SynorColors.emerald500, SynorColors.teal600],
  );

  static const profileSignal = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [SynorColors.indigo50, SynorColors.purple50],
  );
  static const destructive = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Colors.redAccent, Colors.red],
  );
}

abstract final class SynorSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const xxxl = 32.0;
}

abstract final class SynorRadii {
  static const xl = 16.0;
  static const xxl = 20.0;
  static const card = 24.0;
  static const cardLarge = 28.0;
  static const sheet = 32.0;
  static const cover = 40.0;
}

abstract final class SynorTypography {
  static const bodyFamily = null;
  static const supportFamily = 'Inter';
  static const logoFamily = 'HoltwoodOneSC';
}

abstract final class SynorIconSizes {
  static const tiny = 14.0;
  static const small = 16.0;
  static const medium = 20.0;
  static const large = 24.0;
  static const xl = 28.0;
}

abstract final class SynorMotion {
  static const fast = Duration(milliseconds: 200);
  static const medium = Duration(milliseconds: 300);
  static const slow = Duration(milliseconds: 500);
  static const theme = Duration(milliseconds: 280);
  static const page = Duration(milliseconds: 260);
  static const overlay = Duration(milliseconds: 240);
  static const Curve themeCurve = Curves.easeOutCubic;
  static const Curve pageCurve = Curves.easeOutCubic;
  static const Curve pageOutCurve = Curves.easeInCubic;
}

abstract final class SynorShadows {
  static const soft = [
    BoxShadow(
      color: Color(0x0F0F172A),
      blurRadius: 12,
      spreadRadius: -4,
      offset: Offset(0, 3),
    ),
  ];

  static const medium = [
    BoxShadow(
      color: Color(0x120F172A),
      blurRadius: 16,
      spreadRadius: -5,
      offset: Offset(0, 5),
    ),
  ];

  static const heavy = [
    BoxShadow(
      color: Color(0x160F172A),
      blurRadius: 24,
      spreadRadius: -8,
      offset: Offset(0, 10),
    ),
  ];

  static const lightPill = [
    BoxShadow(
      color: Color(0x140F172A),
      blurRadius: 8,
      spreadRadius: -3,
      offset: Offset(0, 2),
    ),
  ];

  static const lightNav = [
    BoxShadow(
      color: Color(0x100F172A),
      blurRadius: 18,
      spreadRadius: -4,
      offset: Offset(0, 4),
    ),
  ];

  static const lightIndigoGlow = [
    BoxShadow(
      color: Color(0x1F4F46E5),
      blurRadius: 10,
      spreadRadius: -1,
      offset: Offset(0, 3),
    ),
  ];

  static const indigoGlow = [
    BoxShadow(color: Color(0x4D4F46E5), blurRadius: 28, spreadRadius: 0),
  ];

  static const storyPurpleGlow = [
    BoxShadow(color: Color(0x4D9333EA), blurRadius: 15, spreadRadius: 0),
  ];

  static const storyRoseGlow = [
    BoxShadow(color: Color(0x4DF43F5E), blurRadius: 15, spreadRadius: 0),
  ];

  static const storyEmeraldGlow = [
    BoxShadow(color: Color(0x4D10B981), blurRadius: 15, spreadRadius: 0),
  ];

  static const storyCyanGlow = [
    BoxShadow(color: Color(0x4D06B6D4), blurRadius: 15, spreadRadius: 0),
  ];

  static const storyYellowGlow = [
    BoxShadow(color: Color(0x4DEAB308), blurRadius: 15, spreadRadius: 0),
  ];
}

abstract final class SynorBlur {
  static const ambient = 120.0;
  static const strong = 24.0;
  static const medium = 16.0;
  static const light = 8.0;
  static const subtle = 4.0;
}
