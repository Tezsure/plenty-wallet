/* import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/constants/path_const.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';

import 'widgets/liquidity_baking_slider.dart';

// ignore: must_be_immutable
class LiquidityBakingWidget extends StatelessWidget {
  LiquidityBakingWidget({Key? key}) : super(key: key);

  final HomePageController controller = Get.find<HomePageController>();

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
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: 'Earn ',
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 24.arP,
                    color: Colors.black),
                children: [
                  TextSpan(
                    text: '31% APR\n',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 24.arP,
                        color: Colors.black),
                  ),
                  TextSpan(
                    text: 'on your ',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 24.arP,
                        color: Colors.black),
                  ),
                  WidgetSpan(
                      child: SvgPicture.asset(
                    "${PathConst.HOME_PAGE.SVG}xtz.svg",
                    color: Colors.black,
                  ))
                ]),
          ),
          0.03.vspace,
          Container(
            height: 0.045.height,
            width: 0.42.width,
            decoration: BoxDecoration(
              color: ColorConst.Tertiary.shade90,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Obx(() => Stack(
                  children: [
                    AnimatedAlign(
                      alignment: controller.isEnabled.value
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      duration: controller.animationDuration,
                      child: Container(
                        width: 0.21.width,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(25.arP),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomButton(
                          onTap: () => controller.onTapLiquidityBaking(),
                          isEnabled: !controller.isEnabled.value,
                          text: 'Add',
                        ),
                        CustomButton(
                          onTap: () => controller.onTapLiquidityBaking(),
                          isEnabled: controller.isEnabled.value,
                          text: 'Remove',
                        ),
                      ],
                    ),
                  ],
                )),
          ),
          0.015.vspace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => IntrinsicWidth(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.black,
                      cursorWidth: 1,
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.center,
                      style: headlineLarge.apply(color: Colors.black),
                      decoration: InputDecoration(
                        // labelText: controller.isEnabled.value ? '7648' : null,
                        labelStyle: headlineLarge.copyWith(color: Colors.black),
                        border: InputBorder.none,
                        hintText: !controller.isEnabled.value ? "0.00" : null,
                        hintStyle: headlineLarge.apply(
                            color: ColorConst.Tertiary.shade60),
                      ),
                    ),
                  )),
              0.01.hspace,
              SvgPicture.asset(
                "${PathConst.HOME_PAGE.SVG}xtz.svg",
                color: Colors.black,
                height: 34,
              ),
            ],
          ),
          Obx(() => Text(
                !controller.isEnabled.value
                    ? "SIRS : 0"
                    : "Available SIRS : 123",
                style: labelSmall.apply(color: Colors.black),
              )),
          0.005.vspace,
          Text(
            "1 XTZ (\$.1.56) = 0.00007278 SIRS",
            style: labelSmall.apply(color: Colors.black),
          ),
          0.04.vspace,
          Center(
            child: Obx(() => LiquidityBakingSlider(
                  onChanged: controller.onSliderChange,
                  sliderValue: controller.sliderValue.value,
                )),
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
                ),
              ),
            ),
          ),
          0.02.vspace,
          Obx(() => MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                height: 40,
                color: (!controller.isEnabled.value ||
                            controller.isEnabled.value) &&
                        controller.sliderValue.value > 5
                    ? Colors.black
                    : ColorConst.Tertiary.shade90,
                elevation: 0,
                onPressed: () {},
                child: SizedBox(
                  width: 0.75.width,
                  child: Center(
                    child: Text(
                      !controller.isEnabled.value
                          ? "Get Sirius"
                          : "Remove Liquidity",
                      style: labelSmall.apply(
                          color: (!controller.isEnabled.value ||
                                      controller.isEnabled.value) &&
                                  controller.sliderValue.value > 5
                              ? Colors.white
                              : ColorConst.Tertiary.shade80),
                    ),
                  ),
                ),
              )),
          0.038.vspace,
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final bool isEnabled;
  final Function() onTap;
  final String text;
  const CustomButton({
    Key? key,
    required this.isEnabled,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 0.045.height,
        width: 0.21.width,
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: labelSmall.copyWith(
                color: isEnabled ? Colors.white : ColorConst.Tertiary),
          ),
        ),
      ),
    );
  }
}
 */