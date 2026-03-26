import 'package:flutter/material.dart';

abstract final class SynorAssets {
  static const logo = 'assets/images/brand/logo.jpg';
  static const noise = 'assets/textures/noise.svg';
  static const synorLogoDark = 'assets/images/branding/synor_logo_dark.svg';
  static const synorLogoLight = 'assets/images/branding/synor_logo_light.svg';
  static const bekooWordmarkDark =
      'assets/images/branding/bekoo_wordmark_dark.svg';
  static const bekooWordmarkLight =
      'assets/images/branding/bekoo_wordmark_light.svg';

  static const campusCover = 'assets/images/covers/campus.jpg';
  static const libraryCover = 'assets/images/covers/library.jpg';
  static const graduationCover = 'assets/images/covers/graduation.jpg';
  static const architectureCover = 'assets/images/covers/architecture.jpg';
  static const abstractTechCover = 'assets/images/covers/abstract-tech.jpg';
  static const scienceCover = 'assets/images/covers/science.jpg';

  static const nuraliAvatar = 'assets/images/avatars/nurali.jpg';
  static const aruzhanAvatar = 'assets/images/avatars/aruzhan.jpg';
  static const diasAvatar = 'assets/images/avatars/dias.jpg';
  static const madinaAvatar = 'assets/images/avatars/madina.jpg';
  static const studentAvatar = 'assets/images/avatars/student.jpg';

  static String synorLogoForBrightness(Brightness brightness) {
    return brightness == Brightness.dark ? synorLogoLight : synorLogoDark;
  }

  static String bekooWordmarkForBrightness(Brightness brightness) {
    return brightness == Brightness.dark
        ? bekooWordmarkLight
        : bekooWordmarkDark;
  }
}
