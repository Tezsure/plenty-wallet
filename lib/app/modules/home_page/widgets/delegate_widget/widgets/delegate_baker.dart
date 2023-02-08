import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/delegate_baker_list_model.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/delegate_widget/widgets/delegate_baker_tile.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/delegate_widget/widgets/review_delegate_baker.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../../utils/colors/colors.dart';
import '../../../../../../utils/styles/styles.dart';
import '../../../../common_widgets/bottom_sheet.dart';
import '../controllers/delegate_widget_controller.dart';
import 'baker_filter.dart';

class DelegateSelectBaker extends GetView<DelegateWidgetController> {
  final DelegateBakerModel? delegatedBaker;
  final bool isScrollable;
  DelegateSelectBaker(
      {super.key, this.isScrollable = false, this.delegatedBaker}) {
    Get.lazyPut(() => DelegateWidgetController());
  }

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
        title: "Delegate",
        isScrollControlled: true,
        // mainAxisAlignment: MainAxisAlignment.end,
        bottomSheetHorizontalPadding: 0,
        // height: (isScrollable ? 0.85.height : 1.height),
        bottomSheetWidgets: [
          SizedBox(
            height: AppConstant.naanBottomSheetChildHeight -
                MediaQuery.of(context).viewInsets.bottom -
                64.arP,
            child: Stack(
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
                        padding: EdgeInsets.symmetric(vertical: 0.012.height),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Recommended bakers", style: labelLarge),
                        ),
                      ),
                      _buildBakerList(),
                    ],
                  ),
                ),
                _buildSortByWidget(context)
              ],
            ),
          ),
        ]);
  }

  Widget _buildBakerList() {
    return Expanded(
      // height: 0.6.height,
      // width: 1.width,
      // decoration: const BoxDecoration(
      //   color: Colors.transparent,
      //   borderRadius: BorderRadius.only(
      //       topLeft: Radius.circular(8), topRight: Radius.circular(8)),
      // ),
      child: ShaderMask(
        shaderCallback: (Rect rect) {
          return LinearGradient(colors: [
            const Color(0xff100919),
            const Color(0xff100919).withOpacity(0),
          ], begin: const Alignment(0, 1), end: const Alignment(0, 0.7))
              .createShader(rect);
        },
        blendMode: BlendMode.dstOut,
        child: Obx(() {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: controller.searchedDelegateBakerList.length,
              cacheExtent: 4,
              controller: controller.scrollController,
              padding: EdgeInsets.zero,
              physics: AppConstant.scrollPhysics,
              itemBuilder: (_, index) {
                if (delegatedBaker?.address ==
                    controller.searchedDelegateBakerList[index].address) {
                  return Container();
                }
                return _buildBakerItem(
                    controller.searchedDelegateBakerList[index]);
              });
        }),
      ),
    );
  }

  Widget _buildBakerItem(DelegateBakerModel baker) {
    return GestureDetector(
      onTap: () => Get.bottomSheet(ReviewDelegateSelectBaker(
        baker: baker,
      )),
      child: DelegateBakerTile(baker: baker),
    );
  }

  Widget _buildSortByWidget(BuildContext context) {
    return Obx(() => AnimatedCrossFade(
          sizeCurve: Curves.easeIn,
          secondCurve: Curves.easeIn,
          firstCurve: Curves.easeIn,
          duration: const Duration(milliseconds: 150),
          firstChild: Container(),
          crossFadeState: controller.showFilter.value
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          secondChild: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(bottom: 48.arP),
              child: GestureDetector(
                onTap: () => Get.bottomSheet(const BakerFilterBottomSheet()),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: .3),
                      color: const Color(0xff1E1C1F),
                      borderRadius: BorderRadius.circular(20)),
                  width: 100,
                  height: 40,
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
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
                      // if (controller.bakerListBy?.value != null)
                      //   const Align(
                      //     alignment: Alignment.topRight,
                      //     child: Icon(
                      //       Icons.circle,
                      //       color: ColorConst.Primary,
                      //       size: 15,
                      //     ),
                      //   ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  SizedBox _buildSearch() {
    return SizedBox(
      height: 0.06.height,
      width: 1.width,
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        onChanged: (value) {
          controller.updateBakerList();
        },
        controller: controller.textEditingController,
        textAlignVertical: TextAlignVertical.top,
        textAlign: TextAlign.start,
        cursorColor: ColorConst.Primary,
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
              bodyMedium.copyWith(color: ColorConst.NeutralVariant.shade70),
          labelStyle: labelSmall,
          // contentPadding:
          //     const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        ),
      ),
    );
  }

  Column _buildHeader() {
    return Column(
      children: [
        // Text(
        //   'Delegate',
        //   style: titleLarge,
        // ),
        0.012.vspace,
        RichText(
          textAlign: isScrollable ? TextAlign.center : TextAlign.start,
          text: TextSpan(
              style:
                  bodySmall.copyWith(color: ColorConst.NeutralVariant.shade60),
              text:
                  'Choose a baker to delegate your tez to.\nThis list is powered by ',
              children: [
                TextSpan(
                    text: 'Tezos-nodes.com',
                    style:
                        const TextStyle(decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        CommonFunctions.launchURL(
                          'https://tezos-nodes.com/',
                          mode: LaunchMode.platformDefault,
                        );
                      })
              ]),
        ),
        0.019.vspace,
      ],
    );
  }
}
