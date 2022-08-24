import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/naan_textfield.dart';
import 'package:naan_wallet/app/modules/contact_page/models/contact_model.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../../../../utils/constants/path_const.dart';
import '../controllers/contact_page_controller.dart';

class ContactPageView extends GetView<ContactPageController> {
  const ContactPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: GradConst.GradientBackground),
        padding: EdgeInsets.symmetric(horizontal: 0.035.width),
        child: Column(
          children: [
            AppBar(
              title: Text(
                'Send',
                style: titleMedium,
              ),
              backgroundColor: Colors.transparent,
              centerTitle: true,
              toolbarHeight: 60,
              automaticallyImplyLeading: false,
            ),
            Row(
              children: [
                Text(
                  'To',
                  style: bodyMedium.apply(
                    color: ColorConst.NeutralVariant.shade60,
                  ),
                ),
                0.02.hspace,
                Flexible(
                  child: TextField(
                    controller: controller.searchTextController.value,
                    onChanged: (value) => controller.searchText.value = value,
                    cursorColor: ColorConst.Primary,
                    style: bodyMedium.apply(color: ColorConst.Primary),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Tez domain or address',
                        hintStyle: bodyMedium.apply(
                            color: ColorConst.NeutralVariant.shade40)),
                  ),
                ),
                0.02.hspace,
                Obx(() => controller.searchText.isEmpty
                    ? pasteButton()
                    : addContactButton())
              ],
            ),
            Obx(
              () => Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  children: controller.searchText.isEmpty
                      ? (<Widget>[
                            Text(
                              'Recents',
                              style: labelSmall.apply(
                                  color: ColorConst.NeutralVariant.shade60),
                            ),
                            0.008.vspace
                          ] +
                          controller.recentsContacts
                              .map((element) => contact(element))
                              .toList() +
                          <Widget>[
                            0.033.vspace,
                            Text(
                              'Contacts',
                              style: labelSmall.apply(
                                  color: ColorConst.NeutralVariant.shade60),
                            ),
                            0.008.vspace
                          ] +
                          controller.contacts
                              .map((element) =>
                                  contact(element, isContact: true))
                              .toList())
                      : <Widget>[
                            Text(
                              'Suggestions',
                              style: labelSmall.apply(
                                  color: ColorConst.NeutralVariant.shade60),
                            ),
                            0.008.vspace
                          ] +
                          controller.suggestedContacts
                              .map((element) => contact(element))
                              .toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget contact(ContactModel contact, {bool isContact = false}) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.TOKEN_AND_COLLECTION_PAGE);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: SizedBox(
          height: 46,
          child: Row(
            children: [
              CircleAvatar(
                radius: 23,
                backgroundColor:
                    ColorConst.NeutralVariant.shade60.withOpacity(0.2),
              ),
              0.04.hspace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    contact.name,
                    style: bodySmall,
                  ),
                  Text(
                    contact.address,
                    style: labelSmall.apply(
                        color: ColorConst.NeutralVariant.shade60),
                  ),
                ],
              ),
              const Spacer(),
              if (isContact)
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_horiz,
                    color: Colors.white,
                  ),
                  iconSize: 16,
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget pasteButton() {
    return GestureDetector(
      onTap: controller.paste,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "${PathConst.SVG}paste.svg",
            fit: BoxFit.scaleDown,
            color: ColorConst.Primary,
            height: 16,
          ),
          0.02.hspace,
          Text(
            "Paste",
            style: labelMedium.apply(color: ColorConst.Primary),
          )
        ],
      ),
    );
  }

  Widget addContactButton() {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          addContactBottomSheet(),
          isScrollControlled: true,
          barrierColor: Colors.black.withOpacity(0.2),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            PathConst.CONTACTS_PAGE + "add_contact.svg",
            fit: BoxFit.scaleDown,
            color: ColorConst.Primary,
            height: 16,
          ),
          0.02.hspace,
          Text(
            "Save",
            style: labelMedium.apply(color: ColorConst.Primary),
          )
        ],
      ),
    );
  }

  Widget addContactBottomSheet() {
    return Wrap(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                gradient: GradConst.GradientBackground),
            width: 1.width,
            padding: EdgeInsets.symmetric(horizontal: 0.077.width),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                0.005.vspace,
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
                0.025.vspace,
                Text(
                  'Add Contact',
                  style: titleLarge,
                ),
                0.03.vspace,
                NaanTextfield(hint: 'Enter Name'),
                0.025.vspace,
                Text(
                  controller.searchTextController.value.text,
                  style: labelSmall.apply(
                      color: ColorConst.NeutralVariant.shade60),
                ),
                0.025.vspace,
                MaterialButton(
                  color: ColorConst.Primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  onPressed: () {},
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: Center(
                        child: Text(
                      'Add contact',
                      style: titleSmall,
                    )),
                  ),
                ),
                0.05.vspace,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
