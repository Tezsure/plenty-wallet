import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../../utils/colors/colors.dart';
import '../../../../../../utils/styles/styles.dart';
import '../../../../common_widgets/bottom_sheet.dart';
import '../../../../common_widgets/solid_button.dart';
import '../controllers/delegate_widget_controller.dart';

class DelegateSelectBaker extends GetView<DelegateWidgetController> {
  final bool isScrollable;
  const DelegateSelectBaker({super.key, this.isScrollable = false});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => DelegateWidgetController());
    return Container(
      height: isScrollable ? 0.95.height : 1.height,
      width: 1.height,
      decoration: const BoxDecoration(gradient: GradConst.GradientBackground),
      child: Stack(
        children: [
          isScrollable
              ? Column(
                  children: [
                    0.01.vspace,
                    Center(
                      child: Container(
                        height: 5,
                        width: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: ColorConst.NeutralVariant.shade60
                              .withOpacity(0.3),
                        ),
                      ),
                    ),
                  ],
                )
              : Align(
                  alignment: Alignment.topRight,
                  child: MaterialButton(
                      onPressed: () {
                        Get.back();
                        controller.isBakerAddressSelected.value = false;
                      },
                      shape: const CircleBorder(
                        side: BorderSide.none,
                      ),
                      color: ColorConst.Primary,
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 20,
                      )),
                ),
          Padding(
            padding: EdgeInsets.only(
                top: 0.06.height, right: 0.05.width, left: 0.05.width),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: isScrollable
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  'Delegate to Recommended Bakers',
                  style: labelLarge,
                ),
                0.012.vspace,
                Text(
                    'Select a Baker you want to delegate funds to.\nThis list is powered by Tezos-nodes.com',
                    textAlign:
                        isScrollable ? TextAlign.center : TextAlign.start,
                    style: labelSmall.copyWith(
                        color: ColorConst.NeutralVariant.shade60)),
                0.012.vspace,
                SizedBox(
                  height: 0.06.height,
                  width: 1.width,
                  child: TextFormField(
                    textAlignVertical: TextAlignVertical.top,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor:
                          ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                      prefixIcon: Icon(
                        Icons.search,
                        color: ColorConst.NeutralVariant.shade60,
                        size: 22,
                      ),
                      counterStyle:
                          const TextStyle(backgroundColor: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none),
                      hintText: 'Search baker',
                      hintStyle: bodySmall.copyWith(
                          color: ColorConst.NeutralVariant.shade70),
                      labelStyle: labelSmall,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: RichText(
                    text: TextSpan(
                        text: 'Sort by',
                        style: labelSmall.copyWith(
                            color: ColorConst.NeutralVariant.shade60),
                        children: [
                          TextSpan(
                              text: ' Rank',
                              style: labelSmall.copyWith(color: Colors.white)),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: IconButton(
                              splashRadius: 10,
                              enableFeedback: true,
                              constraints: const BoxConstraints(),
                              iconSize: 20.sp,
                              onPressed: () => Get.bottomSheet(NaanBottomSheet(
                                height: 0.3.height,
                                title: 'Set baker by:',
                                titleAlignment: Alignment.center,
                                titleStyle: labelLarge,
                                bottomSheetWidgets: [
                                  Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: ColorConst
                                              .NeutralVariant.shade60
                                              .withOpacity(0.2),
                                        ),
                                        child: Column(
                                          children: [
                                            Material(
                                              color: Colors.transparent,
                                              type: MaterialType.transparency,
                                              elevation: 0,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(0)),
                                              child: InkWell(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(0)),
                                                onTap: () {},
                                                splashColor: Colors.transparent,
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 51,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Rank",
                                                    style: labelMedium,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const Divider(
                                              color: Color(0xff4a454e),
                                              height: 1,
                                              thickness: 1,
                                            ),
                                            Material(
                                              color: Colors.transparent,
                                              type: MaterialType.transparency,
                                              elevation: 0,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(0)),
                                              child: InkWell(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(0)),
                                                onTap: () {},
                                                splashColor: Colors.transparent,
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 51,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Fees",
                                                    style: labelMedium,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: ColorConst.Primary,
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
                0.01.vspace,
                Container(
                  height: 0.5.height,
                  width: 1.width,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)),
                  ),
                  child: ShaderMask(
                    shaderCallback: (Rect rect) {
                      return LinearGradient(
                              colors: [
                            const Color(0xff100919),
                            const Color(0xff100919).withOpacity(0),
                          ],
                              begin: const Alignment(0, 1),
                              end: const Alignment(0, 0.7))
                          .createShader(rect);
                    },
                    blendMode: BlendMode.dstOut,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 6,
                        cacheExtent: 4,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (_, index) => GestureDetector(
                              onTap: () =>
                                  controller.onSelectedBakerChanged(index),
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 0.01.height),
                                child: Obx(
                                  () => Container(
                                    width: 338,
                                    height: 0.12.height,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: const Color(0xff958e99)
                                          .withOpacity(0.2),
                                      border: Border.all(
                                        color: controller.selectedBaker.value ==
                                                    index &&
                                                controller
                                                    .isBakerAddressSelected
                                                    .value
                                            ? ColorConst.Primary
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0.04.width),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              backgroundColor:
                                                  Colors.transparent,
                                              radius: 14,
                                              child: Image.asset(
                                                'assets/temp/delegate_baker.png',
                                                fit: BoxFit.fill,
                                                width: 28,
                                                height: 28,
                                              ),
                                            ),
                                            0.02.hspace,
                                            Text(
                                              'MyTezosBaking',
                                              style: labelMedium,
                                            ),
                                            const Spacer(),
                                            Text(
                                              'tz1d6....pVok8',
                                              style: labelSmall.copyWith(
                                                  color: ColorConst.Primary),
                                            ),
                                            IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.copy,
                                                color: ColorConst.Primary,
                                                size: 12,
                                              ),
                                              iconSize: 12,
                                              constraints:
                                                  const BoxConstraints(),
                                            )
                                          ],
                                        ),
                                        0.013.vspace,
                                        Row(
                                          children: [
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: 'Baker fee:\n',
                                                style: labelSmall.copyWith(
                                                    color: ColorConst
                                                        .NeutralVariant
                                                        .shade70),
                                                children: [
                                                  TextSpan(
                                                      text: '14%',
                                                      style: labelLarge)
                                                ],
                                              ),
                                            ),
                                            0.031.hspace,
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: 'Staking:\n',
                                                style: labelSmall.copyWith(
                                                    color: ColorConst
                                                        .NeutralVariant
                                                        .shade70),
                                                children: [
                                                  TextSpan(
                                                      text: '116K',
                                                      style: labelLarge)
                                                ],
                                              ),
                                            ),
                                            0.031.hspace,
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: 'Payout:\n',
                                                style: labelSmall.copyWith(
                                                    color: ColorConst
                                                        .NeutralVariant
                                                        .shade70),
                                                children: [
                                                  TextSpan(
                                                      text: '30 Days*',
                                                      style: labelLarge)
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )),
                  ),
                ),
                0.02.vspace,
                Text(
                  '*All payout periods are converted from cycle to days.\n1 cycle = approx. 2.5 days',
                  style: labelSmall.copyWith(
                      color: ColorConst.NeutralVariant.shade60),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: 0.04.height, left: 0.04.width, right: 0.04.width),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Obx(() => SolidButton(
                    onPressed: () {
                      Get.back();
                      controller.isBakerAddressSelected.value = false;
                    },
                    height: 0.06.height,
                    width: 0.85.width,
                    title: controller.isBakerAddressSelected.value
                        ? 'Delegate'
                        : 'Next',
                    elevation: 0,
                    primaryColor: controller.isBakerAddressSelected.value
                        ? ColorConst.Primary
                        : ColorConst.Primary.shade50.withOpacity(0.2),
                    disabledButtonColor: controller.isBakerAddressSelected.value
                        ? ColorConst.Primary
                        : ColorConst.Primary.shade50,
                    textColor: controller.isBakerAddressSelected.value
                        ? ColorConst.Neutral.shade95
                        : ColorConst.NeutralVariant.shade60,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
