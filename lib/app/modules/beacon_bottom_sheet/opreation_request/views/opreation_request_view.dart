import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../controllers/opreation_request_controller.dart';

class OpreationRequestView extends GetView<OpreationRequestController> {
  const OpreationRequestView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(OpreationRequestController());
    return Container(
        height: 0.7.height,
        width: 1.width,
        padding: EdgeInsets.only(
          bottom: Platform.isIOS ? 0.05.height : 0.02.height,
        ),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            color: Colors.black),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              0.005.vspace,
              Container(
                height: 5,
                width: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
                ),
              ),
              0.02.vspace,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    controller.beaconRequest.peer?.icon ??
                        'https://picsum.photos/250?image=9',
                    height: 60,
                    width: 60,
                  ),
                ),
              ),
              Text(
                controller.beaconRequest.request?.appMetadata?.name ??
                    'Unknown',
                style: titleMedium.copyWith(color: ColorConst.grey),
              ),
              0.01.vspace,
              Text(
                'Confirm Transaction',
                style: titleMedium.copyWith(fontSize: 18),
              ),
              Expanded(
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(() => (Text(
                            "\$ ${controller.dollarPrice.value.toStringAsFixed(2)}",
                            style: titleLarge.copyWith(fontSize: 32),
                          ))),
                      0.005.vspace,
                      Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: controller.transfers
                              .map((element) => Row(
                                    children: [
                                      element.symbol == "TEZ"
                                          ? Image.asset(
                                              'assets/tezos_logo.png',
                                              height: 25,
                                              width: 25,
                                            )
                                          : Image.network(
                                              element.thumbnailUri!,
                                              height: 25,
                                              width: 25,
                                            ),
                                      0.02.hspace,
                                      Text(
                                        "${element.amount.toString()} ${element.symbol}",
                                        style: bodyMedium.copyWith(
                                            color: ColorConst.grey,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      controller.transfers.last.symbol !=
                                              element.symbol
                                          ? Row(
                                              children: [
                                                0.03.hspace,
                                                Container(
                                                  height: 25,
                                                  width: 1,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: ColorConst.grey,
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
                'Account',
                style: bodySmall.copyWith(color: ColorConst.grey),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Container(
                  height: 42,
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
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          height: 0.06.width,
                          width: 0.06.width,
                          alignment: Alignment.bottomRight,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image:
                                  controller.accountModels!.value.imageType ==
                                          AccountProfileImageType.assets
                                      ? AssetImage(controller
                                          .accountModels!.value.profileImage
                                          .toString())
                                      : FileImage(
                                          File(controller
                                              .accountModels!.value.profileImage
                                              .toString()),
                                        ) as ImageProvider,
                            ),
                          ),
                        ),
                      ),
                      Text(controller.accountModels!.value.name.toString(),
                          style:
                              titleSmall.copyWith(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
              0.03.vspace,
              Expanded(
                  child: Obx(() => Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          controller.error.value.trim().isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 24),
                                  child: Text(
                                    'Transaction is likely to fail: ${controller.error.value.length > 100 ? controller.error.value.replaceRange(100, controller.error.value.length, '...') : controller.error.value}',
                                    style: bodyMedium.copyWith(
                                        color: ColorConst.NaanRed),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              side: BorderSide(
                                                  color: ColorConst
                                                      .Primary.shade60,
                                                  width: 1)),
                                          onPressed: () {
                                            controller.reject();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 14),
                                            child: Text(
                                              'Reject',
                                              style: bodyMedium.copyWith(
                                                  color: ColorConst
                                                      .Primary.shade60),
                                            ),
                                          ),
                                        ),
                                      ),
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
                                                MaterialStateProperty.all(
                                                    ColorConst.Primary)),
                                        onPressed: () {
                                          if (controller.error.value
                                              .trim()
                                              .isEmpty) {
                                            controller.confirm();
                                          }
                                        },
                                        child: Obx(
                                          () => (Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 20),
                                            child: controller.operation.isEmpty
                                                ? const CircularProgressIndicator(
                                                    color: Colors.white,
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .fingerprint_rounded,
                                                        color: Colors.white,
                                                        size: 24,
                                                      ),
                                                      Text(
                                                        'Confirm',
                                                        style:
                                                            bodyMedium.copyWith(
                                                                color: Colors
                                                                    .white),
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
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Estimated Fees',
                                        style: bodySmall.copyWith(
                                            color: ColorConst.grey),
                                      ),
                                      Obx(() => (Text(
                                            '\$ ${controller.fees.value}',
                                            style: bodyMedium,
                                          ))),
                                    ],
                                  ),
                                  Obx(() => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Balance',
                                            style: bodySmall.copyWith(
                                                color: ColorConst.grey),
                                          ),
                                          Text(
                                            '${controller.accountModels!.value.accountDataModel!.xtzBalance} Tez',
                                            style: bodyMedium,
                                          ),
                                        ],
                                      )),
                                ]),
                          )
                        ],
                      )))
            ]));
  }
}