import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/create_profile_service/create_profile_service.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/common_widgets/naan_textfield.dart';

import 'package:naan_wallet/app/modules/settings_page/controllers/settings_page_controller.dart';
import 'package:naan_wallet/app/modules/settings_page/widget/flutter_switch.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class EditAccountBottomSheet extends StatefulWidget {
  final int accountIndex;
  const EditAccountBottomSheet({super.key, required this.accountIndex});

  @override
  State<EditAccountBottomSheet> createState() => _EditAccountBottomSheetState();
}

class _EditAccountBottomSheetState extends State<EditAccountBottomSheet> {
  final _controller = Get.find<SettingsPageController>();

  @override
  void initState() {
    _controller.accountNameController.text =
        _controller.homePageController.userAccounts[widget.accountIndex].name!;
    super.initState();
  }

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
        physics: AppConstant.scrollPhysics,
        child: Builder(builder: (context) {
          return Column(children: [
            Container(
              height: 0.3.width,
              width: 0.3.width,
              alignment: Alignment.bottomRight,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image:
                      _controller.showUpdatedProfilePhoto(widget.accountIndex),
                ),
              ),
              child: BouncingWidget(
                onPressed: () {
                  CommonFunctions.bottomSheet(
                    changePhotoBottomSheet(),
                  ).whenComplete(() {
                    setState(() {});
                  });
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
            0.02.vspace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.arP),
              child: Text(
                _controller.homePageController.userAccounts[widget.accountIndex]
                        .publicKeyHash ??
                    "public key",
                style: bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              "Address index : ${widget.accountIndex}",
              style: labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              "Derivation path: ${_controller.homePageController.userAccounts[widget.accountIndex].derivationPathIndex}",
              style: labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
            ),
            0.02.vspace,
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Account Name",
                style:
                    labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            NaanTextfield(
                hint: "Account Name",
                controller: _controller.accountNameController,
                onSubmitted: (val) {
                  setState(() {
                    _controller.editAccountName(widget.accountIndex, val);
                  });
                }),
            0.02.vspace,
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "or choose a avatar",
                textAlign: TextAlign.left,
                style:
                    labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
              ),
            ),
            0.02.vspace,
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              mainAxisSpacing: 0.06.width,
              shrinkWrap: true,
              crossAxisSpacing: 0.06.width,
              children: List.generate(
                ServiceConfig.allAssetsProfileImages.length,
                (index) => BouncingWidget(
                  onPressed: () {
                    setState(() {
                      _controller.editUserProfilePhoto(
                          imageType: AccountProfileImageType.assets,
                          imagePath:
                              ServiceConfig.allAssetsProfileImages[index],
                          accountIndex: widget.accountIndex);
                    });
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
                const Spacer(),
                FlutterSwitch(
                  value: _controller.homePageController
                      .userAccounts[widget.accountIndex].isAccountPrimary!,
                  onToggle: (value) {
                    setState(() {
                      _controller.editPrimaryAccountStatus(widget.accountIndex);
                    });
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
                const Spacer(),
                Obx(() => FlutterSwitch(
                      value: _controller.homePageController
                          .userAccounts[widget.accountIndex].isAccountHidden!,
                      onToggle: (value) {
                        setState(() {
                          _controller
                              .editHideThisAccountStatus(widget.accountIndex);
                        });
                      },
                      height: 18,
                      width: 32,
                      padding: 2,
                      toggleSize: 14,
                      activeColor: ColorConst.Primary.shade50,
                      activeToggleColor: ColorConst.Primary.shade90,
                      inactiveColor: ColorConst.Neutral.shade0,
                      inactiveToggleColor: ColorConst.NeutralVariant.shade40,
                    )),
              ],
            ),
            0.02.vspace,
          ]);
        }),
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
              BouncingWidget(
                onPressed: () async {
                  String imagePath =
                      await CreateProfileService().pickANewImageFromGallery();
                  if (imagePath.isNotEmpty) {
                    _controller.editUserProfilePhoto(
                        imageType: AccountProfileImageType.file,
                        imagePath: imagePath,
                        accountIndex: widget.accountIndex);

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
              BouncingWidget(
                onPressed: () async {
                  String imagePath = await CreateProfileService().takeAPhoto();

                  if (imagePath.isNotEmpty) {
                    _controller.editUserProfilePhoto(
                        imageType: AccountProfileImageType.file,
                        imagePath: imagePath,
                        accountIndex: widget.accountIndex);

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
              BouncingWidget(
                onPressed: () {
                  _controller.editUserProfilePhoto(
                      imageType: AccountProfileImageType.assets,
                      imagePath: ServiceConfig.allAssetsProfileImages[0],
                      accountIndex: widget.accountIndex);

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
