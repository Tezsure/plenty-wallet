// ignore_for_file: constant_identifier_names, non_constant_identifier_names

class PathConst {
  static const ASSETS = "assets/";
  static const SVG = "assets/svg/";
  static const IMAGES = "assets/images";
  static const LOTTIE = "assets/lottie/";

  static const HOME_PAGE = "assets/home_page/";
  static const SETTINGS_PAGE = "assets/settings_page/";
  static const TOKEN_PAGE = "assets/token_send/";
}

extension PathExt on String {
  String get SVG => "${this}svg/";
  String get IMAGES => "${this}images/";
}
