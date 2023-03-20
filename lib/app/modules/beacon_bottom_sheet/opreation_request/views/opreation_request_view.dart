import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

import '../controllers/opreation_request_controller.dart';

class OpreationRequestView extends GetView<OpreationRequestController> {
  const OpreationRequestView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(OpreationRequestController());
    return NaanBottomSheet(
      bottomSheetHorizontalPadding: 16.arP,
      height: 0.7.height,
      bottomSheetWidgets: [
        SizedBox(
          height: 0.63.height,
          child: Obx(
            (() => Container(
                  child: controller.accountModels.value == null
                      ? const SizedBox()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                              0.02.vspace,
                              Padding(
                                padding: EdgeInsets.all(8.0.arP),
                                child: ClipOval(
                                  // borderRadius: BorderRadius.circular(6),
                                  child: Container(
                                    height: 50.arP, width: 50.arP,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(16.arP),

                                    decoration: const BoxDecoration(
                                        color: ColorConst.Primary),
                                    // radius: 20,
                                    // backgroundColor: ColorConst.Primary,
                                    child: Text(
                                      controller.beaconRequest.request
                                              ?.appMetadata?.name
                                              ?.substring(0, 1)
                                              .toUpperCase() ??
                                          'U',
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      style: titleLarge.copyWith(
                                          color: Colors.white, height: 1),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                controller.beaconRequest.request?.appMetadata
                                        ?.name ??
                                    'Unknown',
                                style: titleMedium.copyWith(
                                    color: ColorConst.grey),
                              ),
                              0.01.vspace,
                              Text(
                                'Confirm Transaction'.tr,
                                style: titleMedium.copyWith(fontSize: 18.arP),
                              ),
                              Expanded(
                                child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Obx(() => (Text(
                                            controller.dollarPrice.value
                                                .roundUpDollar(
                                                    controller.xtzPrice),
                                            style: titleLarge.copyWith(
                                                fontSize: 32.arP),
                                          ))),
                                      0.005.vspace,
                                      Obx(() => Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: controller.transfers
                                              .map((element) => Row(
                                                    children: [
                                                      element.symbol == "TEZ"
                                                          ? Image.asset(
                                                              'assets/tezos_logo.png',
                                                              height: 25.arP,
                                                              width: 25.arP,
                                                            )
                                                          : CachedNetworkImage(
                                                              imageUrl: element
                                                                  .thumbnailUri!,
                                                              height: 25.arP,
                                                              width: 25.arP,
                                                            ),
                                                      0.02.hspace,
                                                      Text(
                                                        "${element.amount.toString()} ${element.symbol}",
                                                        style:
                                                            bodyMedium.copyWith(
                                                                color:
                                                                    ColorConst
                                                                        .grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      ),
                                                      controller.transfers.last
                                                                  .symbol !=
                                                              element.symbol
                                                          ? Row(
                                                              children: [
                                                                0.03.hspace,
                                                                Container(
                                                                  height: 25,
                                                                  width: 1,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    color:
                                                                        ColorConst
                                                                            .grey,
                                                                  ),
                                                                ),
                                                                0.03.hspace,
                                                              ],
                                                            )
                                                          : Container(),
                                                    ],
                                                  ))
                                              .toList())),
                                    ]),
                              ),
                              Text(
                                'Account'.tr,
                                style:
                                    bodySmall.copyWith(color: ColorConst.grey),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: Container(
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
                                        padding: EdgeInsets.only(
                                            right: 8.0.arP,
                                            top: 8.arP,
                                            bottom: 8.arP),
                                        child: Container(
                                          height: 24.arP,
                                          width: 24.arP,
                                          alignment: Alignment.bottomRight,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: controller.accountModels
                                                          .value!.imageType ==
                                                      AccountProfileImageType
                                                          .assets
                                                  ? AssetImage(controller
                                                      .accountModels
                                                      .value!
                                                      .profileImage
                                                      .toString())
                                                  : FileImage(
                                                      File(controller
                                                          .accountModels
                                                          .value!
                                                          .profileImage
                                                          .toString()),
                                                    ) as ImageProvider,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                          controller.accountModels.value!.name
                                              .toString(),
                                          style: titleSmall.copyWith(
                                              fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ),
                              ),
                              0.03.vspace,
                              Expanded(
                                  child: Obx(() => Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          controller.error.value
                                                  .trim()
                                                  .isNotEmpty
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 12,
                                                      horizontal: 24),
                                                  child: Text(
                                                    '${'Transaction is likely to fail:'.tr} ${controller.error.value.length > 100 ? controller.error.value.replaceRange(100, controller.error.value.length, '...') : controller.error.value}',
                                                    style: bodyMedium.copyWith(
                                                        color:
                                                            ColorConst.NaanRed),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )
                                              : Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 24.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                          child: SolidButton(
                                                        borderColor:
                                                            const Color(
                                                                0xFFE8A2B9),
                                                        title: "Cancel",
                                                        primaryColor:
                                                            Colors.transparent,
                                                        onPressed: () {
                                                          controller.reject();
                                                        },
                                                        textColor: const Color(
                                                            0xFFE8A2B9),
                                                      )),
                                                      0.04.hspace,
                                                      Expanded(
                                                          child: TextButton(
                                                        style: ButtonStyle(
                                                            shape: MaterialStateProperty.all(
                                                                RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8))),
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(ColorConst
                                                                        .Primary)),
                                                        onPressed: () {
                                                          if (controller
                                                              .error.value
                                                              .trim()
                                                              .isEmpty) {
                                                            controller
                                                                .confirm();
                                                          }
                                                        },
                                                        child: Obx(
                                                          () => (Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical: 4,
                                                                    horizontal:
                                                                        20),
                                                            child: controller
                                                                    .operation
                                                                    .isEmpty
                                                                ? const SizedBox(
                                                                    height: 20,
                                                                    width: 20,
                                                                    child:
                                                                        CupertinoActivityIndicator(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  )
                                                                : !controller
                                                                        .isBiometric
                                                                        .value
                                                                    ? Text(
                                                                        'Confirm'
                                                                            .tr,
                                                                        style: titleSmall.copyWith(
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color: ColorConst.Neutral.shade100),
                                                                      )
                                                                    : Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceAround,
                                                                        children: [
                                                                          Platform.isAndroid
                                                                              ? SvgPicture.asset("${PathConst.SETTINGS_PAGE.SVG}fingerprint.svg")
                                                                              : SvgPicture.asset(
                                                                                  "${PathConst.SVG}faceid.svg",
                                                                                  width: 25,
                                                                                  color: Colors.white,
                                                                                ),
                                                                          Text(
                                                                            'Confirm'.tr,
                                                                            style:
                                                                                titleSmall.copyWith(fontWeight: FontWeight.w600, color: ColorConst.Neutral.shade100),
                                                                          ),
                                                                        ],
                                                                      ),
                                                          )),
                                                        ),
                                                      )),
                                                    ],
                                                  ),
                                                ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 24),
                                            child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Estimated Fees'.tr,
                                                        style:
                                                            bodySmall.copyWith(
                                                                color:
                                                                    ColorConst
                                                                        .grey),
                                                      ),
                                                      Obx(() => (Text(
                                                            controller.fees
                                                                        .value ==
                                                                    "calculating..."
                                                                        .tr
                                                                ? "calculating..."
                                                                    .tr
                                                                    .tr
                                                                : double.parse(
                                                                        controller
                                                                            .fees
                                                                            .value)
                                                                    .roundUpDollar(
                                                                        controller
                                                                            .xtzPrice),
                                                            style: bodyMedium,
                                                          ))),
                                                    ],
                                                  ),
                                                  Obx(() => Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Balance'.tr,
                                                            style: bodySmall
                                                                .copyWith(
                                                                    color: ColorConst
                                                                        .grey),
                                                          ),
                                                          Text(
                                                            '${controller.accountModels.value!.accountDataModel!.xtzBalance} Tez',
                                                            style: bodyMedium,
                                                          ),
                                                        ],
                                                      )),
                                                ]),
                                          )
                                        ],
                                      )))
                            ]),
                )),
          ),
        )
      ],
    );
  }

  Widget _builButtons() {
    return Row(
      children: [
        Expanded(
          child: SolidButton(
            onPressed: () {
              controller.reject();
            },
            borderWidth: 1,
            borderColor: ColorConst.Neutral.shade80,
            textColor: ColorConst.Neutral.shade80,
            title: "Cancel",
            primaryColor: Colors.transparent,
          ),
        ),
        0.024.hspace,
        Expanded(
          child: Obx(
            () => SolidButton(
              title: "Confirm",
              onPressed: () {
                if (controller.error.value.trim().isEmpty) {
                  controller.confirm();
                }
              },
              child: controller.operation.isEmpty
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CupertinoActivityIndicator(
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: Platform.isAndroid
                              ? SvgPicture.asset(
                                  "${PathConst.SVG}fingerprint.svg",
                                  color: ColorConst.Neutral.shade100,
                                )
                              : SvgPicture.asset(
                                  "${PathConst.SVG}faceid.svg",
                                  color: ColorConst.Neutral.shade100,
                                ),
                        ),
                        0.02.hspace,
                        Text(
                          "Confirm".tr,
                          style: titleSmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: ColorConst.Neutral.shade100),
                        )
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
