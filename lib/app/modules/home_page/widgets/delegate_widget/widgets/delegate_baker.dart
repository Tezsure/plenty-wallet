import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/delegate_widget/widgets/delegate_baker_tile.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/delegate_widget/widgets/review_delegate_baker.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../../utils/colors/colors.dart';
import '../../../../../../utils/styles/styles.dart';
import '../../../../common_widgets/bottom_sheet.dart';
import '../../../../common_widgets/solid_button.dart';
import '../controllers/delegate_widget_controller.dart';
import 'baker_filter.dart';

class DelegateSelectBaker extends GetView<DelegateWidgetController> {
  final bool isScrollable;
  const DelegateSelectBaker({super.key, this.isScrollable = false});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => DelegateWidgetController());
    return NaanBottomSheet(
        mainAxisAlignment: MainAxisAlignment.end,
        bottomSheetHorizontalPadding: 0,
        height: isScrollable ? 0.85.height : 1.height,
        bottomSheetWidgets: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  right: 0.05.width,
                  left: 0.05.width,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: isScrollable
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    _buildSearch(),
                    0.01.vspace,
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.025.width),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Recommended bakers",
                            style: labelSmall.copyWith(color: Colors.white)),
                      ),
                    ),
                    _buildBakerList(),
                  ],
                ),
              ),
              _buildSortByWidget()
            ],
          ),
        ]);
  }

  Container _buildBakerList() {
    return Container(
      height: 0.6.height,
      width: 1.width,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8), topRight: Radius.circular(8)),
      ),
      child: ShaderMask(
        shaderCallback: (Rect rect) {
          return LinearGradient(colors: [
            const Color(0xff100919),
            const Color(0xff100919).withOpacity(0),
          ], begin: const Alignment(0, 1), end: const Alignment(0, 0.7))
              .createShader(rect);
        },
        blendMode: BlendMode.dstOut,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: 6,
            cacheExtent: 4,
            controller: controller.scrollController,
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (_, index) => _buildBakerItem()),
      ),
    );
  }

  Widget _buildBakerItem() {
    return GestureDetector(
      onTap: () => Get.bottomSheet(const ReviewDelegateSelectBaker()),
      child: const DelegateBakerTile(),
    );
  }

  Widget _buildSortByWidget() {
    return Obx(() => AnimatedCrossFade(
          duration: const Duration(milliseconds: 100),
          firstChild: Container(),
          crossFadeState: controller.showFilter.value
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          secondChild: GestureDetector(
            onTap: () => Get.bottomSheet(const BakerFilterBottomSheet()),
            child: SafeArea(
                child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: .3),
                  color: const Color(0xff1E1C1F),
                  borderRadius: BorderRadius.circular(20)),
              width: 100,
              height: 40,
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.filter_list_rounded,
                    color: Colors.white,
                  ),
                  0.01.hspace,
                  Text(
                    "Sort",
                    style: labelSmall.copyWith(color: Colors.white),
                  )
                ],
              ),
            )),
          ),
        ));
    if (!controller.showFilter.value) return const SizedBox.shrink();
    return GestureDetector(
      onTap: () => Get.bottomSheet(const BakerFilterBottomSheet()),
      child: SafeArea(
          child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: .3),
            color: const Color(0xff1E1C1F),
            borderRadius: BorderRadius.circular(20)),
        width: 100,
        height: 40,
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.filter_list_rounded,
              color: Colors.white,
            ),
            0.01.hspace,
            Text(
              "Sort",
              style: labelSmall.copyWith(color: Colors.white),
            )
          ],
        ),
      )),
    );
    return Align(
      alignment: Alignment.centerRight,
      child: RichText(
        text: TextSpan(
            text: 'Sort by',
            style:
                labelSmall.copyWith(color: ColorConst.NeutralVariant.shade60),
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
                              borderRadius: BorderRadius.circular(8),
                              color: ColorConst.NeutralVariant.shade60
                                  .withOpacity(0.2),
                            ),
                            child: Column(
                              children: [
                                Material(
                                  color: Colors.transparent,
                                  type: MaterialType.transparency,
                                  elevation: 0,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(0)),
                                  child: InkWell(
                                    borderRadius: const BorderRadius.all(
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(0)),
                                  child: InkWell(
                                    borderRadius: const BorderRadius.all(
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
    );
  }

  SizedBox _buildSearch() {
    return SizedBox(
      height: 0.06.height,
      width: 1.width,
      child: TextFormField(
        textAlignVertical: TextAlignVertical.top,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          filled: true,
          fillColor: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
          prefixIcon: Icon(
            Icons.search,
            color: ColorConst.NeutralVariant.shade60,
            size: 22,
          ),
          counterStyle: const TextStyle(backgroundColor: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none),
          hintText: 'Search baker',
          hintStyle:
              bodySmall.copyWith(color: ColorConst.NeutralVariant.shade70),
          labelStyle: labelSmall,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        ),
      ),
    );
  }

  Column _buildHeader() {
    return Column(
      children: [
        Text(
          'Delegate',
          style: labelLarge,
        ),
        0.012.vspace,
        RichText(
          textAlign: isScrollable ? TextAlign.center : TextAlign.start,
          text: TextSpan(
              style:
                  labelSmall.copyWith(color: ColorConst.NeutralVariant.shade60),
              text:
                  'Select a Baker you want to delegate funds to.\nThis list is powered by ',
              children: [
                TextSpan(
                    text: 'Tezos-nodes.com',
                    style:
                        const TextStyle(decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        CommonFunctions.launchURL('https://tezos-nodes.com/');
                      })
              ]),
        ),
        0.012.vspace,
      ],
    );
  }
}
