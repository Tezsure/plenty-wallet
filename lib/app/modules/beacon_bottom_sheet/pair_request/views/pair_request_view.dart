import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../controllers/pair_request_controller.dart';

class PairRequestView extends GetView<PairRequestController> {
  const PairRequestView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(PairRequestController());
    return NaanBottomSheet(
        height: 0.42.height,
        bottomSheetHorizontalPadding: 0,
        // width: 1.width,

        // decoration: const BoxDecoration(
        //     borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        //     color: Colors.black),
        bottomSheetWidgets: [
          SizedBox(
            height: 0.36.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 0.005.vspace,
                // Container(
                //   height: 5,
                //   width: 36,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(5),
                //     color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
                //   ),
                // ),
                0.02.vspace,
                Padding(
                  padding: EdgeInsets.all(8.0.arP),
                  child: ClipOval(
                    // borderRadius: BorderRadius.circular(6),
                    child: Container(
                      height: 50.arP, width: 50.arP,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(16.arP),

                      decoration:
                          const BoxDecoration(color: ColorConst.Primary),
                      // radius: 20,
                      // backgroundColor: ColorConst.Primary,
                      child: Text(
                        controller.beaconRequest.request?.appMetadata?.name
                                ?.substring(0, 1)
                                .toUpperCase() ??
                            'U',
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style:
                            titleLarge.copyWith(color: Colors.white, height: 1),
                      ),
                    ),
                  ),
                ),
                Text(
                  controller.beaconRequest.peer?.name ?? 'Unknown',
                  style: titleLarge,
                ),

                0.02.vspace,
                Text(
                  'Wants to connect to your account',
                  style: bodyLarge.copyWith(
                      color: ColorConst.grey, fontWeight: FontWeight.w600),
                ),
                0.03.vspace,
                Text(
                  'Account',
                  style: bodySmall.copyWith(color: ColorConst.grey),
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: BouncingWidget(
                    onPressed: () {
                      controller.changeAccount();
                    },
                    child: Obx(() => Container(
                          // height: 42,
                          width: 0.5.width,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: ColorConst.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            color: ColorConst.darkGrey,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:  EdgeInsets.only(right: 8.0.arP, top: 8.arP, bottom: 8.arP),
                                child: Container(
                              height: 40.arP,
                      width: 40.arP,
                                  alignment: Alignment.bottomRight,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: controller
                                                  .accountModels[controller
                                                      .selectedAccount.value]
                                                  .imageType ==
                                              AccountProfileImageType.assets
                                          ? AssetImage(controller
                                              .accountModels[controller
                                                  .selectedAccount.value]
                                              .profileImage
                                              .toString())
                                          : FileImage(
                                              File(
                                                controller
                                                    .accountModels[controller
                                                        .selectedAccount.value]
                                                    .profileImage
                                                    .toString(),
                                              ),
                                            ) as ImageProvider,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                  controller
                                      .accountModels[
                                          controller.selectedAccount.value]
                                      .name
                                      .toString(),
                                  style: labelMedium),
                              const Icon(
                                Icons.keyboard_arrow_right_rounded,
                                color: Colors.white,
                              )
                            ],
                          ),
                        )),
                  ),
                ),
                Expanded(
                    child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: SolidButton(
                              borderColor: const Color(0xFFE8A2B9),
                              title: "Cancel",
                              primaryColor: Colors.transparent,
                              onPressed: () {
                                controller.reject();
                              },
                              textColor: const Color(0xFFE8A2B9),
                            ),
                          ),
                          0.04.hspace,
                          Expanded(
                            child: SolidButton(
                              title: "Connect",
                              primaryColor: ColorConst.Primary,
                              onPressed: () {
                                controller.accept();
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ))
              ],
            ),
          )
        ]);
  }
}
