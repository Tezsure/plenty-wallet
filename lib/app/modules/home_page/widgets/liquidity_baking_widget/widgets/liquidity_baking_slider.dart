/* import 'package:flutter/material.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';

import '../../../../../../utils/colors/colors.dart';
import '../../../../../../utils/styles/styles.dart';
import 'custom_slider_library.dart';

class LiquidityBakingSlider extends StatelessWidget {
  final double sliderValue;
  final Function(double) onChanged;
  const LiquidityBakingSlider(
      {Key? key, required this.sliderValue, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.width,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          valueIndicatorColor: ColorConst.Tertiary.shade95,
          valueIndicatorTextStyle: labelSmall.apply(color: Colors.black),
          rangeValueIndicatorShape:
              const PaddleRangeSliderValueIndicatorShape(),
          trackHeight: 6,
          thumbShape: const CustomRoundSliderThumbShape(enabledThumbRadius: 10),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
          showValueIndicator: ShowValueIndicator.always,
          trackShape: const GradientRectSliderTrackShape(),
        ),
        child: Slider(
            max: 100,
            min: 0,
            value: sliderValue,
            label: sliderValue.toStringAsFixed(0),
            onChanged: onChanged),
      ),
    );
  }
}
 */