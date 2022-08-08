import 'package:custom_slider/custom_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naan_wallet/app/modules/custom_packages/animated_scroll_indicator/effects/indicator_effects.dart';
import 'package:naan_wallet/app/modules/custom_packages/animated_scroll_indicator/smooth_page_indicator.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class LiquidityBakingWidget extends StatelessWidget {
  final bool add = true;
  final bool activeButton = false;
  const LiquidityBakingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.92.width,
      decoration: BoxDecoration(
        color: ColorConst.Tertiary,
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
            image: AssetImage(
              PathConst.HOME_PAGE.IMAGES + "coins_background.png",
            ),
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter),
      ),
      child: Column(
        children: [
          0.075.vspace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Earn ",
                style: headlineMedium.apply(color: Colors.black),
              ),
              Text(
                "31% APR",
                style: headlineMedium.apply(color: Colors.black),
              ),
            ],
          ),
          // Tab(
          //       height: 32,
          //       child: SizedBox(
          //         width: 82,
          //         child: Center(child: Text("Add")),
          //       ),
          //     ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "on your ",
                style: headlineMedium.apply(color: Colors.black),
              ),
              SvgPicture.asset(
                PathConst.HOME_PAGE.SVG + "xtz.svg",
                color: Colors.black,
              )
            ],
          ),
          0.027.vspace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IntrinsicWidth(
                child: SizedBox(
                  height: 67,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.black,
                    cursorWidth: 1,
                    textAlign: TextAlign.end,
                    textAlignVertical: TextAlignVertical.center,
                    style: headlineLarge.apply(color: Colors.black),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "0.00",
                      hintStyle: headlineLarge.apply(
                          color: ColorConst.Tertiary.shade60),
                    ),
                  ),
                ),
              ),
              0.03.hspace,
              SvgPicture.asset(
                PathConst.HOME_PAGE.SVG + "xtz.svg",
                color: Colors.black,
                height: 34,
              ),
            ],
          ),
          0.015.vspace,
          Text(
            "${true ? "SIRS" : "Available SIRS"}:${0}",
            style: labelSmall.apply(color: Colors.black),
          ),
          0.005.vspace,
          Text(
            "1 XTZ (\$.1.56) = 0.00007278 SIRS",
            style: labelSmall.apply(color: Colors.black),
          ),
          gradientSlider(),
          0.03.vspace,
          MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            height: 40,
            color: activeButton ? Colors.black : ColorConst.Tertiary.shade90,
            child: SizedBox(
              width: 0.75.width,
              child: Center(
                child: Text(
                  add ? "Get Sirius" : "Remove Liquidity",
                  style: labelSmall.apply(
                      color: activeButton
                          ? Colors.white
                          : ColorConst.Tertiary.shade80),
                ),
              ),
            ),
            elevation: 0,
            onPressed: () {},
          ),
          0.038.vspace,
        ],
      ),
    );
  }
}

class gradientSlider extends StatefulWidget {
  const gradientSlider({
    Key? key,
  }) : super(key: key);

  @override
  State<gradientSlider> createState() => _gradientSliderState();
}

class _gradientSliderState extends State<gradientSlider> {
  double value = 0;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        showValueIndicator: ShowValueIndicator.always,
        trackShape: GradientSliderTrackShape(
          linearGradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0),
              Colors.white,
            ],
          ),
        ),
      ),
      child: Slider(
        value: value,
        onChanged: (val) {
          setState(() {
            value = val;
          });
        },
        max: 100,
        min: 0,
      ),
    );
  }
}

class RectangularIndicator extends Decoration {
  /// topRight radius of the indicator, default to 5.
  final double topRightRadius;

  /// topLeft radius of the indicator, default to 5.
  final double topLeftRadius;

  /// bottomRight radius of the indicator, default to 0.
  final double bottomRightRadius;

  /// bottomLeft radius of the indicator, default to 0
  final double bottomLeftRadius;

  /// Color of the indicator, default set to [Colors.black]
  final Color color;

  /// Horizontal padding of the indicator, default set to 0
  final double horizontalPadding;

  /// Vertical padding of the indicator, default set to 0
  final double verticalPadding;

  /// [PagingStyle] determines if the indicator should be fill or stroke, default to fill
  final PaintingStyle paintingStyle;

  /// StrokeWidth, used for [PaintingStyle.stroke], default set to 0
  final double strokeWidth;

  RectangularIndicator({
    this.topRightRadius = 5,
    this.topLeftRadius = 5,
    this.bottomRightRadius = 0,
    this.bottomLeftRadius = 0,
    this.color = Colors.black,
    this.horizontalPadding = 0,
    this.verticalPadding = 0,
    this.paintingStyle = PaintingStyle.fill,
    this.strokeWidth = 2,
  });
  @override
  _CustomPainter createBoxPainter([VoidCallback? onChanged]) {
    return new _CustomPainter(
      this,
      onChanged,
      bottomLeftRadius: bottomLeftRadius,
      bottomRightRadius: bottomRightRadius,
      color: color,
      horizontalPadding: horizontalPadding,
      topLeftRadius: topLeftRadius,
      topRightRadius: topRightRadius,
      verticalPadding: verticalPadding,
      paintingStyle: paintingStyle,
      strokeWidth: strokeWidth,
    );
  }
}

class _CustomPainter extends BoxPainter {
  final RectangularIndicator decoration;
  final double topRightRadius;
  final double topLeftRadius;
  final double bottomRightRadius;
  final double bottomLeftRadius;
  final Color color;
  final double horizontalPadding;
  final double verticalPadding;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  _CustomPainter(
    this.decoration,
    VoidCallback? onChanged, {
    required this.topRightRadius,
    required this.topLeftRadius,
    required this.bottomRightRadius,
    required this.bottomLeftRadius,
    required this.color,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.paintingStyle,
    required this.strokeWidth,
  }) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(horizontalPadding >= 0);
    assert(horizontalPadding < configuration.size!.width / 2,
        "Padding must be less than half of the size of the tab");
    assert(verticalPadding < configuration.size!.height / 2 &&
        verticalPadding >= 0);
    assert(strokeWidth >= 0 &&
        strokeWidth < configuration.size!.width / 2 &&
        strokeWidth < configuration.size!.height / 2);

    //offset is the position from where the decoration should be drawn.
    //configuration.size tells us about the height and width of the tab.
    Size mysize = Size(configuration.size!.width - (horizontalPadding * 2),
        configuration.size!.height - (2 * verticalPadding));

    Offset myoffset =
        Offset(offset.dx + (horizontalPadding), offset.dy + verticalPadding);
    final Rect rect = myoffset & mysize;
    final Paint paint = Paint();
    paint.color = color;
    paint.style = paintingStyle;
    paint.strokeWidth = 3;
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          rect,
          bottomRight: Radius.circular(bottomRightRadius),
          bottomLeft: Radius.circular(bottomLeftRadius),
          topLeft: Radius.circular(topLeftRadius),
          topRight: Radius.circular(topRightRadius),
        ),
        paint);
  }
}
