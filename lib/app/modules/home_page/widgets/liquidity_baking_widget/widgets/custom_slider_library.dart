import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:naan_wallet/utils/extensions/size_extension.dart';

class CustomRoundSliderThumbShape extends SliderComponentShape {
  /// Create a slider thumb that draws inner & outer circle with different radius & color.
  ///
  /// [innerCircleRadius] is the radius of the inner circle.
  /// [outerCircleRadius] is the radius of the outer circle.
  const CustomRoundSliderThumbShape({
    this.enabledThumbRadius = 10.0,
    this.disabledThumbRadius,
    this.elevation = 1.0,
    this.pressedElevation = 6.0,
    this.innerCircleColor = Colors.black,
    this.outerCircleColor = Colors.white,
    this.innerCircleRadius = 6,
    this.outerCircleRadius = 10,
  });

  final double innerCircleRadius;
  final double outerCircleRadius;
  final Color innerCircleColor;
  final Color outerCircleColor;
  final double enabledThumbRadius;
  final double? disabledThumbRadius;
  double get _disabledThumbRadius => disabledThumbRadius ?? enabledThumbRadius;
  final double elevation;
  final double pressedElevation;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(
        isEnabled == true ? enabledThumbRadius : _disabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    assert(sliderTheme.disabledThumbColor != null);
    assert(sliderTheme.thumbColor != null);

    final Canvas canvas = context.canvas;
    final Tween<double> radiusTween = Tween<double>(
      begin: _disabledThumbRadius,
      end: enabledThumbRadius,
    );

    final double radius = radiusTween.evaluate(enableAnimation);

    final Tween<double> elevationTween = Tween<double>(
      begin: elevation,
      end: pressedElevation,
    );

    final double evaluatedElevation =
        elevationTween.evaluate(activationAnimation);

    final Path path = Path()
      ..addArc(
          Rect.fromCenter(
              center: center, width: 2 * radius, height: 2 * radius),
          0,
          math.pi * 2);

    // Draws circle shadow
    canvas.drawShadow(path, Colors.black, evaluatedElevation, true);

    // Draws the outer circle
    canvas.drawCircle(
      center,
      outerCircleRadius,
      Paint()..color = outerCircleColor,
    );

    // Draws the inner circle
    canvas.drawCircle(
      center,
      innerCircleRadius,
      Paint()..color = innerCircleColor,
    );
  }
}

class GradientRectSliderTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  /// Create a slider track that draws two rectangles with outer edges with option for rounded edges.
  ///
  /// [trackBorderRadius] is the radius of the inActive Track borders.
  /// [activeTrackBorderRadius] is the radius of the Active Track borders.
  ///
  /// [linearGradientColorsList] is the list of colors to be used in the active slider gradient.
  ///
  /// [inActiveGradientColorsList] is the list of colors to be used in the inActive slider gradient.
  const GradientRectSliderTrackShape({
    this.trackBorderRadius = 0,
    this.activeTrackBorderRadius = 0,
    this.linearGradientColorsList,
    this.inActiveLinearGradientColorsList,
  });

  final List<Color>? linearGradientColorsList;
  final List<Color>? inActiveLinearGradientColorsList;
  final double trackBorderRadius;
  final double activeTrackBorderRadius;

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
  }) {
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    /// Active track gradient colors
    LinearGradient gradient = LinearGradient(
      colors: linearGradientColorsList ??
          [
            const Color(0xffFFD383).withOpacity(0.6),
            const Color(0xffFFD383).withOpacity(0.6),
            const Color(0xffFFFFFF).withOpacity(1),
            const Color(0xffFFFFFF).withOpacity(1),
          ],
    );

    LinearGradient inActiveGradient = LinearGradient(
      colors: inActiveLinearGradientColorsList ??
          [
            const Color(0xffFFD383).withOpacity(0.6),
            const Color(0xffFFFFFF).withOpacity(1),
          ],
    );

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final activeGradientRect = Rect.fromLTRB(
      trackRect.left,
      (textDirection == TextDirection.ltr)
          ? trackRect.top - (additionalActiveTrackHeight / 2)
          : trackRect.top,
      thumbCenter.dx,
      (textDirection == TextDirection.ltr)
          ? trackRect.bottom + (additionalActiveTrackHeight / 2)
          : trackRect.bottom,
    );

    final inActiveGradientRect = Rect.fromLTRB(
      trackRect.right,
      (textDirection == TextDirection.rtl)
          ? trackRect.bottom + (additionalActiveTrackHeight / 2)
          : trackRect.bottom,
      thumbCenter.dx,
      (textDirection == TextDirection.rtl)
          ? trackRect.top - (additionalActiveTrackHeight / 2)
          : trackRect.top,
    );

    // Assign the track segment paints, which are leading: active and
    // trailing: inactive.
    final ColorTween activeTrackColorTween = ColorTween(
        begin: sliderTheme.disabledActiveTrackColor,
        end: sliderTheme.activeTrackColor);
    final ColorTween inactiveTrackColorTween = ColorTween(
        begin: sliderTheme.disabledActiveTrackColor,
        end: sliderTheme.activeTrackColor);

    final Paint activePaint = Paint()
      ..shader = gradient.createShader(activeGradientRect)
      ..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final Paint inactivePaint = Paint()
      ..shader = inActiveGradient.createShader(inActiveGradientRect)
      ..color = inactiveTrackColorTween.evaluate(enableAnimation)!;
    final Paint leftTrackPaint;
    final Paint rightTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
        break;
    }

    Radius trackRadius = Radius.circular(trackBorderRadius);
    Radius activeTrackRadius = Radius.circular(activeTrackBorderRadius);

    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        0, // Sets the width of the left side of the track
        (textDirection ==
                TextDirection
                    .ltr) // Sets the height of the right side of the track, for same height as left side, use same [TextDirection.ltr/rtl]
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        thumbCenter.dx, // Thumb center offset
        (textDirection == TextDirection.ltr)
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        topLeft: (textDirection == TextDirection.ltr)
            ? activeTrackRadius
            : trackRadius,
        bottomLeft: (textDirection == TextDirection.ltr)
            ? activeTrackRadius
            : trackRadius,
      ),
      leftTrackPaint,
    );
    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        thumbCenter.dx, // Thumb center offset
        (textDirection ==
                TextDirection
                    .ltr) // Sets the height of the right side of the track, for same height as left side, use same [TextDirection.ltr/rtl]
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        0.92.width, // Sets the width of the left side of the track or use [trackRect.right] for dynamic width
        (textDirection == TextDirection.rtl)
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        topRight: (textDirection == TextDirection.rtl)
            ? activeTrackRadius
            : trackRadius,
        bottomRight: (textDirection == TextDirection.rtl)
            ? activeTrackRadius
            : trackRadius,
      ),
      rightTrackPaint,
    );
  }
}
