class PathConst {
  static const ASSETS = "assets/";
  static const SVG = "assets/svg/";
  static const IMAGES = "assets/images";

  static const HOME_PAGE = "assets/HOME_PAGE/";
  static const SETTINGS_PAGE = "assets/SETTINGS_PAGE/";
}

extension PathExt on String {
  String get SVG => this + "svg/";
  String get IMAGES => this + "images/";
  String get RIVE => this + "rive/";

}
