import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../controllers/payload_request_controller.dart';

class PayloadRequestView extends GetView<PayloadRequestController> {
  const PayloadRequestView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(PayloadRequestController());
    return NaanBottomSheet(
      height: 0.65.height,
      bottomSheetWidgets: [
        Obx(() {
          return SizedBox(
            height: 0.58.height,
            child: controller.accountModel.value == null
                ? const SizedBox()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        0.02.vspace,
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: ColorConst.Primary,
                              child: Center(
                                child: Text(
                                  controller.beaconRequest.request?.appMetadata
                                          ?.name
                                          ?.substring(0, 1)
                                          .toUpperCase() ??
                                      'U',
                                  style: titleLarge.copyWith(
                                      color: Colors.white, height: 1),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          controller.beaconRequest.request?.appMetadata?.name ??
                              'Unknown',
                          style: titleMedium.copyWith(color: ColorConst.grey),
                        ),
                        0.02.vspace,
                        Text(
                          'Message Signature Request',
                          style: titleMedium.copyWith(fontSize: 18),
                        ),
                        0.03.vspace,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Message',
                              style: labelMedium,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 4),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: ColorConst.grey),
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                              controller.beaconRequest.request?.payload ?? '',
                              maxLines: 6,
                              style:
                                  bodySmall.copyWith(color: ColorConst.grey)),
                        ),
                        0.03.vspace,
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
                                        image: controller.accountModel.value!
                                                    .imageType ==
                                                AccountProfileImageType.assets
                                            ? AssetImage(controller.accountModel
                                                .value!.profileImage
                                                .toString())
                                            : FileImage(
                                                File(controller.accountModel
                                                    .value!.profileImage
                                                    .toString()),
                                              ) as ImageProvider,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                    controller.accountModel.value!.name
                                        .toString(),
                                    style: titleSmall.copyWith(
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding:  EdgeInsets.symmetric(
                                    horizontal: 24.0.arP),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
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
                                    )),
                                    0.04.hspace,
                                    Expanded(
                                      child: SolidButton(
                                        title: "Sign",
                                        primaryColor: ColorConst.Primary,
                                        onPressed: () {
                                          controller.confirm();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ]),
          );
        })
      ],
    );
    // return Container(
    //     height: 0.65.height,
    //     width: 1.width,
    //     padding: EdgeInsets.only(
    //       bottom: Platform.isIOS ? 0.05.height : 0.02.height,
    //     ),
    //     decoration: const BoxDecoration(
    //         borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
    //         color: Colors.black),
    //     child: Obx(
    //       (() => Container(
    //             child: controller.accountModel.value == null
    //                 ? const SizedBox()
    //                 : Column(
    //                     crossAxisAlignment: CrossAxisAlignment.center,
    //                     mainAxisSize: MainAxisSize.min,
    //                     children: [
    //                         0.005.vspace,
    //                         Container(
    //                           height: 5,
    //                           width: 36,
    //                           decoration: BoxDecoration(
    //                             borderRadius: BorderRadius.circular(5),
    //                             color: ColorConst.NeutralVariant.shade60
    //                                 .withOpacity(0.3),
    //                           ),
    //                         ),
    //                         0.02.vspace,
    //                         Padding(
    //                           padding: const EdgeInsets.all(8.0),
    //                           child: ClipRRect(
    //                             borderRadius: BorderRadius.circular(6),
    //                             child: CircleAvatar(
    //                               radius: 20,
    //                               backgroundColor: ColorConst.Primary,
    //                               child: Center(
    //                                 child: Text(
    //                                   controller.beaconRequest.request
    //                                           ?.appMetadata?.name
    //                                           ?.substring(0, 1)
    //                                           .toUpperCase() ??
    //                                       'U',
    //                                   style: titleLarge.copyWith(
    //                                       color: Colors.white),
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //                         Text(
    //                           controller.beaconRequest.request?.appMetadata
    //                                   ?.name ??
    //                               'Unknown',
    //                           style:
    //                               titleMedium.copyWith(color: ColorConst.grey),
    //                         ),
    //                         0.02.vspace,
    //                         Text(
    //                           'Message Signature Request',
    //                           style: titleMedium.copyWith(fontSize: 18),
    //                         ),
    //                         0.03.vspace,
    //                         Padding(
    //                           padding:
    //                               const EdgeInsets.symmetric(horizontal: 15.0),
    //                           child: Align(
    //                             alignment: Alignment.centerLeft,
    //                             child: Text(
    //                               'Message',
    //                               style: labelMedium,
    //                             ),
    //                           ),
    //                         ),
    //                         Container(
    //                           margin: const EdgeInsets.symmetric(
    //                               horizontal: 15.0, vertical: 4),
    //                           padding: const EdgeInsets.all(10.0),
    //                           decoration: BoxDecoration(
    //                               border: Border.all(color: ColorConst.grey),
    //                               borderRadius: BorderRadius.circular(5)),
    //                           child: Text(
    //                               controller.beaconRequest.request?.payload ??
    //                                   '',
    //                               maxLines: 6,
    //                               style: bodySmall.copyWith(
    //                                   color: ColorConst.grey)),
    //                         ),
    //                         0.03.vspace,
    //                         Text(
    //                           'Account',
    //                           style: bodySmall.copyWith(color: ColorConst.grey),
    //                         ),
    //                         Padding(
    //                           padding: const EdgeInsets.all(4),
    //                           child: Container(
    //                             height: 42,
    //                             width: 0.5.width,
    //                             decoration: BoxDecoration(
    //                               border: Border.all(
    //                                 color: ColorConst.grey,
    //                                 width: 1,
    //                               ),
    //                               borderRadius: BorderRadius.circular(30),
    //                               color: ColorConst.darkGrey,
    //                             ),
    //                             child: Row(
    //                               mainAxisAlignment: MainAxisAlignment.center,
    //                               children: [
    //                                 Padding(
    //                                   padding:
    //                                       const EdgeInsets.only(right: 8.0),
    //                                   child: Container(
    //                                     height: 0.06.width,
    //                                     width: 0.06.width,
    //                                     alignment: Alignment.bottomRight,
    //                                     decoration: BoxDecoration(
    //                                       shape: BoxShape.circle,
    //                                       image: DecorationImage(
    //                                         fit: BoxFit.cover,
    //                                         image: controller.accountModel
    //                                                     .value!.imageType ==
    //                                                 AccountProfileImageType
    //                                                     .assets
    //                                             ? AssetImage(controller
    //                                                 .accountModel
    //                                                 .value!
    //                                                 .profileImage
    //                                                 .toString())
    //                                             : FileImage(
    //                                                 File(controller.accountModel
    //                                                     .value!.profileImage
    //                                                     .toString()),
    //                                               ) as ImageProvider,
    //                                       ),
    //                                     ),
    //                                   ),
    //                                 ),
    //                                 Text(
    //                                     controller.accountModel.value!.name
    //                                         .toString(),
    //                                     style: titleSmall.copyWith(
    //                                         fontWeight: FontWeight.w500)),
    //                               ],
    //                             ),
    //                           ),
    //                         ),
    //                         Expanded(
    //                           child: Column(
    //                             mainAxisSize: MainAxisSize.max,
    //                             mainAxisAlignment: MainAxisAlignment.end,
    //                             children: [
    //                               Padding(
    //                                 padding: const EdgeInsets.symmetric(
    //                                     horizontal: 24.0),
    //                                 child: Row(
    //                                   mainAxisAlignment:
    //                                       MainAxisAlignment.spaceAround,
    //                                   mainAxisSize: MainAxisSize.max,
    //                                   children: [
    //                                     Expanded(
    //                                         child: SolidButton(
    //                                       borderColor: const Color(0xFFE8A2B9),
    //                                       title: "Cancel",
    //                                       primaryColor: Colors.transparent,
    //                                       onPressed: () {
    //                                         controller.reject();
    //                                       },
    //                                       textColor: const Color(0xFFE8A2B9),
    //                                     )),
    //                                     0.04.hspace,
    //                                     Expanded(
    //                                       child: SolidButton(
    //                                         title: "Connect",
    //                                         primaryColor: ColorConst.Primary,
    //                                         onPressed: () {
    //                                           controller.confirm();
    //                                         },
    //                                       ),
    //                                     ),
    //                                   ],
    //                                 ),
    //                               )
    //                             ],
    //                           ),
    //                         )
    //                       ]),
    //           )),
    //     ));
 
  }
}
