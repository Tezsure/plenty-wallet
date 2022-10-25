import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/create_profile_service/create_profile_service.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/naan_textfield.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/create_profile_page/views/avatar_picker_view.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

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
    return DraggableScrollableSheet(
      initialChildSize: isBottomSheet ? 0.95 : 1,
      minChildSize: isBottomSheet ? 0.9 : 1,
      maxChildSize: isBottomSheet ? 0.95 : 1,
      builder: (context, scrollController) => Container(
        color: Colors.black,
        width: 1.width,
        height: 1.height,
        padding: EdgeInsets.symmetric(horizontal: 16.5.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            0.04.vspace,
            backButton(),
            0.05.vspace,
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Name your account", style: titleLarge),
            ),
            0.05.vspace,
            Obx(
              () => Center(
                child: Container(
                  height: 120.sp,
                  width: 120.sp,
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
                      Get.bottomSheet(
                        changePhotoBottomSheet(),
                        barrierColor: Colors.white.withOpacity(0.01),
                        isScrollControlled: true,
                      );
                    },
                    child: CircleAvatar(
                      radius: 20.sp,
                      backgroundColor: Colors.white,
                      child: SvgPicture.asset(
                        "${PathConst.SVG}add_photo.svg",
                        fit: BoxFit.contain,
                        height: 12.sp,
                        color: ColorConst.Primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            0.05.vspace,
            Center(
              child: NaanTextfield(
                backgroundColor: const Color(0xff1E1C1F),
                hint: "Account Name",
                focusNode: controller.accountNameFocus,
                controller: controller.accountNameController,
                onTextChange: (String value) => controller
                    .isContiuneButtonEnable
                    .value = value.length > 2 && value.length < 20,
              ),
            ),
            const Spacer(),
            Obx(
              () => Center(
                child: Container(
                  margin: EdgeInsets.only(
                    left: 14.sp,
                    right: 14.sp,
                  ),
                  child: SolidButton(
                    height: 40.sp,
                    width: 326.sp,
                    active: controller.isContiuneButtonEnable.value,
                    onPressed: () {
                      if (controller.previousRoute ==
                              Routes.CREATE_WALLET_PAGE ||
                          controller.previousRoute ==
                              Routes.IMPORT_WALLET_PAGE) {
                        Get.toNamed(Routes.LOADING_PAGE, arguments: [
                          'assets/create_wallet/lottie/wallet_success.json',
                          controller.previousRoute,
                          Routes.HOME_PAGE,
                        ]);
                      } else if (controller.previousRoute == Routes.HOME_PAGE) {
                        Get.toNamed(Routes.LOADING_PAGE, arguments: [
                          'assets/create_wallet/lottie/wallet_success.json',
                          Routes.IMPORT_WALLET_PAGE,
                          null,
                        ]);
                      } else if (controller.previousRoute ==
                          Routes.ACCOUNT_SUMMARY) {
                        Get.toNamed(Routes.LOADING_PAGE, arguments: [
                          'assets/create_wallet/lottie/wallet_success.json',
                          Routes.IMPORT_WALLET_PAGE,
                          null,
                        ]);
                      }
                    },
                    inActiveChild: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "${PathConst.SVG}check.svg",
                          color: Colors.white,
                          height: 16.6.sp,
                          fit: BoxFit.contain,
                        ),
                        0.015.hspace,
                        Text(
                          "Start using Naan",
                          style:
                              titleSmall.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "${PathConst.SVG}check.svg",
                          height: 16.6.sp,
                          color: Colors.white,
                        ),
                        0.02.hspace,
                        Text(
                          "Start using Naan",
                          style:
                              titleSmall.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            0.05.vspace
          ],
        ),
      ),
    );
  }

  Widget changePhotoBottomSheet() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            color: Colors.black),
        width: 1.width,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
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
              0.03.vspace,
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        var imagePath = await CreateProfileService()
                            .pickANewImageFromGallery();
                        if (imagePath.isNotEmpty) {
                          controller.currentSelectedType =
                              AccountProfileImageType.file;
                          controller.selectedImagePath.value = imagePath;
                          Get.back();
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 51,
                        alignment: Alignment.center,
                        child: Text(
                          "Choose from Library",
                          style: labelMedium,
                        ),
                      ),
                    ),
                    const Divider(
                      color: Color(0xff4a454e),
                      height: 1,
                      thickness: 1,
                    ),
                    GestureDetector(
                      onTap: () async {
                        Get.to(const AvatarPickerView());
                      },
                      child: Container(
                        width: double.infinity,
                        height: 51,
                        alignment: Alignment.center,
                        child: Text(
                          "Pick an avatar",
                          style: labelMedium,
                        ),
                      ),
                    ),
                    if (controller.currentSelectedType ==
                        AccountProfileImageType.file)
                      Column(
                        children: [
                          const Divider(
                            color: Color(0xff4a454e),
                            height: 1,
                            thickness: 1,
                          ),
                          GestureDetector(
                            onTap: () {
                              controller.currentSelectedType =
                                  AccountProfileImageType.assets;
                              controller.selectedImagePath.value =
                                  ServiceConfig.allAssetsProfileImages[0];
                              Get.back();
                            },
                            child: Container(
                              width: double.infinity,
                              height: 51,
                              alignment: Alignment.center,
                              child: Text(
                                "Remove photo",
                                style: labelMedium.apply(
                                    color: ColorConst.Error.shade60),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              0.016.vspace,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    height: 51,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                    ),
                    child: Text(
                      "Cancel",
                      style: labelMedium.apply(color: Colors.white),
                    ),
                  ),
                ),
              ),
              0.063.vspace,
            ],
          ),
        ),
      ),
    );
  }
}
