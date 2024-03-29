import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:plenty_wallet/app/data/services/create_profile_service/create_profile_service.dart';
import 'package:plenty_wallet/app/data/services/enums/enums.dart';
import 'package:plenty_wallet/app/data/services/service_config/service_config.dart';
import 'package:plenty_wallet/app/modules/common_widgets/back_button.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:plenty_wallet/app/modules/common_widgets/image_picker.dart';
import 'package:plenty_wallet/app/modules/common_widgets/naan_textfield.dart';
import 'package:plenty_wallet/app/modules/common_widgets/pick_an_avatar.dart';
import 'package:plenty_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:plenty_wallet/app/modules/common_widgets/text_scale_factor.dart';
import 'package:plenty_wallet/app/routes/app_pages.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/common_functions.dart';
import 'package:plenty_wallet/utils/constants/constants.dart';
import 'package:plenty_wallet/utils/constants/path_const.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/utils.dart';

import '../../../../utils/styles/styles.dart';
import '../controllers/create_profile_page_controller.dart';

class CreateProfilePageView extends GetView<CreateProfilePageController> {
  final bool isBottomSheet;
  const CreateProfilePageView({super.key, this.isBottomSheet = false});
  @override
  Widget build(BuildContext context) {
    isBottomSheet ? Get.put(CreateProfilePageController()) : null;
    var args = ModalRoute.of(context)!.settings.arguments as List;
    controller.previousRoute = args[0] as String;
    if (isBottomSheet) {
      return NaanBottomSheet(
        bottomSheetHorizontalPadding: 16.arP,
        // isScrollControlled: true,
        height: AppConstant.naanBottomSheetHeight,
        bottomSheetWidgets: [
          SizedBox(
              height: AppConstant.naanBottomSheetChildHeight -
                  MediaQuery.of(context).viewInsets.bottom,
              child: _buildBody())
        ],
      );
    }
    return OverrideTextScaleFactor(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.arP),
          child: SafeArea(bottom: false, child: _buildBody()),
        ),
      ),
    );
  }

  Column _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        0.02.vspace,
        backButton(),
        0.02.vspace,
        Align(
          alignment: Alignment.centerLeft,
          child: Text("Name your wallet".tr, style: titleLarge),
        ),
        0.05.vspace,
        Obx(
          () => Center(
            child: Container(
              height: 120.arP,
              width: 120.arP,
              alignment: Alignment.bottomRight,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: controller.currentSelectedType ==
                          AccountProfileImageType.assets
                      ? AssetImage(controller.selectedImagePath.value)
                      : FileImage(
                          File(
                            controller.selectedImagePath.value,
                          ),
                        ) as ImageProvider,
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  CommonFunctions.bottomSheet(
                    changePhotoBottomSheet(),
                  );
                },
                child: CircleAvatar(
                  radius: 20.arP,
                  backgroundColor: Colors.white,
                  child: SvgPicture.asset(
                    "${PathConst.SVG}add_photo.svg",
                    fit: BoxFit.contain,
                    height: 20.arP,
                    color: ColorConst.Primary,
                  ),
                ),
              ),
            ),
          ),
        ),
        0.05.vspace,
        NaanTextfield(
          // height: 52.arP,
          backgroundColor: const Color(0xff1E1C1F),
          hint: "Wallet Name",
          maxLen: 28,
          focusNode: controller.accountNameFocus,
          controller: controller.accountNameController,
          onTextChange: (String value) {
            if (value.removeSpecialChars != value) {
              controller.accountNameController.text = value.removeSpecialChars;
              controller.accountNameController.selection =
                  TextSelection.fromPosition(TextPosition(
                      offset: controller.accountNameController.text.length));
              value = value.removeSpecialChars;
            }
            return controller.isContiuneButtonEnable.value =
                value.length > 2 && value.length < 20;
          },
        ),
        const Spacer(),
        Obx(
          () => Center(
            child: Container(
              margin: EdgeInsets.only(
                left: 16.arP,
                right: 16.arP,
              ),
              child: SolidButton(
                // width: 326.arP,
                active: controller.isContiuneButtonEnable.value,
                onPressed: () {
                  if (controller.previousRoute == Routes.CREATE_WALLET_PAGE ||
                      controller.previousRoute == Routes.IMPORT_WALLET_PAGE) {
                    Get.toNamed(Routes.LOADING_PAGE, arguments: [
                      'assets/create_wallet/lottie/loading_animation.json',
                      controller.previousRoute,
                      Routes.HOME_PAGE,
                    ]);
                  } else
                  // if (controller.previousRoute ==
                  //     Routes.HOME_PAGE)
                  {
                    Get.toNamed(Routes.LOADING_PAGE, arguments: [
                      'assets/create_wallet/lottie/loading_animation.json',
                      Routes.IMPORT_WALLET_PAGE,
                      null,
                    ]);
                  }
                  // } else if (controller.previousRoute ==
                  //     Routes.ACCOUNT_SUMMARY) {
                  //   Get.toNamed(Routes.LOADING_PAGE, arguments: [
                  //     'assets/create_wallet/lottie/loading_animation.json',
                  //     Routes.IMPORT_WALLET_PAGE,
                  //     null,
                  //   ]);
                  // }
                },
                inActiveChild: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "${PathConst.SVG}check.svg",
                      color: !controller.isContiuneButtonEnable.value
                          ? ColorConst.textGrey1
                          : Colors.white,
                      height: 16.6.arP,
                      fit: BoxFit.contain,
                    ),
                    0.015.hspace,
                    Text(
                      "Start using Plenty Wallet".tr,
                      style: titleSmall.copyWith(
                          color: !controller.isContiuneButtonEnable.value
                              ? ColorConst.textGrey1
                              : Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "${PathConst.SVG}check.svg",
                      height: 16.6.arP,
                      color: !controller.isContiuneButtonEnable.value
                          ? ColorConst.textGrey1
                          : Colors.white,
                    ),
                    0.02.hspace,
                    Text(
                      "Start using Plenty Wallet".tr,
                      style: titleSmall.copyWith(
                          color: !controller.isContiuneButtonEnable.value
                              ? ColorConst.textGrey1
                              : Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const BottomButtonPadding()
      ],
    );
  }

  Widget changePhotoBottomSheet() {
    return ImagePickerSheet(
      onGallerySelect: () async {
        var imagePath = await CreateProfileService().pickANewImageFromGallery();
        if (imagePath.isNotEmpty) {
          controller.currentSelectedType = AccountProfileImageType.file;
          controller.selectedImagePath.value = imagePath;
          Get.back();
        }
      },
      onPickAvatarSelect: () async {
        CommonFunctions.bottomSheet(
          avatarPicker(),
        );
        // Get.to(const AvatarPickerView());
      },
      onRemoveImage: controller.currentSelectedType ==
              AccountProfileImageType.file
          ? () {
              controller.currentSelectedType = AccountProfileImageType.assets;
              controller.selectedImagePath.value =
                  ServiceConfig.allAssetsProfileImages[0];
              Get.back();
            }
          : null,
    );
    // return BackdropFilter(
    //   filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
    //   child: Container(
    //     decoration: const BoxDecoration(
    //         borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
    //         color: Colors.black),
    //     width: 1.width,
    //     padding: const EdgeInsets.symmetric(horizontal: 16),
    //     child: SingleChildScrollView(
    //       child: Column(
    //         children: [
    //           0.005.vspace,
    //           Container(
    //             height: 5.arP,
    //             width: 36.arP,
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(5),
    //               color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
    //             ),
    //           ),
    //           0.03.vspace,
    //           Container(
    //             width: double.infinity,
    //             padding: const EdgeInsets.symmetric(
    //               horizontal: 12,
    //             ),
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(8),
    //               color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
    //             ),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 GestureDetector(
    //                   onTap: () async {
    //                     var imagePath = await CreateProfileService()
    //                         .pickANewImageFromGallery();
    //                     if (imagePath.isNotEmpty) {
    //                       controller.currentSelectedType =
    //                           AccountProfileImageType.file;
    //                       controller.selectedImagePath.value = imagePath;
    //                       Get.back();
    //                     }
    //                   },
    //                   child: Container(
    //                     width: double.infinity,
    //                     height: 51,
    //                     alignment: Alignment.center,
    //                     child: Text(
    //                       "Choose from library",
    //                       style: labelMedium,
    //                     ),
    //                   ),
    //                 ),
    //                 const Divider(
    //                   color: Color(0xff4a454e),
    //                   height: 1,
    //                   thickness: 1,
    //                 ),
    //                 GestureDetector(
    //                   onTap: () async {
    //                     Get.bottomSheet(
    //                       avatarPicker(),
    //                       isScrollControlled: true,
    //                       enterBottomSheetDuration:
    //                           const Duration(milliseconds: 180),
    //                       exitBottomSheetDuration:
    //                           const Duration(milliseconds: 150),
    //                     );
    //                     // Get.to(const AvatarPickerView());
    //                   },
    //                   child: Container(
    //                     width: double.infinity,
    //                     height: 51,
    //                     alignment: Alignment.center,
    //                     child: Text(
    //                       "Pick an avatar",
    //                       style: labelMedium,
    //                     ),
    //                   ),
    //                 ),
    //                 if (controller.currentSelectedType ==
    //                     AccountProfileImageType.file)
    //                   Column(
    //                     children: [
    //                       const Divider(
    //                         color: Color(0xff4a454e),
    //                         height: 1,
    //                         thickness: 1,
    //                       ),
    //                       GestureDetector(
    //                         onTap: () {
    //                           controller.currentSelectedType =
    //                               AccountProfileImageType.assets;
    //                           controller.selectedImagePath.value =
    //                               ServiceConfig.allAssetsProfileImages[0];
    //                           Get.back();
    //                         },
    //                         child: Container(
    //                           width: double.infinity,
    //                           height: 51,
    //                           alignment: Alignment.center,
    //                           child: Text(
    //                             "Remove photo",
    //                             style: labelMedium.apply(
    //                                 color: ColorConst.Error.shade60),
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //               ],
    //             ),
    //           ),
    //           0.016.vspace,
    //           Padding(
    //             padding: const EdgeInsets.symmetric(horizontal: 16),
    //             child: GestureDetector(
    //               onTap: () => Get.back(),
    //               child: Container(
    //                 height: 51,
    //                 alignment: Alignment.center,
    //                 decoration: BoxDecoration(
    //                   borderRadius: BorderRadius.circular(8),
    //                   color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
    //                 ),
    //                 child: Text(
    //                   "Cancel",
    //                   style: labelMedium.apply(color: Colors.white),
    //                 ),
    //               ),
    //             ),
    //           ),
    //           0.063.vspace,
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  Widget avatarPicker() {
    return PickAvatar(
      selectedAvatar: controller.selectedImagePath.value,
      imageType: controller.currentSelectedType,
      onConfirm: (String selectedAvatar) {
        controller.currentSelectedType == AccountProfileImageType.assets;
        controller.selectedImagePath.value = selectedAvatar;

        Get.back();
        Get.back();
      },
    );
  }
}
