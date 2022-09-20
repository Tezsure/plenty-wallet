import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/create_profile_service/create_profile_service.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';

import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/naan_textfield.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/accounts_widget/controllers/accounts_widget_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class AddNewAccountBottomSheet extends StatelessWidget {
  AddNewAccountBottomSheet({Key? key}) : super(key: key);

  final controller = Get.find<AccountsWidgetController>();

  @override
  Widget build(BuildContext context) {
    controller.initAddAccount();
    return NaanBottomSheet(
      blurRadius: 5,
      height: 0.85.height,
      bottomSheetHorizontalPadding: 32,
      crossAxisAlignment: CrossAxisAlignment.center,
      bottomSheetWidgets: [
        Text(
          "Add New Account",
          style: labelMedium,
        ),
        0.045.vspace,
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
                Get.bottomSheet(changePhotoBottomSheet(),
                    barrierColor: Colors.transparent);
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
        0.038.vspace,
        NaanTextfield(
          hint: "Account Name",
          controller: controller.accountNameController,
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
        0.02.vspace,
        Expanded(
          child: GridView.count(
            physics: BouncingScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 0.06.width,
            shrinkWrap: true,
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
        MaterialButton(
          onPressed: () {},
          color: ColorConst.Primary,
          splashColor: ColorConst.Primary.shade60,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            height: 48,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.transparent,
            ),
            alignment: Alignment.center,
            child: Text(
              "Add",
              style: titleSmall.apply(color: ColorConst.Neutral.shade95),
            ),
          ),
        ),
        0.05.vspace
      ],
    );
  }

  Widget changePhotoBottomSheet() {
    return NaanBottomSheet(
      height: 296,
      //bottomSheetHorizontalPadding: 32,
      bottomSheetWidgets: [
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
                  var imagePath =
                      await CreateProfileService().pickANewImageFromGallery();
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
                    style: labelMedium.apply(color: ColorConst.Error.shade60),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
