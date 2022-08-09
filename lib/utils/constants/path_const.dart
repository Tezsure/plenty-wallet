class PathConst {
  static const ASSETS = "assets/";
  static const SVG = "assets/svg/";
  static const IMAGES = "assets/images";

  static const HOME_PAGE = "assets/home_page/";
  static const SETTINGS_PAGE = "assets/settings_page/";
}

extension PathExt on String {
  String get SVG => this + "svg/";
  String get IMAGES => this + "images/";
  String get RIVE => this + "rive/";

}
