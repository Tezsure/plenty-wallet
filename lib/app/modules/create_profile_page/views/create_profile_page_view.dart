import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/create_profile_service/create_profile_service.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/modules/common_widgets/naan_textfield.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../utils/styles/styles.dart';
import '../controllers/create_profile_page_controller.dart';

class CreateProfilePageView extends GetView<CreateProfilePageController> {
  const CreateProfilePageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as List;
    controller.previousRoute = args[0] as String;
    return Container(
      decoration: const BoxDecoration(gradient: GradConst.GradientBackground),
      width: 1.width,
      padding: EdgeInsets.symmetric(horizontal: 0.05.width),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          0.1.vspace,
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Create Profile", style: titleLarge),
          ),
          0.05.vspace,
          Obx(
            () => Container(
              height: 0.3.width,
              width: 0.3.width,
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
                  Get.bottomSheet(changePhotoBottomSheet());
                },
                child: CircleAvatar(
                  radius: 0.046.width,
                  backgroundColor: Colors.white,
                  child: SvgPicture.asset(
                    "${PathConst.SVG}add_photo.svg",
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            ),
          ),
          0.05.vspace,
          NaanTextfield(
            hint: "Account Name",
            controller: controller.accountNameController,
            onTextChange: (String value) => controller.isContiuneButtonEnable
                .value = value.length > 2 && value.length < 20,
          ),
          0.02.vspace,
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "or  choose a avatar",
              textAlign: TextAlign.left,
              style: labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
            ),
          ),
          0.03.vspace,
          Expanded(
            child: GridView.count(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              crossAxisCount: 4,
              mainAxisSpacing: 0.06.width,
              crossAxisSpacing: 0.06.width,
              children: List.generate(
                ServiceConfig.allAssetsProfileImages.length,
                (index) => GestureDetector(
                  onTap: () {
                    controller.currentSelectedType =
                        AccountProfileImageType.assets;
                    controller.selectedImagePath.value =
                        ServiceConfig.allAssetsProfileImages[index];
                  },
                  child: CircleAvatar(
                    radius: 0.08.width,
                    child: Image.asset(
                      ServiceConfig.allAssetsProfileImages[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Obx(
            () => SolidButton(
              active: controller.isContiuneButtonEnable.value,
              onPressed: () {
                if (controller.previousRoute == Routes.CREATE_WALLET_PAGE ||
                    controller.previousRoute == Routes.IMPORT_WALLET_PAGE) {
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
                }
                // controller.startUsingNaanwallet()
                // Get.toNamed(Routes.HOME_PAGE, arguments: [true]);
              },
              inActiveChild: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline_outlined,
                    color: ColorConst.Primary.shade95,
                    size: 20,
                  ),
                  0.02.hspace,
                  Text(
                    "Start using Naan wallet",
                    style: titleSmall.apply(color: ColorConst.Primary.shade95),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline_outlined,
                    color: ColorConst.Primary.shade95,
                    size: 20,
                  ),
                  0.02.hspace,
                  Text(
                    "Start using Naan wallet",
                    style: titleSmall.apply(color: ColorConst.Primary.shade95),
                  ),
                ],
              ),
            ),
          ),
          0.05.vspace
        ],
      ),
    );
  }

  Widget changePhotoBottomSheet() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xff07030c).withOpacity(0.49),
              const Color(0xff2d004f),
            ],
          ),
        ),
        width: 1.width,
        height: 296,
        padding: const EdgeInsets.symmetric(horizontal: 32),
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
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Change profile photo",
                textAlign: TextAlign.start,
                style: titleLarge,
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
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Choose photo",
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
                      var imagePath = await CreateProfileService().takeAPhoto();
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
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Take photo",
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
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Remove current photo",
                        style:
                            labelMedium.apply(color: ColorConst.Error.shade60),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
