import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/data/services/service_models/contact_model.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/transaction_controller.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/naan_textfield.dart';
import 'package:naan_wallet/app/modules/create_profile_page/controllers/create_profile_page_controller.dart';
import 'package:naan_wallet/app/modules/send_page/controllers/send_page_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../../../../../utils/constants/path_const.dart';
import '../../../../data/services/create_profile_service/create_profile_service.dart';
import '../../../../data/services/service_config/service_config.dart';
import '../../../common_widgets/solid_button.dart';

// ignore: must_be_immutable
class AddContactBottomSheet extends StatefulWidget {
  final ContactModel contactModel;
  final bool isTransactionContact;
  final bool isEditContact;
  const AddContactBottomSheet(
      {Key? key,
      required this.contactModel,
      this.isTransactionContact = false,
      this.isEditContact = false})
      : super(key: key);

  @override
  State<AddContactBottomSheet> createState() => _AddContactBottomSheetState();
}

class _AddContactBottomSheetState extends State<AddContactBottomSheet> {
  TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    nameController.text = widget.contactModel.name;
    nameController.selection = TextSelection.fromPosition(
        TextPosition(offset: nameController.text.length));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(AccountSummaryController());
    Get.put(TransactionController());
    return NaanBottomSheet(
      title: widget.isEditContact ? "Edit Contact" : 'Add Contact',
      isScrollControlled: true,
      height: (widget.isTransactionContact
          ? 520.arP
          : (widget.isEditContact ? 0.48.height : 0.3.height)),
      bottomSheetHorizontalPadding: 32.aR,
      blurRadius: 5,
      bottomSheetWidgets: [
        if (widget.isTransactionContact || widget.isEditContact) ...[
          // 0.03.vspace,
          // Center(
          //   child: Text(
          //     widget.isEditContact ? "Edit Contact" : 'Add Contact',
          //     style: titleMedium.copyWith(fontSize: 16.aR),
          //   ),
          // ),
          // 0.03.vspace,
          Center(
            child: Container(
              height: 0.3.width,
              width: 0.3.width,
              alignment: Alignment.bottomRight,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(widget.contactModel.imagePath),
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  Get.bottomSheet(changePhotoBottomSheet(),
                      enterBottomSheetDuration:
                          const Duration(milliseconds: 180),
                      exitBottomSheetDuration:
                          const Duration(milliseconds: 150),
                      barrierColor: Colors.transparent);
                },
                child: CircleAvatar(
                  radius: 20.aR,
                  backgroundColor: Colors.white,
                  child: SvgPicture.asset(
                    "${PathConst.SVG}add_photo.svg",
                    fit: BoxFit.contain,
                    height: 16.aR,
                  ),
                ),
              ),
            ),
          ),
          0.02.vspace,
          Center(
            child: Text(
              widget.contactModel.address,
              style: labelMedium.copyWith(fontSize: 12.aR),
            ),
          ),
        ],
        //   Text(
        //     'Add Contact',
        //     style: titleMedium,
        //   ),
        0.02.vspace,
        NaanTextfield(
          height: 52.aR,
          hint: 'Enter contact name',
          hintTextSyle:
              bodyMedium.copyWith(color: ColorConst.NeutralVariant.shade60),
          onTextChange: (val) {
            setState(() {});
          },
          controller: nameController,
        ),
        0.02.vspace,
        widget.isTransactionContact
            ? const SizedBox()
            : Text(
                widget.contactModel.address,
                style: labelSmall.copyWith(
                    color: ColorConst.NeutralVariant.shade60),
              ),
        0.03.vspace,
        MaterialButton(
          color: nameController.text.isEmpty
              ? const Color(0xff1E1C1F)
              : ColorConst.Primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onPressed: () async {
            if (widget.isTransactionContact && !widget.isEditContact) {
              if (nameController.text.isEmpty) return;
              await UserStorageService().writeNewContact(widget.contactModel
                  .copyWith(name: nameController.text.trim()));
              var accountController = Get.find<TransactionController>();
              accountController.onAddContact(
                  widget.contactModel.address, nameController.text);
              await accountController.updateSavedContacts();
              // await Get.find<SendPageController>().updateSavedContacts();
              Get
                ..back()
                ..back();
            } else if (widget.isEditContact) {
              var accountController = Get.find<TransactionController>();
              accountController.contacts.value = accountController.contacts
                  .map((item) =>
                      item.address.contains(widget.contactModel.address)
                          ? item.copyWith(name: nameController.text.trim())
                          : item)
                  .toList();
              accountController.contacts.refresh();
              await UserStorageService()
                  .updateContactList(accountController.contacts);
              accountController.updateSavedContacts();
              Get
                ..back()
                ..back();
            } else {
              await UserStorageService().writeNewContact(widget.contactModel
                  .copyWith(name: nameController.text.trim()));
              await Get.find<SendPageController>().updateSavedContacts();
              Get.back();
            }
          },
          child: SizedBox(
            width: double.infinity,
            height: 50.aR,
            child: Center(
                child: Text(
              widget.isTransactionContact
                  ? "Add to contacts"
                  : (widget.isEditContact ? "Save Changes" : 'Add contact'),
              style: titleSmall.copyWith(
                  fontSize: 14.aR,
                  fontWeight: FontWeight.w600,
                  color: nameController.text.isEmpty
                      ? ColorConst.NeutralVariant.shade60
                      : Colors.white),
            )),
          ),
        ),
        0.04.vspace,
      ],
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
        height: 250.aR,
        padding: EdgeInsets.symmetric(horizontal: 16.aR),
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
                      // if (imagePath.isNotEmpty) {
                      //   _controller.editUserProfilePhoto(
                      //       accountIndex: widget.accountIndex,
                      //       imagePath: imagePath,
                      //       imageType: AccountProfileImageType.file);

                      //   Get.back();
                      // }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 40.aR,
                      alignment: Alignment.center,
                      child: Text(
                        "Choose from library",
                        style: labelMedium.copyWith(fontSize: 12.aR),
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
                      Get.bottomSheet(avatarPicker(),
                          enterBottomSheetDuration:
                              const Duration(milliseconds: 180),
                          exitBottomSheetDuration:
                              const Duration(milliseconds: 150),
                          isScrollControlled: true);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 40.aR,
                      alignment: Alignment.center,
                      child: Text(
                        "Pick an avatar",
                        style: labelMedium.copyWith(fontSize: 12.aR),
                      ),
                    ),
                  ),
                  const Divider(
                    color: Color(0xff4a454e),
                    height: 1,
                    thickness: 1,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      height: 40.aR,
                      alignment: Alignment.center,
                      child: Text(
                        "Remove photo",
                        style: labelMedium.copyWith(
                            color: ColorConst.Error.shade60, fontSize: 12.aR),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            0.016.vspace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.aR),
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  height: 40.aR,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.aR),
                    color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                  ),
                  child: Text(
                    "Cancel",
                    style: labelMedium.copyWith(
                        fontSize: 12.aR, color: Colors.white),
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
    var create_profile_page_controller = Get.put(CreateProfilePageController());
    create_profile_page_controller.currentSelectedType =
        AccountProfileImageType.assets;
    create_profile_page_controller.selectedImagePath.value =
        widget.contactModel.imagePath;
    return Container(
      color: Colors.black,
      width: 1.width,
      padding: EdgeInsets.symmetric(horizontal: 0.05.width),
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
          Obx(
            () => Container(
              height: 0.3.width,
              width: 0.3.width,
              alignment: Alignment.bottomRight,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                      create_profile_page_controller.selectedImagePath.value),
                ),
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
                    // _controller.editUserProfilePhoto(
                    //     imageType: AccountProfileImageType.assets,
                    //     imagePath: ServiceConfig.allAssetsProfileImages[index],
                    //     accountIndex: widget.accountIndex);
                    // _accountController.userAccount.update((val) {
                    //   val?.imageType = AccountProfileImageType.assets;
                    //   val?.profileImage =
                    //       ServiceConfig.allAssetsProfileImages[index];
                    // });
                  },
                  child: CircleAvatar(
                    radius: 70.sp,
                    child: Image.asset(
                      ServiceConfig.allAssetsProfileImages[index],
                      fit: BoxFit.cover,
                      height: 72.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
          0.01.vspace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.sp),
            child: SolidButton(
              height: 40.sp,
              onPressed: () {
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
    );
  }
}
