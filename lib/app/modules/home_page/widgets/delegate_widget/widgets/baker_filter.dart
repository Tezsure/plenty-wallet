import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../controllers/delegate_widget_controller.dart';

class BakerFilterBottomSheet extends GetView<DelegateWidgetController> {
  const BakerFilterBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<BakerListBy> status = [
      BakerListBy.Rank,
      BakerListBy.Yield,
      BakerListBy.Space,
      BakerListBy.Staking,
      BakerListBy.Fees
    ];
    Get.lazyPut(() => DelegateWidgetController());
    return NaanBottomSheet(
      // height: 0.42.height,
      isScrollControlled: true,
      title: 'Set baker by :',
      titleAlignment: Alignment.center,
      titleStyle: labelLarge,
      bottomSheetWidgets: [
        Column(
          children: [
            0.02.vspace,
            Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                ),
                child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => Material(
                          color: Colors.transparent,
                          type: MaterialType.transparency,
                          elevation: 0,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(0)),
                          child: InkWell(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(0)),
                            onTap: () {
                              controller.selectFilter(status[index]);
                            },
                            splashColor: Colors.transparent,
                            child: Container(
                              width: double.infinity,
                              height: 51,
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  const Spacer(),
                                  Text(
                                    status[index].name,
                                    style: labelMedium,
                                  ),
                                  const Expanded(
                                      child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Icon(
                                            Icons.check_circle,
                                            color:
                                                // controller.bakerListBy.value ==
                                                //         status[index]
                                                //     ? ColorConst.Primary
                                                //     :
                                                Colors.transparent,
                                          )))
                                ],
                              ),
                            ),
                          ),
                        ),
                    separatorBuilder: (context, index) => const Divider(
                          color: Color(0xff4a454e),
                          height: 1,
                          thickness: 1,
                        ),
                    itemCount: status.length)
                //  Column(
                //   children: [
                //     ...status.map((e) => Material(
                //           color: Colors.transparent,
                //           type: MaterialType.transparency,
                //           elevation: 0,
                //           borderRadius:
                //               const BorderRadius.all(Radius.circular(0)),
                //           child: InkWell(
                //             borderRadius:
                //                 const BorderRadius.all(Radius.circular(0)),
                //             onTap: () {
                //               controller.selectFilter(BakerListBy.Rank);
                //             },
                //             splashColor: Colors.transparent,
                //             child: Container(
                //               width: double.infinity,
                //               height: 51,
                //               alignment: Alignment.center,
                //               child: Row(
                //                 children: [
                //                   const Spacer(),
                //                   Text(
                //                     "Rank",
                //                     style: labelMedium,
                //                   ),
                //                   Expanded(
                //                       child: Align(
                //                           alignment: Alignment.centerRight,
                //                           child: Icon(
                //                             Icons.check_circle,
                //                             color: controller.bakerListBy.value ==
                //                                     BakerListBy.Rank
                //                                 ? ColorConst.Primary
                //                                 : ColorConst
                //                                     .NeutralVariant.shade60
                //                                     .withOpacity(0.2),
                //                           )))
                //                 ],
                //               ),
                //             ),
                //           ),
                //         )),
                //     const Divider(
                //       color: Color(0xff4a454e),
                //       height: 1,
                //       thickness: 1,
                //     ),
                //     Material(
                //       color: Colors.transparent,
                //       type: MaterialType.transparency,
                //       elevation: 0,
                //       borderRadius: const BorderRadius.all(Radius.circular(0)),
                //       child: InkWell(
                //         borderRadius: const BorderRadius.all(Radius.circular(0)),
                //         onTap: () {
                //           controller.selectFilter(BakerListBy.Fees);
                //         },
                //         splashColor: Colors.transparent,
                //         child: Container(
                //           width: double.infinity,
                //           height: 51,
                //           alignment: Alignment.center,
                //           child: Row(
                //             children: [
                //               const Spacer(),
                //               Text(
                //                 "Fees",
                //                 style: labelMedium,
                //               ),
                //               Expanded(
                //                   child: Align(
                //                       alignment: Alignment.centerRight,
                //                       child: Icon(
                //                         Icons.check_circle,
                //                         color: controller.bakerListBy.value ==
                //                                 BakerListBy.Fees
                //                             ? ColorConst.Primary
                //                             : ColorConst.NeutralVariant.shade60
                //                                 .withOpacity(0.2),
                //                       )))
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                ),
            BottomButtonPadding()
          ],
        ),
      ],
    );
  }
}
