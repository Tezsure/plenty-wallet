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

LinearGradient lightBlue = const LinearGradient(
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
  colors: [
    Color(0xff57C1FF),
    Color(0xff335EEA),
  ],
);

LinearGradient accountBg = LinearGradient(
  begin: Alignment.center,
  end: Alignment.bottomLeft,
  colors: [
    const Color(0xff8637EB),
    const Color(0xff460499).withOpacity(0.82),
  ],
);

LinearGradient appleRed = const LinearGradient(
  begin: Alignment.centerRight,
  end: Alignment.centerLeft,
  colors: [
    Color(0xffE6406F),
    Color(0xffFE0618),
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
    Color(0xFFFF006E),
    Color(0xFFFF580C),
  ],
);

LinearGradient appleYellow = const LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xffFFBE0C),
    Color(0xffE1A61B),
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

LinearGradient imagesGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    const Color(0xff000000).withOpacity(0),
    const Color(0xff373636).withOpacity(0.61),
  ],
);

LinearGradient blueGradient = const LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [
    Color(0xff034EC0),
    Color(0xff001768),
  ],
);

LinearGradient blueGradientLight = const LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [
    Color(0xff206DFF),
    Color(0xff0E61FF),
  ],
);

LinearGradient pinkGradient = const LinearGradient(
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
  colors: [
    Color(0xff493240),
    Color(0xffFF0099),
  ],
);

LinearGradient purpleGradient = const LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [
    Color(0xffFF006E),
    Color(0xff8637EB),
  ],
);

class GradConst {
  GradConst._();

  static const LinearGradient GradientBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment(0, 2), // Alignment.bottomCenter [Previously]
    colors: [
      Color(0xff07030C),
      Color(0xff2D004F),
    ],
  );
}

class ColorConst {
  ColorConst._();
  static const int _Primary = 0xFFFF006E;
  static const int _Secondary = 0xFF8637EB;
  static const int _Tertiary = 0xFFFFBE0C;
  static const int _Error = 0xFFBA1A1A;
  static const int _Neutral = 0xFF07030C;
  static const int _NeutralVariant = 0xFF07030C;
  static const int _Orange = 0xFFFB5507;
  static const int _NaanRed = 0xFFFF3334;

  static const Color textGrey1 = Color(0xff8D8D8D);
  static const Color lightGrey = Color(0xFFB0A9B3);
  static const Color grey = Color(0xffA4A3A9);
  static const Color blue = Color(0xff3F9AF7);
  static const Color green = Color(0xff7EFF3F);
  static const Color darkGrey = Color(0xff1E1C1F);
  static const Color naanCustomColor = Color(0xff5AE200);

  static const NaaNShadesColor Primary = NaaNShadesColor(
    _Primary,
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
      100: Color(0xFFFFFFFF)
    },
  );

  static const NaaNShadesColor Secondary = NaaNShadesColor(
    _Secondary,
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
      10: Color(0XFF421121),
      20: Color(0XFF761E3B),
      30: Color(0XFF802040),
      40: Color(0XFFB42D5A),
      50: Color(0XFFBF305F),
      60: Color(0XFFD65983),
      70: Color(0XFFD8648A),
      80: Color(0XFFE597B1),
      90: Color(0XFFE8A2B9),
      95: Color(0XFFF2CBD8),
      99: Color(0XFFFCF5F7),
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
