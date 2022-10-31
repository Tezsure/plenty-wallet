import 'package:flutter/material.dart';

import 'package:get/get.dart';
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
        height: 0.65.height,
        width: 1.width,
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
              0.02.vspace,
              Text(
                'Account',
                style: bodySmall.copyWith(color: ColorConst.grey),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Container(
                  height: 36,
                  width: 0.6.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: ColorConst.darkGrey,
                  ),
                  child: Center(
                      child: Text("Account 1",
                          style: bodyMedium.copyWith(
                              fontWeight: FontWeight.w600))),
                ),
              ),
              0.02.vspace,
              Expanded(
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(() => (Text(
                            "\$ ${(double.parse(controller.amount.value) * controller.dollarPrice.value).toStringAsFixed(2)}",
                            style: titleLarge.copyWith(fontSize: 32),
                          ))),
                      0.005.vspace,
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/tezos_logo.png',
                              height: 22,
                              width: 22,
                            ),
                            0.01.hspace,
                            Obx(() => Text(
                                  controller.amount.value.toString(),
                                  style: titleSmall.copyWith(
                                      color: ColorConst.grey),
                                )),
                          ])
                    ]),
              ),
              Expanded(
                  child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  controller.error.value.trim().isNotEmpty
                      ? Obx(() => Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 24),
                            child: Text(
                              'Transaction is likely to fail ${controller.error.value.length > 25 ? controller.error.value.replaceRange(25, controller.error.value.length, '...') : controller.error.value}',
                              style:
                                  bodyLarge.copyWith(color: ColorConst.NaanRed),
                            ),
                          ))
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      side: BorderSide(
                                          color: ColorConst.Primary.shade60,
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
                                          color: ColorConst.Primary.shade60),
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
                                                BorderRadius.circular(8))),
                                    backgroundColor: MaterialStateProperty.all(
                                        ColorConst.Primary)),
                                onPressed: () {
                                  controller.confirm();
                                },
                                child: Obx(
                                  () => (Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 14),
                                    child: controller.operation.isEmpty
                                        ? const CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : Text(
                                            'Confirm',
                                            style: bodyMedium.copyWith(
                                                color: Colors.white),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Estimated Fees',
                                style:
                                    bodySmall.copyWith(color: ColorConst.grey),
                              ),
                              Obx(() => (Text(
                                    '\$ ${controller.fees.value}',
                                    style: bodyMedium,
                                  ))),
                            ],
                          ),
                          Obx(() => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Balance',
                                    style: bodySmall.copyWith(
                                        color: ColorConst.grey),
                                  ),
                                  Text(
                                    '${controller.accountModels[0].accountDataModel!.xtzBalance} Tez',
                                    style: bodyMedium,
                                  ),
                                ],
                              )),
                        ]),
                  )
                ],
              ))
            ]));
  }
}
