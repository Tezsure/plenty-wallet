import 'package:flutter/material.dart';

final LinearGradient background = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xff2D2447),
    Color(0xff402A2C),
  ],
);

final LinearGradient appleBlue = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xff5267B7),
    Color(0xff3851AD),
  ],
);

final LinearGradient appleGreen = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xff66c169),
    Color(0xff59B955),
  ],
);

final LinearGradient appleOrange = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xffed8b6f),
    Color(0xffeb7b5b),
  ],
);

final LinearGradient appleYellow = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xfff4be41),
    Color(0xfff6c543),
  ],
);

final LinearGradient applePurple = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xff7f5cb3),
    Color(0xff664298),
  ],
);

final LinearGradient appleBlack = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xff1D1D1F),
    Color(0xff1C1C1D),
  ],
);

final Color grey = Color(0xffA4A3A9);
final Color blue = Color(0xff3F9AF7);
final Color textGrey1 = Color(0xff8D8D8D);

final Color x = Colors.amberAccent;

class GradientConst {
  GradientConst._();

  final LinearGradient GradientBackground = LinearGradient(
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
  static const int _Primary = 0xFFF44336;
  static const int _Secondary = 0xFFF44336;
  static const int _Tertiary = 0xFFF44336;
  static const int _Error = 0xFFF44336;
  static const int _Neutral = 0xFFF44336;
  static const int _NeutralVariant = 0xFFF44336;
  static const int _Orange = 0xFFF44336;
  static const int _NaanRed = 0xFFF44336;

  static const MaterialColor Primary = MaterialColor(
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

  static const MaterialColor Secondary = MaterialColor(
    _Secondary,
    <int, Color>{},
  );
  static const MaterialColor Tertiary = MaterialColor(
    _Tertiary,
    <int, Color>{},
  );
  static const MaterialColor Error = MaterialColor(
    _Error,
    <int, Color>{},
  );
  static const MaterialColor Neutral = MaterialColor(
    _Neutral,
    <int, Color>{},
  );
  static const MaterialColor NeutralVariant = MaterialColor(
    _NeutralVariant,
    <int, Color>{},
  );
  static const MaterialColor Orange = MaterialColor(
    _Orange,
    <int, Color>{},
  );
  static const MaterialColor NaanRed = MaterialColor(
    _NaanRed,
    <int, Color>{},
  );
}
