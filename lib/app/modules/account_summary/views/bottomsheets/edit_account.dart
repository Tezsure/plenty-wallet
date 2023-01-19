import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/send_page/views/widgets/transaction_status.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../utils/colors/colors.dart';
import '../../../../../utils/constants/path_const.dart';
import '../../../../../utils/styles/styles.dart';
import '../../../../data/services/create_profile_service/create_profile_service.dart';
import '../../../../data/services/enums/enums.dart';
import '../../../../data/services/service_config/service_config.dart';
import '../../../common_widgets/naan_textfield.dart';
import '../../../common_widgets/solid_button.dart';
import '../../../settings_page/controllers/settings_page_controller.dart';
import '../../controllers/account_summary_controller.dart';

class EditAccountBottomSheet extends StatefulWidget {
  final int accountIndex;
  const EditAccountBottomSheet({super.key, required this.accountIndex});

  @override
  State<EditAccountBottomSheet> createState() => _EditAccountBottomSheetState();
}

class _EditAccountBottomSheetState extends State<EditAccountBottomSheet> {
  final _controller = Get.find<SettingsPageController>();
  final AccountSummaryController _accountController =
      Get.find<AccountSummaryController>();
  FocusNode nameFocusNode = FocusNode();
  bool isNameEmpty = false;

  @override
  void initState() {
    _controller.accountNameController.removeListener(() {});
    nameFocusNode.requestFocus();
    _controller.accountNameController.text =
        _controller.homePageController.userAccounts[widget.accountIndex].name!;
    _controller.accountNameController.addListener(() {
      setState(() {
        _controller.accountNameController.text.isEmpty
            ? isNameEmpty = true
            : isNameEmpty = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return draggableUI();
  }

  Widget draggableUI() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20.arP, sigmaY: 20.arP),
      child: DraggableScrollableSheet(
        maxChildSize: 0.9,
        initialChildSize: 0.8,
        minChildSize: 0.8,
        builder: ((context, scrollController) => SingleChildScrollView(
              controller: scrollController,
              child: Container(
                width: 1.width,
                padding: EdgeInsets.symmetric(horizontal: 31.aR),
                height: 1.height,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10.aR)),
                    color: Colors.black),
                child: Column(children: [
                  0.02.vspace,
                  Center(
                    child: Container(
                      height: 5.aR,
                      width: 36.aR,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.aR),
                          color: const Color(0xffEBEBF5).withOpacity(0.3)),
                    ),
                  ),
                  0.036.vspace,
                  Text("Edit Account",
                      style: titleLarge.copyWith(fontSize: 22.aR)),
                  0.031.vspace,
                  Container(
                    height: 120.aR,
                    width: 120.aR,
                    alignment: Alignment.bottomRight,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: _controller
                            .showUpdatedProfilePhoto(widget.accountIndex),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Get.bottomSheet(
                          changePhotoBottomSheet(),
                          barrierColor: Colors.transparent,
                          enterBottomSheetDuration:
                              const Duration(milliseconds: 180),
                          exitBottomSheetDuration:
                              const Duration(milliseconds: 150),
                        ).whenComplete(() {
                          setState(() {});
                        });
                      },
                      child: CircleAvatar(
                        radius: 20.aR,
                        backgroundColor: Colors.white,
                        child: SvgPicture.asset(
                          "${PathConst.SVG}add_photo.svg",
                          fit: BoxFit.contain,
                          height: 20.aR,
                        ),
                      ),
                    ),
                  ),
                  0.02.vspace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.arP),
                    child: Text(
                      _controller
                              .homePageController
                              .userAccounts[widget.accountIndex]
                              .publicKeyHash ??
                          "public key",
                      style: labelMedium.copyWith(fontSize: 12.aR),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  0.02.vspace,
                  SizedBox(
                    height: 8.aR,
                  ),
                  NaanTextfield(
                      height: 50.aR,
                      backgroundColor:
                          ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                      hint: "Account Name",
                      focusNode: nameFocusNode,
                      controller: _controller.accountNameController,
                      onSubmitted: (value) {
                        setState(() {
                          if (_accountController.homePageController
                              .userAccounts[widget.accountIndex].publicKeyHash!
                              .contains(_accountController
                                  .selectedAccount.value.publicKeyHash!)) {
                            if (value.isNotEmpty) {
                              _accountController.selectedAccount.update((val) {
                                val!.name = value;
                              });
                            }
                          }
                          if (value.isNotEmpty) {
                            _controller.editAccountName(
                                widget.accountIndex, value);
                          }
                        });
                      }),
                  0.044.vspace,
                  SolidButton(
                    height: 50.aR,
                    width: 0.8.width,
                    primaryColor:
                        _controller.accountNameController.value.text.isNotEmpty
                            ? ColorConst.Primary
                            : const Color(0xFF1E1C1F),
                    title: "Save Changes",
                    titleStyle: labelLarge.copyWith(fontSize: 14.aR),
                    onPressed: () {
                      if (_controller.homePageController.userAccounts.any(
                          (element) =>
                              (element.name?.toLowerCase() ?? "") ==
                                  _controller.accountNameController.value.text
                                      .toLowerCase() &&
                              (element.publicKeyHash !=
                                  _controller
                                      .homePageController
                                      .userAccounts[widget.accountIndex]
                                      .publicKeyHash))) {
                        transactionStatusSnackbar(
                          duration: const Duration(seconds: 2),
                          status: TransactionStatus.error,
                          tezAddress: 'Account with same name already exists',
                          transactionAmount: 'Cannot save account changes',
                        );
                        return;
                      }
                      if (_controller
                          .accountNameController.value.text.isNotEmpty) {
                        _accountController.changeSelectedAccountName(
                            accountIndex: widget.accountIndex,
                            changedValue:
                                _controller.accountNameController.value.text);
                        _controller.editAccountName(widget.accountIndex,
                            _controller.accountNameController.value.text);
                      }
                    },
                  ),
                  0.02.vspace,
                ]),
              ),
            )),
      ),
    );
  }

  Widget editaccountUI() {
    return Material(
      color: Colors.transparent,
      child: SingleChildScrollView(
        child: Column(children: [
          0.01.vspace,
          Text("Edit Account", style: titleLarge),
          0.02.vspace,
          Container(
            height: 0.3.width,
            width: 0.3.width,
            alignment: Alignment.bottomRight,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: _controller.showUpdatedProfilePhoto(widget.accountIndex),
              ),
            ),
            child: GestureDetector(
              onTap: () {
                Get.bottomSheet(
                  changePhotoBottomSheet(),
                  barrierColor: Colors.transparent,
                  enterBottomSheetDuration: const Duration(milliseconds: 180),
                  exitBottomSheetDuration: const Duration(milliseconds: 150),
                ).whenComplete(() {
                  setState(() {});
                });
              },
              child: CircleAvatar(
                radius: 0.046.width,
                backgroundColor: Colors.white,
                child: SvgPicture.asset(
                  "${PathConst.SVG}add_photo.svg",
                  fit: BoxFit.contain,
                  height: 20.arP,
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
              style: labelMedium.copyWith(fontSize: 10.arP),
              textAlign: TextAlign.center,
            ),
          ),
          0.02.vspace,
          const SizedBox(
            height: 8,
          ),
          NaanTextfield(
              height: 52.arP,
              backgroundColor:
                  ColorConst.NeutralVariant.shade60.withOpacity(0.2),
              hint: "Account Name",
              focusNode: nameFocusNode,
              controller: _controller.accountNameController,
              onSubmitted: (value) {
                setState(() {
                  if (_accountController.homePageController
                      .userAccounts[widget.accountIndex].publicKeyHash!
                      .contains(_accountController
                          .selectedAccount.value.publicKeyHash!)) {
                    if (value.isNotEmpty) {
                      _accountController.selectedAccount.update((val) {
                        val!.name = value;
                      });
                    }
                  }
                  if (value.isNotEmpty) {
                    _controller.editAccountName(widget.accountIndex, value);
                  }
                });
              }),
          0.04.vspace,
          SolidButton(
            height: 40.arP,
            primaryColor:
                _controller.accountNameController.value.text.isNotEmpty
                    ? ColorConst.Primary
                    : const Color(0xFF1E1C1F),
            title: "Save Changes",
            titleStyle: labelLarge,
            onPressed: () {
              if (_controller.accountNameController.value.text.isNotEmpty) {
                _accountController.changeSelectedAccountName(
                    accountIndex: widget.accountIndex,
                    changedValue: _controller.accountNameController.value.text);
                _controller.editAccountName(widget.accountIndex,
                    _controller.accountNameController.value.text);
              }
            },
          ),
        ]),
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
        height: 275.aR,
        padding: EdgeInsets.symmetric(horizontal: 16.arP),
        child: Column(
          children: [
            0.005.vspace,
            Container(
              height: 5.aR,
              width: 36.aR,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
              ),
            ),
            0.03.vspace,
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 12.aR,
              ),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(8.aR),
              //   color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
              // ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      var imagePath = await CreateProfileService()
                          .pickANewImageFromGallery();
                      if (imagePath.isNotEmpty) {
                        _controller.editUserProfilePhoto(
                            accountIndex: widget.accountIndex,
                            imagePath: imagePath,
                            imageType: AccountProfileImageType.file);

                        Get.back();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.aR),
                        color:
                            ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                      ),
                      width: double.infinity,
                      height: 51.aR,
                      alignment: Alignment.center,
                      child: Text(
                        "Choose from library",
                        style: labelMedium.copyWith(fontSize: 12.aR),
                      ),
                    ),
                  ),
                  // const Divider(
                  //   color: Color(0xff4a454e),
                  //   height: 1,
                  //   thickness: 1,
                  // ),
                  0.01.vspace,
                  GestureDetector(
                    onTap: () async {
                      Get.bottomSheet(
                        avatarPicker(),
                        isScrollControlled: true,
                        enterBottomSheetDuration:
                            const Duration(milliseconds: 180),
                        exitBottomSheetDuration:
                            const Duration(milliseconds: 150),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.aR),
                        color:
                            ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                      ),
                      width: double.infinity,
                      height: 51.aR,
                      alignment: Alignment.center,
                      child: Text(
                        "Pick an avatar",
                        style: labelMedium.copyWith(fontSize: 12.aR),
                      ),
                    ),
                  ),
                  // const Divider(
                  //   color: Color(0xff4a454e),
                  //   height: 1,
                  //   thickness: 1,
                  // ),
                  _controller.homePageController
                              .userAccounts[widget.accountIndex].imageType! ==
                          AccountProfileImageType.file
                      ? GestureDetector(
                          onTap: () {
                            _controller.editUserProfilePhoto(
                                imageType: AccountProfileImageType.assets,
                                imagePath:
                                    ServiceConfig.allAssetsProfileImages[0],
                                accountIndex: widget.accountIndex);

                            Get.back();
                          },
                          child: Container(
                            width: double.infinity,
                            height: 51.aR,
                            alignment: Alignment.center,
                            child: Text(
                              "Remove photo",
                              style: labelMedium.copyWith(
                                  color: ColorConst.Error.shade60,
                                  fontSize: 12.aR),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            0.016.vspace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.arP),
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  height: 51.aR,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.aR),
                    color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                  ),
                  child: Text(
                    "Cancel",
                    style: labelMedium.copyWith(
                        color: Colors.white, fontSize: 12.aR),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget avatarPicker() {
    return PickAvatar(
        controller: _controller,
        accountIndex: widget.accountIndex,
        accountController: _accountController);
  }
}

class PickAvatar extends StatefulWidget {
  const PickAvatar({
    Key? key,
    required SettingsPageController controller,
    required this.accountIndex,
    required AccountSummaryController accountController,
  })  : _controller = controller,
        _accountController = accountController,
        super(key: key);

  final SettingsPageController _controller;
  final int accountIndex;

  final AccountSummaryController _accountController;

  @override
  State<PickAvatar> createState() => _PickAvatarState();
}

class _PickAvatarState extends State<PickAvatar> {
  late String selectedAvatar;
  late AccountProfileImageType imageType;
  @override
  void initState() {
    selectedAvatar = Get.find<HomePageController>()
            .userAccounts[widget.accountIndex]
            .profileImage ??
        "";
    imageType = Get.find<HomePageController>()
            .userAccounts[widget.accountIndex]
            .imageType ??
        AccountProfileImageType.assets;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      width: 1.width,
      padding: EdgeInsets.symmetric(horizontal: 0.05.width),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            0.04.vspace,
            Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: Get.back,
                  child: SvgPicture.asset(
                    "${PathConst.SVG}arrow_back.svg",
                    fit: BoxFit.scaleDown,
                  ),
                )),
            0.05.vspace,
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Pick an Avatar", style: titleLarge),
            ),
            0.05.vspace,
            Container(
              height: 0.3.width,
              width: 0.3.width,
              alignment: Alignment.bottomRight,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: imageType == AccountProfileImageType.assets
                      ? AssetImage(selectedAvatar)
                      : FileImage(
                          File(selectedAvatar),
                        ) as ImageProvider,
                ),
              ),
            ),
            0.05.vspace,
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
                      // widget._controller.editUserProfilePhoto(
                      //     imageType: AccountProfileImageType.assets,
                      //     imagePath: ServiceConfig.allAssetsProfileImages[index],
                      //     accountIndex: widget.accountIndex);
                      // widget._accountController.selectedAccount.update((val) {
                      imageType = AccountProfileImageType.assets;
                      selectedAvatar =
                          ServiceConfig.allAssetsProfileImages[index];
                      setState(() {});
                      // });
                    },
                    child: CircleAvatar(
                      radius: 70.arP,
                      child: Image.asset(
                        ServiceConfig.allAssetsProfileImages[index],
                        fit: BoxFit.cover,
                        height: 72.arP,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            0.01.vspace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.arP),
              child: SolidButton(
                height: 40.arP,
                onPressed: () {
                  widget._controller.editUserProfilePhoto(
                      imageType: AccountProfileImageType.assets,
                      imagePath: selectedAvatar,
                      accountIndex: widget.accountIndex);
                  widget._accountController.selectedAccount.update((val) {
                    val?.imageType = AccountProfileImageType.assets;
                    val?.profileImage = selectedAvatar;
                  });
                  Get.back();
                  Get.back();
                },
                title: "Confirm",
                // child: Text(
                //   "Confirm",
                //   style: titleSmall.apply(color: ColorConst.Primary.shade95),
                // ),
              ),
            ),
            0.05.vspace
          ],
        ),
      ),
    );
  }
}
