import 'package:flutter/material.dart';

LinearGradient background = const LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xff2D2447),
    Color(0xff402A2C),
  ],
);

LinearGradient appleBlue = const LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xff5267B7),
    Color(0xff3851AD),
  ],
);

LinearGradient appleGreen = const LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xff66c169),
    Color(0xff59B955),
  ],
);

LinearGradient appleOrange = const LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xffed8b6f),
    Color(0xffeb7b5b),
  ],
);

LinearGradient appleYellow = const LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xfff4be41),
    Color(0xfff6c543),
  ],
);

LinearGradient applePurple = const LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xff7f5cb3),
    Color(0xff664298),
  ],
);

LinearGradient appleBlack = const LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xff1D1D1F),
    Color(0xff1C1C1D),
  ],
);

final Color x = Colors.amberAccent;
Color primary = const Color(0xff8637EB);
Color secondary = const Color(0xffFF006E);
Color tertiary = const Color(0xffFFBE0C);
Color error = const Color(0xffBA1A1A);
Color neutral = const Color(0xff07030C);
Color neutralVariant = const Color(0xff625C66);
Color orange = const Color(0xffFB5507);
Color naanRed = const Color(0xffFF3334);
Color grey = const Color(0xffA4A3A9);
Color blue = const Color(0xff3F9AF7);
Color textGrey1 = const Color(0xff8D8D8D);


class GradConst {
  GradConst._();

  static const LinearGradient GradientBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xff07030C),
      Color(0xff2D004F),
    ],
  );
}

class ColorConst {
  ColorConst._();
  static const int _Primary = 0xFF8637EB;
  static const int _Secondary = 0xFFFF006E;
  static const int _Tertiary = 0xFFFFBE0C;
  static const int _Error = 0xFFBA1A1A;
  static const int _Neutral = 0xFF07030C;
  static const int _NeutralVariant = 0xFF07030C;
  static const int _Orange = 0xFFFB5507;
  static const int _NaanRed = 0xFFFF3334;

  static const NaaNShadesColor Primary = NaaNShadesColor(
    _Primary,
    <int, Color>{
      0: Color(0xFF000000),
      10: Color(0xFF280056),
      20: Color(0xFF440088),
      30: Color(0xFF6100BE),
      40: Color(0xFF7C29E1),
      50: Color(0xFF964AFB),
      60: Color(0xFFAC72FF),
      70: Color(0xFFC197FF),
      80: Color(0xFFD7BAFF),
      90: Color(0xFFEDDCFF),
      95: Color(0xFFF8EDFF),
      99: Color(0xFFFFFBFF),
      100: Color(0xFFFFFFFF),
    },
  );

  static const NaaNShadesColor Secondary = NaaNShadesColor(
    _Secondary,
    <int, Color>{
      0: Color(0xFF000000),
      10: Color(0xFF3F0016),
      20: Color(0xFF660028),
      30: Color(0xFF90003B),
      40: Color(0xFFBC004F),
      50: Color(0xFFEA0064),
      60: Color(0xFFFF4D80),
      70: Color(0xFFFF86A0),
      80: Color(0xFFFFB2BF),
      90: Color(0xFFFFD9DE),
      95: Color(0xFFFFECEE),
      99: Color(0xFFFFFBFF),
      100: Color(0xFFFFFFFF),
    },
  );
  static const NaaNShadesColor Tertiary = NaaNShadesColor(
    _Tertiary,
    <int, Color>{
      0: Color(0xFF000000),
      10: Color(0xff261900),
      20: Color(0XFF402D00),
      30: Color(0XFF5C4200),
      40: Color(0XFF7A5900),
      50: Color(0XFF997000),
      60: Color(0XFFB98900),
      70: Color(0XFFDAA200),
      80: Color(0XFFFCBC06),
      90: Color(0XFFFFDEA2),
      95: Color(0XFFFFEFD5),
      99: Color(0XFFFFFBFF),
      100: Color(0XFFFFFFFF),
    },
  );
  static const NaaNShadesColor Error = NaaNShadesColor(
    _Error,
    <int, Color>{
      0: Color(0xFF000000),
      10: Color(0xFF410002),
      20: Color(0XFF690005),
      30: Color(0XFF93000A),
      40: Color(0XFFBA1A1A),
      50: Color(0XFFDE3730),
      60: Color(0XFFFF5449),
      70: Color(0XFFFF897D),
      80: Color(0XFFFFB4AB),
      90: Color(0XFFFFDAD6),
      95: Color(0XFFFFEDEA),
      99: Color(0XFFFFFBFF),
      100: Color(0XFFFFFFFF),
    },
  );
  static const NaaNShadesColor Neutral = NaaNShadesColor(
    _Neutral,
    <int, Color>{
      0: Color(0xFF000000),
      10: Color(0XFF2D004F),
      20: Color(0XFF451969),
      30: Color(0XFF5D3282),
      40: Color(0XFF764B9C),
      50: Color(0XFF9064B7),
      60: Color(0XFFAB7DD2),
      70: Color(0XFFC798EF),
      80: Color(0XFFDFB7FF),
      90: Color(0XFFF1DAFF),
      95: Color(0XFFFAECFF),
      99: Color(0XFFFFFBFF),
      100: Color(0XFFFFFFFF),
    },
  );
  static const NaaNShadesColor NeutralVariant = NaaNShadesColor(
    _NeutralVariant,
    <int, Color>{
      0: Color(0XFF000000),
      10: Color(0XFF1E1A22),
      20: Color(0XFF332F37),
      30: Color(0XFF4A454E),
      40: Color(0XFF625C66),
      50: Color(0XFF7B757F),
      60: Color(0XFF958E99),
      70: Color(0XFFB0A9B3),
      80: Color(0XFFCBC4CF),
      90: Color(0XFFE8E0EB),
      95: Color(0XFFF6EEF9),
      99: Color(0XFFFFFBFF),
      100: Color(0XFFFFFFFF),
    },
  );
  static const NaaNShadesColor Orange = NaaNShadesColor(
    _Orange,
    <int, Color>{
      0: Color(0xFF000000),
      10: Color(0XFF390C00),
      20: Color(0XFF5C1900),
      30: Color(0XFF822700),
      40: Color(0XFFAB3600),
      50: Color(0XFFD54500),
      60: Color(0XFFFF580C),
      70: Color(0XFFFF8B63),
      80: Color(0XFFFFB59C),
      90: Color(0XFFFFDBCF),
      95: Color(0XFFFFDBCF),
      99: Color(0XFFFFFBFF),
      100: Color(0XFFFFFFFF),
    },
  );
  static const NaaNShadesColor NaanRed = NaaNShadesColor(
    _NaanRed,
    <int, Color>{
      0: Color(0xFF000000),
      10: Color(0XFF410003),
      20: Color(0XFF690007),
      30: Color(0XFF93000E),
      40: Color(0XFFC00016),
      50: Color(0XFFE92027),
      60: Color(0XFFFF544C),
      70: Color(0XFFFF897F),
      80: Color(0XFFFFB4AC),
      90: Color(0XFFFFDAD6),
      95: Color(0XFFFFEDEA),
      99: Color(0XFFFFFBFF),
      100: Color(0XFFFFFFFF),
    },
  );
}

class NaaNShadesColor extends ColorSwatch<int> {
  const NaaNShadesColor(int primary, Map<int, Color> swatch)
      : super(primary, swatch);
  Color get shade0 => this[0]!;
  Color get shade10 => this[10]!;
  Color get shade20 => this[20]!;
  Color get shade30 => this[30]!;
  Color get shade40 => this[40]!;
  Color get shade50 => this[50]!;
  Color get shade60 => this[60]!;
  Color get shade70 => this[70]!;
  Color get shade80 => this[80]!;
  Color get shade90 => this[90]!;
  Color get shade95 => this[95]!;
  Color get shade99 => this[99]!;
  Color get shade100 => this[100]!;
}

