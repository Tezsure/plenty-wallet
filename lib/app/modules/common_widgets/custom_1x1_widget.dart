import 'package:flutter/cupertino.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

class WidgetWrapper2x1 extends StatelessWidget {
  /// This wrapper widget takes half of the screen's width and is square(height = width) in shape.
  WidgetWrapper2x1(this.gradient, {required this.child});
  final Gradient gradient;
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
        width: (1.width / 2) -
            10 -
            24, // 20 is padding in the center and 24 is the padding on the sides
        height: (1.width / 2) -
            10 -
            24, // 20 is padding in the center and 24 is the padding on the sides
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: gradient,
        ),
        child: child,
      );
}
