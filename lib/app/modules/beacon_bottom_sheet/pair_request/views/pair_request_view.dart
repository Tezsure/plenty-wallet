import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/modules/beacon_bottom_sheet/widgets/account_selector/account_selector.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../controllers/pair_request_controller.dart';

class PairRequestView extends GetView<PairRequestController> {
  const PairRequestView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(PairRequestController());
    return Container(
        height: 0.5.height,
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
            0.04.vspace,
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
              controller.beaconRequest.peer?.name ?? 'Unknown',
              style: titleLarge,
            ),
            0.04.vspace,
            Text(
              'Wants to connect to your account',
              style: bodyMedium.copyWith(color: ColorConst.grey),
            ),
            0.04.vspace,
            Text(
              'Account',
              style: bodySmall.copyWith(color: ColorConst.grey),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: InkWell(
                onTap: () {
                  controller.changeAccount();
                },
                child: Obx(() => Container(
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
                                  image: controller
                                              .accountModels[controller
                                                  .selectedAccount.value]
                                              .imageType ==
                                          AccountProfileImageType.assets
                                      ? AssetImage(controller
                                          .accountModels[
                                              controller.selectedAccount.value]
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
                              style: titleSmall.copyWith(
                                  fontWeight: FontWeight.w500)),
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
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              side: BorderSide(
                                  color: ColorConst.Primary.shade60, width: 1)),
                          onPressed: () {
                            controller.reject();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 14),
                            child: Text(
                              'Cancel',
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
                                      borderRadius: BorderRadius.circular(8))),
                              backgroundColor: MaterialStateProperty.all(
                                  ColorConst.Primary)),
                          onPressed: () {
                            controller.accept();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 14),
                            child: Text(
                              'Connect',
                              style: bodyMedium.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ))
          ],
        ));
  }
}
