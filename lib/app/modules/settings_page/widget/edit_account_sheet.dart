import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/create_profile_service/create_profile_service.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/naan_textfield.dart';
import 'package:naan_wallet/app/modules/settings_page/controllers/edit_account_controller.dart';
import 'package:naan_wallet/app/modules/settings_page/controllers/manage_account_controller.dart';
import 'package:naan_wallet/app/modules/settings_page/widget/flutter_switch.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class EditAccountBottomSheet extends StatelessWidget {
  EditAccountBottomSheet({Key? key, required this.accountIndex})
      : super(key: key);

  final int accountIndex;

  final manageAccountPageController = Get.find<ManageAccountPageController>();
  final editAccountPageController = Get.put(EditAccountPageController());

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      height: 0.87.height,
      bottomSheetHorizontalPadding: 32,
      crossAxisAlignment: CrossAxisAlignment.center,
      bottomSheetWidgets: [editaccountUI()],
    );
  }

  Widget editaccountUI() {
    return Expanded(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(children: [
          Obx(
            () => Container(
              height: 0.3.width,
              width: 0.3.width,
              alignment: Alignment.bottomRight,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: editAccountPageController.currentSelectedType ==
                          AccountProfileImageType.assets
                      ? AssetImage(
                          editAccountPageController.selectedImagePath.value)
                      : FileImage(
                          File(
                            editAccountPageController.selectedImagePath.value,
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
          0.02.vspace,
          Text(
            manageAccountPageController.accounts[accountIndex].accountSecretModel!.publicKey ??
                "public key",
            style: bodyLarge,
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            "Address index : $accountIndex",
            style: labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            "Derivation path: m/44’/60’/0’0",
            style: labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
          ),
          0.02.vspace,
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Account Name",
              style: labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          NaanTextfield(
            hint: "Account Name",
            controller: editAccountPageController.accountNameController,
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
          GridView.count(
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 0.06.width,
            shrinkWrap: true,
            crossAxisSpacing: 0.06.width,
            children: List.generate(
              ServiceConfig.allAssetsProfileImages.length,
              (index) => GestureDetector(
                onTap: () {
                  editAccountPageController.currentSelectedType =
                      AccountProfileImageType.assets;
                  editAccountPageController.selectedImagePath.value =
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
          0.04.vspace,
          Row(
            children: [
              Text(
                "Primary Account",
                textAlign: TextAlign.left,
                style: bodySmall,
              ),
              Spacer(),
              Obx(
                () => FlutterSwitch(
                  value: editAccountPageController.isPrimaryAccount.value,
                  onToggle: (value) {
                    editAccountPageController.isPrimaryAccount.value =
                        !editAccountPageController.isPrimaryAccount.value;
                  },
                  height: 18,
                  width: 32,
                  padding: 2,
                  toggleSize: 14,
                  activeColor: ColorConst.Primary.shade50,
                  activeToggleColor: ColorConst.Primary.shade90,
                  inactiveColor: ColorConst.Neutral.shade0,
                  inactiveToggleColor: ColorConst.NeutralVariant.shade40,
                ),
              )
            ],
          ),
          0.02.vspace,
          Row(
            children: [
              Text(
                "Hide this account",
                textAlign: TextAlign.left,
                style: bodySmall,
              ),
              Spacer(),
              Obx(
                () => FlutterSwitch(
                  value: editAccountPageController.isHiddenAccount.value,
                  onToggle: (value) {
                    editAccountPageController.isHiddenAccount.value =
                        !editAccountPageController.isHiddenAccount.value;
                  },
                  height: 18,
                  width: 32,
                  padding: 2,
                  toggleSize: 14,
                  activeColor: ColorConst.Primary.shade50,
                  activeToggleColor: ColorConst.Primary.shade90,
                  inactiveColor: ColorConst.Neutral.shade0,
                  inactiveToggleColor: ColorConst.NeutralVariant.shade40,
                ),
              )
            ],
          ),
          0.02.vspace,
        ]),
      ),
    );
  }

  Widget changePhotoBottomSheet() {
    return NaanBottomSheet(
      height: 296,
      bottomSheetHorizontalPadding: 32,
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
                    editAccountPageController.currentSelectedType =
                        AccountProfileImageType.file;
                    editAccountPageController.selectedImagePath.value =
                        imagePath;
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
                    editAccountPageController.currentSelectedType =
                        AccountProfileImageType.file;
                    editAccountPageController.selectedImagePath.value =
                        imagePath;
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
                  editAccountPageController.currentSelectedType =
                      AccountProfileImageType.assets;
                  editAccountPageController.selectedImagePath.value =
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
