import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/common_widgets/custom_image_widget.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../utils/colors/colors.dart';
import '../../../../../utils/constants/path_const.dart';
import '../../../../../utils/styles/styles.dart';
import '../../../../data/services/create_profile_service/create_profile_service.dart';
import '../../../../data/services/enums/enums.dart';
import '../../../../data/services/service_config/service_config.dart';
import '../../../../data/services/service_models/account_model.dart';
import '../../../common_widgets/bottom_sheet.dart';
import '../../../common_widgets/naan_textfield.dart';
import '../../../send_page/views/pages/contact_page_view.dart';
import '../../../settings_page/controllers/settings_page_controller.dart';

class AccountSelectorSheet extends StatefulWidget {
  final List<AccountModel> accounts;
  final AccountModel selectedAccount;
  const AccountSelectorSheet({
    super.key,
    required this.accounts,
    required this.selectedAccount,
  });

  @override
  State<AccountSelectorSheet> createState() => _AccountSelectorSheetState();
}

class _AccountSelectorSheetState extends State<AccountSelectorSheet> {
  final AccountSummaryController controller =
      Get.find<AccountSummaryController>();
  late int selectedIndex;
  @override
  void initState() {
    selectedIndex = widget.accounts.indexOf(widget.selectedAccount);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        height: 0.5.height,
        width: 1.width,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            color: Colors.black),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.01.width),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              0.01.vspace,
              Center(
                child: Container(
                  height: 5,
                  width: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
                  ),
                ),
              ),
              0.01.vspace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  0.15.hspace,
                  Text(
                    'Accounts',
                    style: titleMedium,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      true ? "Edit" : "Done",
                      style: labelMedium.copyWith(color: ColorConst.Primary),
                    ),
                  ),
                ],
              ),
              0.01.vspace,
              Expanded(
                child: ListView.builder(
                    itemCount: widget.accounts.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                          bottom: 4,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                              onTap: () {
                                setState(() {
                                  controller.userAccount.value =
                                      widget.accounts[index];
                                  selectedIndex = index;
                                  controller
                                    ..fetchAllTokens()
                                    ..fetchAllNfts();
                                });
                              },
                              dense: true,
                              leading: CustomImageWidget(
                                imageType: widget.accounts[index].imageType!,
                                imagePath: widget.accounts[index].profileImage!,
                                imageRadius: 20,
                              ),
                              title: Text(
                                '${widget.accounts[index].name}',
                                style: bodySmall,
                              ),
                              subtitle: Text(
                                '${widget.accounts[index].accountDataModel?.xtzBalance} tez',
                                style: labelSmall.copyWith(
                                    color: ColorConst.NeutralVariant.shade60),
                              ),
                              trailing: Visibility(
                                visible: true,
                                replacement: PopupMenuButton(
                                  position: PopupMenuPosition.under,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  color: const Color(0xff421121),
                                  itemBuilder: (_) => <PopupMenuEntry>[
                                    CustomPopupMenuItem(
                                      height: 51,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 11),
                                      onTap: () {
                                        Get.bottomSheet(
                                          EditAccountBottomSheet(
                                            accountIndex: index,
                                          ),
                                          isScrollControlled: true,
                                          barrierColor: Colors.transparent,
                                        );
                                      },
                                      child: Text(
                                        "Edit Account",
                                        style: labelMedium,
                                      ),
                                    ),
                                    CustomPopupMenuDivider(
                                      height: 1,
                                      color: ColorConst.Neutral.shade50,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 11),
                                      thickness: 1,
                                    ),
                                    CustomPopupMenuItem(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 11),
                                      height: 51,
                                      onTap: () {
                                        Get.bottomSheet(
                                          removeAccountBottomSheet(index,
                                              accountName:
                                                  widget.accounts[index].name!),
                                          barrierColor: Colors.transparent,
                                        );
                                      },
                                      child: Text(
                                        "Delete account",
                                        style: labelMedium.apply(
                                            color: ColorConst.Error.shade60),
                                      ),
                                    ),
                                  ],
                                  child: const Icon(
                                    Icons.more_horiz,
                                    size: 24,
                                    color: Colors.white,
                                  ),
                                ),
                                child: index == selectedIndex
                                    ? Container(
                                        height: 20.sp,
                                        width: 20.sp,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: ColorConst.Primary),
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 14.sp,
                                        ),
                                      )
                                    : const SizedBox(),
                              )),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget removeAccountBottomSheet(int index, {required String accountName}) {
  return NaanBottomSheet(
    bottomSheetHorizontalPadding: 32,
    blurRadius: 5,
    title: "Remove Account",
    titleStyle: titleLarge.copyWith(fontWeight: FontWeight.w700),
    titleAlignment: Alignment.center,
    height: 0.35.height,
    bottomSheetWidgets: [
      Center(
        child: Text(
          'Do you want to remove “$accountName”\nfrom your wallet?',
          style: labelMedium,
          textAlign: TextAlign.center,
        ),
      ),
      0.03.vspace,
      Column(
        children: [
          SolidButton(
            primaryColor: const Color(0xff1E1C1F),
            onPressed: () {},
            title: "Remove Account",
            textColor: ColorConst.Primary,
          ),
          0.01.vspace,
          SolidButton(
            primaryColor: const Color(0xff1E1C1F),
            onPressed: () {
              Get.back();
            },
            title: "Cancel",
          ),
        ],
      ),
    ],
  );
}

class EditAccountBottomSheet extends StatefulWidget {
  final int accountIndex;
  const EditAccountBottomSheet({super.key, required this.accountIndex});

  @override
  State<EditAccountBottomSheet> createState() => _EditAccountBottomSheetState();
}

class _EditAccountBottomSheetState extends State<EditAccountBottomSheet> {
  final _controller = Get.put(SettingsPageController());
  final _accountController = Get.find<AccountSummaryController>();

  @override
  void initState() {
    _controller.accountNameController.text =
        _controller.homePageController.userAccounts[widget.accountIndex].name!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      height: 0.5.height,
      bottomSheetHorizontalPadding: 32,
      crossAxisAlignment: CrossAxisAlignment.center,
      bottomSheetWidgets: [editaccountUI()],
    );
  }

  Widget editaccountUI() {
    return Expanded(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
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
              child: GestureDetector(
                onTap: () {
                  Get.bottomSheet(changePhotoBottomSheet(),
                          barrierColor: Colors.transparent)
                      .whenComplete(() {
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
              padding: EdgeInsets.symmetric(horizontal: 30.sp),
              child: Text(
                _controller.homePageController.userAccounts[widget.accountIndex]
                        .publicKeyHash ??
                    "public key",
                style: labelSmall,
                textAlign: TextAlign.center,
              ),
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
            0.04.vspace,
            SolidButton(
              title: "Save Changes",
              onPressed: () {},
            ),
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
              GestureDetector(
                onTap: () async {
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
              GestureDetector(
                onTap: () async {
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
              GestureDetector(
                onTap: () {
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
