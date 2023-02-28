import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naan_wallet/app/data/services/create_profile_service/create_profile_service.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_gallery_model.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/app/modules/account_summary/views/bottomsheets/account_selector.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/common_widgets/image_picker.dart';
import 'package:naan_wallet/app/modules/common_widgets/naan_listview.dart';
import 'package:naan_wallet/app/modules/common_widgets/naan_textfield.dart';
import 'package:naan_wallet/app/modules/common_widgets/no_accounts_founds_bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/pick_an_avatar.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/custom_packages/custom_checkbox.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/nft_gallery_widget/controller/nft_gallery_widget_controller.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:naan_wallet/app/modules/import_wallet_page/views/import_wallet_page_view.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';
import 'package:get/get.dart';

class CreateNewNftGalleryBottomSheet
    extends GetView<NftGalleryWidgetController> {
  final NftGalleryModel? nftGalleryModel;
  final int? galleryIndex;
  const CreateNewNftGalleryBottomSheet(
      {super.key, this.nftGalleryModel, this.galleryIndex});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.formIndex.value == 0
          ? selectAccountWidget()
          : createGalleryProfileWidget(context),
    );
    // return BackdropFilter(
    //   filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
    //   child: Container(
    //     height: 0.95.height - MediaQuery.of(context).viewInsets.bottom,
    //     decoration: BoxDecoration(
    //       color: Colors.black,
    //       borderRadius: BorderRadius.only(
    //         topLeft: Radius.circular(
    //           10.arP,
    //         ),
    //         topRight: Radius.circular(
    //           10.arP,
    //         ),
    //       ),
    //     ),
    //     child: Obx(
    //       () => controller.formIndex.value == 0
    //           ? selectAccountWidget()
    //           : createGalleryProfileWidget(context),
    //     ),
    //   ),
    // );
  }
  // No Accounts

  // Widget noAccountWidget() => SizedBox(
  //       height: 0.87.height,
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           backButton(),
  //           Expanded(
  //             child: Center(
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 // mainAxisSize: MainAxisSize.min,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   SvgPicture.asset(
  //                     "${PathConst.EMPTY_STATES}no_accounts.svg",
  //                     height: 175.arP,
  //                     width: 175.arP,
  //                   ),
  //                   0.05.vspace,
  //                   Text(
  //                     "No accounts found",
  //                     textAlign: TextAlign.center,
  //                     style: titleLarge,
  //                   ),
  //                   SizedBox(
  //                     height: 12.arP,
  //                   ),
  //                   Text(
  //                     "Create or import new account to create\nnew gallery",
  //                     textAlign: TextAlign.center,
  //                     style: bodySmall.copyWith(color: ColorConst.textGrey1),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     );

  /// Select account widget for creating new gallery
  Widget selectAccountWidget() {
    // if (controller.accounts.isEmpty) {
    //   return noAccountsWidget();
    // }
    return NaanBottomSheet(
      title: controller.accounts.isEmpty ? "" : "Select accounts",
      // bottomSheetHorizontalPadding: 0,
      // isScrollControlled: true,
      height: AppConstant.naanBottomSheetHeight,
      bottomSheetWidgets: [
        Obx(() {
          return SizedBox(
            height: AppConstant.naanBottomSheetChildHeight,
            child: controller.accounts.isEmpty
                ? noAccountsWidget()
                : _accountSelectorList(),
          );
        }),
      ],
    );
  }

  Column _accountSelectorList() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      // mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 12.arP,
        ),
        Text(
          "Choose accounts to add to your gallery.\nYou can always edit these later",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF958E99),
            fontSize: 12.arP,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.4.arP,
          ),
        ),
        SizedBox(
          height: 12.arP,
        ),
        controller.accounts.isNotEmpty
            ? Obx(
                () => Expanded(
                  flex: 1,
                  child: NaanListView(
                    listViewEdgeInsets: EdgeInsets.zero,
                    itemBuilder: (context, index) =>
                        accountItemWidget(index, controller.accounts[index]),
                    itemCount: controller.accounts.length,
                    topSpacing: 18.arP,
                    bottomSpacing: 18.arP,
                  ),
                ),
              )
            : Container(),
        controller.selectedAccountIndex.values
                .where((element) => element == true)
                .toList()
                .isEmpty
            ? _importWatchAddressButton()
            : Container(),
        Container(
          margin: EdgeInsets.only(
            left: 16.arP + 16.arP,
            right: 16.arP + 16.arP,
            bottom: 40.arP,
            top: 30.arP,
          ),
          child: Obx(
            () => SolidButton(
              title:
                  "Next (${controller.selectedAccountIndex.values.where((element) => element == true).toList().length}/5)",
              height: 50.arP,
              active: controller.selectedAccountIndex.isNotEmpty &&
                      controller.selectedAccountIndex.values.contains(true)
                  ? true
                  : false,
              borderRadius: 8.arP,
              titleStyle: TextStyle(
                color: controller.selectedAccountIndex.isNotEmpty &&
                        controller.selectedAccountIndex.values.contains(true)
                    ? Colors.white
                    : const Color(0xff958E99),
                fontSize: 14.arP,
                fontWeight: FontWeight.w600,
              ),
              onPressed: () {
                controller.accountNameFocus.requestFocus();
                controller.formIndex.value = 1;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget noAccountsWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          SvgPicture.asset(
            "${PathConst.EMPTY_STATES}no_accounts.svg",
            height: 175.arP,
            width: 175.arP,
          ),
          0.05.vspace,
          Text(
            "No accounts found",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
              fontSize: 22.arP,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 12.arP,
          ),
          Text(
            "Create or import new account to proceed",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF958E99),
              decoration: TextDecoration.none,
              fontSize: 12.arP,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.4.arP,
            ),
          ),
          const Spacer(),
          _importWatchAddressButton(),
          const BottomButtonPadding()
        ],
      ),
    );
  }

  BouncingWidget _importWatchAddressButton() {
    return BouncingWidget(
      onPressed: _onImportAccount,
      child: Padding(
        padding: EdgeInsets.only(
          top: 16.arP,
          left: 16.arP,
          right: 16.arP,
        ),
        child: Row(
          children: [
            Image.asset(
              "${PathConst.EMPTY_STATES}plus.png",
              height: 16.aR,
              fit: BoxFit.contain,
              scale: 1,
            ),
            0.02.hspace,
            Text(
              "Add a watch address",
              style: labelLarge.copyWith(
                  fontSize: 14.aR,
                  color: ColorConst.Primary,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }

  _onImportAccount() async {
    String pkh = await CommonFunctions.bottomSheet(
      ImportWalletPageView(
        isBottomSheet: true,
        isWatchAddress: true,
      ),
    );
    controller.accounts.value = await UserStorageService().getAllAccount() +
        (await UserStorageService().getAllAccount(watchAccountsList: true));

    controller.selectedAccountIndex[pkh] = controller
                .selectedAccountIndex.values
                .where((element) => element == true)
                .toList()
                .length !=
            5
        ? true
        : false;
  }

  Widget accountItemWidget(int index, AccountModel accountModel) =>
      BouncingWidget(
        onPressed: () {
          if (controller.selectedAccountIndex.values
                      .where((element) => element == true)
                      .toList()
                      .length ==
                  5 &&
              (!controller.selectedAccountIndex
                  .containsKey(accountModel.publicKeyHash!))) {
            HapticFeedback.mediumImpact();
            return;
          }
          if (controller.selectedAccountIndex.values
                      .where((element) => element == true)
                      .toList()
                      .length ==
                  5 &&
              !controller.selectedAccountIndex[accountModel.publicKeyHash!]!) {
            HapticFeedback.mediumImpact();
            return;
          }
          controller.selectedAccountIndex[accountModel.publicKeyHash!] =
              controller.selectedAccountIndex
                      .containsKey(accountModel.publicKeyHash!)
                  ? !controller
                      .selectedAccountIndex[accountModel.publicKeyHash!]!
                  : true;
        },
        child: Container(
          margin: EdgeInsets.only(
            bottom: 8.arP,
          ),
          padding: EdgeInsets.only(
            top: 4.arP,
            bottom: 4.arP,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 20.arP,
                child: accountModel.imageType == AccountProfileImageType.assets
                    ? Image.asset(accountModel.profileImage!)
                    : Image.file(File(accountModel.profileImage!)),
              ),
              SizedBox(
                width: 20.arP,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      accountModel.name!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.arP,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.4.arP,
                      ),
                    ),
                    SizedBox(height: 2.arP),
                    Text(
                      accountModel.publicKeyHash!.tz1Short(),
                      style: TextStyle(
                        color: const Color(0xFF958E99),
                        fontSize: 12.arP,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5.arP,
                      ),
                    ),
                  ],
                ),
              ),
              accountModel.isWatchOnly
                  ? Container(
                      margin: EdgeInsets.only(
                        right: 14.arP,
                      ),
                      child: Text(
                        "Watching",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.arP,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5.arP,
                        ),
                      ),
                    )
                  : Container(),
              Obx(() => CustomCheckBox(
                    borderRadius: 12.aR,
                    checkedIcon: Icons.done,
                    borderWidth: 2,
                    checkBoxIconSize: 12.aR,
                    checkBoxSize: 20.aR,
                    borderColor: const Color(0xff1E1C1F),
                    checkedIconColor: Colors.white,
                    uncheckedFillColor: Colors.transparent,
                    uncheckedIconColor: Colors.transparent,
                    checkedFillColor: ColorConst.Primary,
                    value: controller.selectedAccountIndex
                            .containsKey(accountModel.publicKeyHash!)
                        ? controller
                            .selectedAccountIndex[accountModel.publicKeyHash!]!
                        : false,
                    onChanged: (val) {
                      if (controller.selectedAccountIndex.values
                                  .where((element) => element == true)
                                  .toList()
                                  .length ==
                              5 &&
                          val) {
                        HapticFeedback.mediumImpact();
                        return;
                      }
                      controller.selectedAccountIndex[accountModel
                          .publicKeyHash!] = controller.selectedAccountIndex
                              .containsKey(accountModel.publicKeyHash!)
                          ? !controller.selectedAccountIndex[
                              accountModel.publicKeyHash!]!
                          : true;
                    },
                  )),
            ],
          ),
        ),
      );

  /// Create gallery profile widget

  Widget createGalleryProfileWidget(BuildContext context) => NaanBottomSheet(
        // bottomSheetHorizontalPadding: 0,
        title:
            nftGalleryModel != null ? "Edit your gallery" : "Name your gallery",

        height: AppConstant.naanBottomSheetHeight,
        // isScrollControlled: true,
        bottomSheetWidgets: [
          SizedBox(
            height: AppConstant.naanBottomSheetChildHeight -
                MediaQuery.of(context).viewInsets.bottom,
            child: Column(
              children: [
                Obx(
                  () => Container(
                    height: 104.arP,
                    width: 104.arP,
                    margin: EdgeInsets.only(
                      top: 34.2.arP,
                    ),
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
                    child: BouncingWidget(
                      onPressed: () {
                        CommonFunctions.bottomSheet(
                          changePhotoBottomSheet(),
                        );
                      },
                      child: CircleAvatar(
                        radius: 15.6.arP,
                        backgroundColor: Colors.white,
                        child: SvgPicture.asset(
                          "${PathConst.SVG}add_photo.svg",
                          fit: BoxFit.scaleDown,
                          color: const Color(0xFFFF006E),
                          width: 15.6.arP,
                          height: 15.6.arP,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.arP,
                ),
                NaanTextfield(
                  // height: 52,
                  maxLen: 15,
                  hint: "Account Name",
                  focusNode: controller.accountNameFocus,
                  controller: controller.accountNameController,
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 14.arP,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.25.arP,
                  ),
                  onTextChange: (String value) =>
                      controller.accountName.value = value,
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 16.arP,
                      right: 16.arP,
                      // bottom: 35.arP,
                      // top: 30.arP,
                    ),
                    child: Obx(() {
                      return SolidButton(
                        isLoading: controller.isCreating,
                        title: "Done",
                        // height: 50.arP,
                        active: controller.accountName.isNotEmpty &&
                            controller.accountName.value.length > 2,

                        onPressed: () async {
                          if (nftGalleryModel == null) {
                            await controller.addNewNftGallery();
                          } else {
                            await controller.editNftGallery(galleryIndex!);
                          }
                        },
                      );
                    }),
                  ),
                ),
                const BottomButtonPadding()
              ],
            ),
          ),
        ],
      );

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
    // return NaanBottomSheet(
    //   height: 275.arP,
    //   bottomSheetWidgets: [
    //     SizedBox(
    //       height: 250.arP,
    //       child: SingleChildScrollView(
    //         child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             0.02.vspace,
    //             Container(
    //               width: double.infinity,
    //               padding: const EdgeInsets.symmetric(
    //                 horizontal: 12,
    //               ),
    //               decoration: BoxDecoration(
    //                 borderRadius: BorderRadius.circular(8),
    //                 color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
    //               ),
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: [
    //                   GestureDetector(
    //                     onTap: () async {
    //                       var imagePath = await CreateProfileService()
    //                           .pickANewImageFromGallery();
    //                       if (imagePath.isNotEmpty) {
    //                         controller.currentSelectedType =
    //                             AccountProfileImageType.file;
    //                         controller.selectedImagePath.value = imagePath;
    //                         Get.back();
    //                       }
    //                     },
    //                     child: Container(
    //                       width: double.infinity,
    //                       height: 51,
    //                       alignment: Alignment.center,
    //                       child: Text(
    //                         "Choose from library",
    //                         style: labelMedium,
    //                       ),
    //                     ),
    //                   ),
    //                   const Divider(
    //                     color: Color(0xff4a454e),
    //                     height: 1,
    //                     thickness: 1,
    //                   ),
    //                   GestureDetector(
    //                     onTap: () async {
    //                       Get.bottomSheet(
    //                         avatarPicker(),
    //                         isScrollControlled: true,
    //                         enterBottomSheetDuration:
    //                             const Duration(milliseconds: 180),
    //                         exitBottomSheetDuration:
    //                             const Duration(milliseconds: 150),
    //                       );
    //                     },
    //                     child: Container(
    //                       width: double.infinity,
    //                       height: 51,
    //                       alignment: Alignment.center,
    //                       child: Text(
    //                         "Pick an avatar",
    //                         style: labelMedium,
    //                       ),
    //                     ),
    //                   ),
    //                   if (controller.currentSelectedType ==
    //                       AccountProfileImageType.file)
    //                     Column(
    //                       children: [
    //                         const Divider(
    //                           color: Color(0xff4a454e),
    //                           height: 1,
    //                           thickness: 1,
    //                         ),
    //                         GestureDetector(
    //                           onTap: () {
    //                             controller.currentSelectedType =
    //                                 AccountProfileImageType.assets;
    //                             controller.selectedImagePath.value =
    //                                 ServiceConfig.allAssetsProfileImages[0];
    //                             Get.back();
    //                           },
    //                           child: Container(
    //                             width: double.infinity,
    //                             height: 51,
    //                             alignment: Alignment.center,
    //                             child: Text(
    //                               "Remove photo",
    //                               style: labelMedium.apply(
    //                                   color: ColorConst.Error.shade60),
    //                             ),
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                 ],
    //               ),
    //             ),
    //             0.016.vspace,
    //             Padding(
    //               padding: const EdgeInsets.symmetric(horizontal: 16),
    //               child: GestureDetector(
    //                 onTap: () => Get.back(),
    //                 child: Container(
    //                   height: 51,
    //                   alignment: Alignment.center,
    //                   decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(8),
    //                     color:
    //                         ColorConst.NeutralVariant.shade60.withOpacity(0.2),
    //                   ),
    //                   child: Text(
    //                     "Cancel",
    //                     style: labelMedium.apply(color: Colors.white),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             BottomButtonPadding()
    //           ],
    //         ),
    //       ),
    //     )
    //   ],
    // );

    // return SizedBox(
    //   height: 250.arP,
    //   child: Scaffold(
    //     body: BackdropFilter(
    //       filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
    //       child: Container(
    //         decoration: const BoxDecoration(
    //             borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
    //             color: Colors.black),
    //         width: 1.width,
    //         padding: const EdgeInsets.symmetric(horizontal: 16),
    //         child: SingleChildScrollView(
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               0.005.vspace,
    //               Container(
    //                 height: 5,
    //                 width: 36,
    //                 decoration: BoxDecoration(
    //                   borderRadius: BorderRadius.circular(5),
    //                   color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
    //                 ),
    //               ),
    //               0.03.vspace,
    //               Container(
    //                 width: double.infinity,
    //                 padding: const EdgeInsets.symmetric(
    //                   horizontal: 12,
    //                 ),
    //                 decoration: BoxDecoration(
    //                   borderRadius: BorderRadius.circular(8),
    //                   color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
    //                 ),
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.center,
    //                   children: [
    //                     GestureDetector(
    //                       onTap: () async {
    //                         var imagePath = await CreateProfileService()
    //                             .pickANewImageFromGallery();
    //                         if (imagePath.isNotEmpty) {
    //                           controller.currentSelectedType =
    //                               AccountProfileImageType.file;
    //                           controller.selectedImagePath.value = imagePath;
    //                           Get.back();
    //                         }
    //                       },
    //                       child: Container(
    //                         width: double.infinity,
    //                         height: 51,
    //                         alignment: Alignment.center,
    //                         child: Text(
    //                           "Choose from library",
    //                           style: labelMedium,
    //                         ),
    //                       ),
    //                     ),
    //                     const Divider(
    //                       color: Color(0xff4a454e),
    //                       height: 1,
    //                       thickness: 1,
    //                     ),
    //                     GestureDetector(
    //                       onTap: () async {
    //                         final result =
    //                             await Get.to(const AvatarPickerView());

    //                         if (result != null) {
    //                           controller.currentSelectedType = result[1];
    //                           controller.selectedImagePath.value = result[0];
    //                         }
    //                       },
    //                       child: Container(
    //                         width: double.infinity,
    //                         height: 51,
    //                         alignment: Alignment.center,
    //                         child: Text(
    //                           "Pick an avatar",
    //                           style: labelMedium,
    //                         ),
    //                       ),
    //                     ),
    //                     if (controller.currentSelectedType ==
    //                         AccountProfileImageType.file)
    //                       Column(
    //                         children: [
    //                           const Divider(
    //                             color: Color(0xff4a454e),
    //                             height: 1,
    //                             thickness: 1,
    //                           ),
    //                           GestureDetector(
    //                             onTap: () {
    //                               controller.currentSelectedType =
    //                                   AccountProfileImageType.assets;
    //                               controller.selectedImagePath.value =
    //                                   ServiceConfig.allAssetsProfileImages[0];
    //                               Get.back();
    //                             },
    //                             child: Container(
    //                               width: double.infinity,
    //                               height: 51,
    //                               alignment: Alignment.center,
    //                               child: Text(
    //                                 "Remove photo",
    //                                 style: labelMedium.apply(
    //                                     color: ColorConst.Error.shade60),
    //                               ),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                   ],
    //                 ),
    //               ),
    //               0.016.vspace,
    //               Padding(
    //                 padding: const EdgeInsets.symmetric(horizontal: 16),
    //                 child: GestureDetector(
    //                   onTap: () => Get.back(),
    //                   child: Container(
    //                     height: 51,
    //                     alignment: Alignment.center,
    //                     decoration: BoxDecoration(
    //                       borderRadius: BorderRadius.circular(8),
    //                       color: ColorConst.NeutralVariant.shade60
    //                           .withOpacity(0.2),
    //                     ),
    //                     child: Text(
    //                       "Cancel",
    //                       style: labelMedium.apply(color: Colors.white),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               0.063.vspace,
    //             ],
    //           ),
    //         ),
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
