import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/liquidity_baking_widget/widgets/custom_slider.dart';
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
              "${PathConst.HOME_PAGE.IMAGES}coins_background.png",
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "on your ",
                style: headlineMedium.apply(color: Colors.black),
              ),
              SvgPicture.asset(
                "${PathConst.HOME_PAGE.SVG}xtz.svg",
                color: Colors.black,
              )
            ],
          ),
          0.027.vspace,
          Container(
            height: 0.04.height,
            width: 0.6.width,
            padding: const EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(25)),
            child: Center(
              child: Stack(children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 0.04.height,
                    width: 0.34.width,
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                        color: ColorConst.Tertiary.shade90,
                        borderRadius: BorderRadius.circular(25)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 70.0, top: 8),
                      child: Text(
                        'Remove',
                        style: labelSmall.copyWith(color: ColorConst.Tertiary),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 0.04.height,
                    width: 0.23.width,
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Text(
                        'Add',
                        style: labelSmall,
                      ),
                    ),
                  ),
                ),
              ]),
            ),
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
                "${PathConst.HOME_PAGE.SVG}xtz.svg",
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
          const Center(
            child: LiquidBakingSlider(),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 17.0, right: 17, top: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                    5,
                    (index) => Text(
                          "${index > 0 ? index * 25 : index}%",
                          style: labelLarge.copyWith(
                              color: (index * 25) < 24
                                  ? Colors.black
                                  : ColorConst.Tertiary.shade60,
                              fontSize: 12),
                        ))),
          ),
          0.02.vspace,
          MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            height: 40,
            color: activeButton ? Colors.black : ColorConst.Tertiary.shade90,
            elevation: 0,
            onPressed: () {},
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
          ),
          0.038.vspace,
        ],
      ),
    );
  }
}

class LiquidBakingSlider extends StatefulWidget {
  const LiquidBakingSlider({
    Key? key,
  }) : super(key: key);

  @override
  State<LiquidBakingSlider> createState() => _LiquidBakingSliderState();
}

class _LiquidBakingSliderState extends State<LiquidBakingSlider> {
  double value = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.width,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 6,
          thumbShape: const CustomRoundSliderThumbShape(enabledThumbRadius: 10),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
          showValueIndicator: ShowValueIndicator.always,
          trackShape: const GradientRectSliderTrackShape(),
        ),
        child: Slider(
          max: 100,
          min: 0,
          value: value,
          label: value.toStringAsFixed(0),
          onChanged: (val) {
            setState(() {
              value = val;
            });
          },
        ),
      ),
    );
  }
}
