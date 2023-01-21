import 'dart:math';

import 'package:flutter/material.dart';

import '../painters/indicator_painter.dart';
import 'indicator_effects.dart';

class ScrollingDotsEffect extends BasicIndicatorEffect {
  /// The active dot strokeWidth
  /// this is ignored if [fixedCenter] is false
  final double activeStrokeWidth;

  /// [activeDotScale] is multiplied by [dotWidth] to resolve
  /// active dot scaling
  final double activeDotScale;

  /// The max number of dots to display at a time
  /// if count is <= [maxVisibleDots] [maxVisibleDots] = count
  /// must be an odd number that's >= 5
  final int maxVisibleDots;

  // if True the old center dot style will be used
  final bool fixedCenter;

  const ScrollingDotsEffect({
    this.activeStrokeWidth = 1.5,
    this.activeDotScale = 1.3,
    this.maxVisibleDots = 5,
    this.fixedCenter = false,
    double offset = 16.0,
    double dotWidth = 16.0,
    double dotHeight = 16.0,
    double spacing = 8.0,
    double radius = 16,
    Color dotColor = Colors.grey,
    Color activeDotColor = Colors.indigo,
    double strokeWidth = 1.0,
    PaintingStyle paintStyle = PaintingStyle.fill,
  })  : assert(activeDotScale >= 0.0),
        assert(maxVisibleDots >= 5 && maxVisibleDots % 2 != 0),
        super(
          dotWidth: dotWidth,
          dotHeight: dotHeight,
          spacing: spacing,
          radius: radius,
          strokeWidth: strokeWidth,
          paintStyle: paintStyle,
          dotColor: dotColor,
          activeDotColor: activeDotColor,
        );

  @override
  Size calculateSize(int count) {
    // Add the scaled dot width to our size calculation
    var width = (dotWidth + spacing) * (min(count, maxVisibleDots));
    if (fixedCenter && count <= maxVisibleDots) {
      width = ((count * 2) - 1) * (dotWidth + spacing);
    }
    return Size(width, dotHeight * activeDotScale);
  }

  @override
  int hitTestDots(double dx, int count, double current) {
    final switchPoint = (maxVisibleDots / 2).floor();
    if (fixedCenter) {
      return super.hitTestDots(dx, count, current) -
          switchPoint +
          current.floor();
    } else {
      final firstVisibleDot =
          (current < switchPoint || count - 1 < maxVisibleDots)
              ? 0
              : min(current - switchPoint, count - maxVisibleDots).floor();
      final lastVisibleDot =
          min(firstVisibleDot + maxVisibleDots, count - 1).floor();
      var offset = 0.0;
      for (var index = firstVisibleDot; index <= lastVisibleDot; index++) {
        if (dx <= (offset += dotWidth + spacing)) {
          return index;
        }
      }
    }
    return -1;
  }

  @override
  BasicIndicatorPainter buildPainter(int count, double offset) {
    // if (fixedCenter) {
    assert(
      offset.ceil() < count,
      'ScrollingDotsWithFixedCenterPainter does not support infinite looping.',
    );
    return ScrollingDotsWithFixedCenterPainter(
      count: count,
      offset: offset,
      effect: this,
    );
    // } else {
    // return ScrollingDotsPainter(
    //   count: count,
    //   offset: offset,
    //   effect: this,
    // );
    // }
  }
}

class ScrollingDotsWithFixedCenterPainter extends BasicIndicatorPainter {
  final ScrollingDotsEffect effect;

  ScrollingDotsWithFixedCenterPainter({
    required this.effect,
    required int count,
    required double offset,
  }) : super(offset, count, effect);

  @override
  void paint(Canvas canvas, Size size) {
    var current = offset.floor();
    var dotOffset = offset - current;
    var dotPaint = Paint()
      ..strokeWidth = effect.strokeWidth
      ..style = effect.paintStyle;

    for (var index = 0; index < count; index++) {
      var color = effect.dotColor;
      if (index == current) {
        // ! Both a and b are non nullable
        color = Color.lerp(effect.activeDotColor, effect.dotColor, dotOffset)!;
      } else if (index - 1 == current) {
        // ! Both a and b are non nullable
        color =
            Color.lerp(effect.activeDotColor, effect.dotColor, 1 - dotOffset)!;
      }

      var scale = 1.0;
      final smallDotScale = 0.66;
      final revDotOffset = 1 - dotOffset;
      final switchPoint = (effect.maxVisibleDots - 1) / 2;

      if (count > effect.maxVisibleDots) {
        if (index >= current - switchPoint &&
            index <= current + (switchPoint + 1)) {
          if (index == (current + switchPoint)) {
            scale = smallDotScale + ((1 - smallDotScale) * dotOffset);
          } else if (index == current - (switchPoint - 1)) {
            scale = 1 - (1 - smallDotScale) * dotOffset;
          } else if (index == current - switchPoint) {
            scale = (smallDotScale * revDotOffset);
          } else if (index == current + (switchPoint + 1)) {
            scale = (smallDotScale * dotOffset);
          }
        } else {
          continue;
        }
      }

      final rRect = _calcBounds(
        size.height,
        size.width / 2 - (offset * (effect.dotWidth + effect.spacing)),
        index,
        scale,
      );

      canvas.drawRRect(rRect, dotPaint..color = color);
    }

    final rRect =
        _calcBounds(size.height, size.width / 2, 0, effect.activeDotScale);
    canvas.drawRRect(
        rRect,
        Paint()
          ..color = effect.activeDotColor
          ..strokeWidth = effect.activeStrokeWidth
          ..style = PaintingStyle.stroke);
  }

  RRect _calcBounds(double canvasHeight, double startingPoint, num i,
      [double scale = 1.0]) {
    final scaledWidth = effect.dotWidth * scale;
    final scaledHeight = effect.dotHeight * scale;

    final xPos = startingPoint + (effect.dotWidth + effect.spacing) * i;
    final yPos = canvasHeight / 2;
    return RRect.fromLTRBR(
      xPos - scaledWidth / 2,
      yPos - scaledHeight / 2,
      xPos + scaledWidth / 2,
      yPos + scaledHeight / 2,
      dotRadius * scale,
    );
  }
}
