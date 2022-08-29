import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:naan_wallet/app/modules/contact_page/controllers/contact_page_controller.dart';
import 'package:naan_wallet/app/modules/contact_page/views/contact_page_view.dart';
import 'package:naan_wallet/app/modules/token_and_collection_page/views/token_and_collection_page_view.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../../common_widgets/naan_textfield.dart';
import '../controllers/send_token_page_controller.dart';
import 'pages/send_review_page.dart';

class SendPage extends GetView<SendPageController> {
  const SendPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SendPageController());
    return Container(
      height: 1.height,
      width: 1.width,
      decoration: const BoxDecoration(gradient: GradConst.GradientBackground),
      child: SafeArea(
        bottom: false,
        child: Obx(() => SendReviewPage(
              controller: controller,
              totalTez: '3.23',
              showNFTPage: controller.isNFTPage.value,
              receiverName: 'Bernd.tez',
              nftImageUrl: 'assets/temp/nft_thumbnail.png',
            )),
      ),
    );
  }
}

class ContactSelectionPage extends StatelessWidget {
  final contactPagecontroller =
      Get.put<ContactPageController>(ContactPageController());

  final PageController pageController = PageController();
  ContactSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (pageController.page != 0) {
          pageController.jumpToPage(pageController.page!.toInt() - 1);
        }
        return pageController.page == 0.0 ? true : false;
      },
      child: Container(
        height: 0.96.height,
        width: 1.width,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            gradient: GradConst.GradientBackground),
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.035.width),
              child: Row(
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
                      controller:
                          contactPagecontroller.searchTextController.value,
                      onChanged: (value) =>
                          contactPagecontroller.searchText.value = value,
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
                  Obx(() => contactPagecontroller.searchText.isEmpty
                      ? pasteButton()
                      : addContactButton())
                ],
              ),
            ),
            Expanded(
                child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: [
                ContactPageView(pageController: pageController),
                TokenAndCollectionPageView(pageController: pageController),
                const SendPage(),
              ],
            ))
          ],
        ),
      ),
    );
  }

  Widget pasteButton() {
    return GestureDetector(
      onTap: contactPagecontroller.paste,
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
          AddContactBottomSheet(
              contactName:
                  contactPagecontroller.searchTextController.value.text),
          isScrollControlled: true,
          barrierColor: Colors.black.withOpacity(0.2),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "${PathConst.CONTACTS_PAGE}svg/add_contact.svg",
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
}

class AddContactBottomSheet extends StatelessWidget {
  final String contactName;
  const AddContactBottomSheet({
    Key? key,
    required this.contactName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      bottomSheetWidgets: [
        Text(
          'Add Contact',
          style: titleLarge,
        ),
        0.03.vspace,
        NaanTextfield(hint: 'Enter Name'),
        0.025.vspace,
        Text(
          contactName,
          style: labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
        ),
        0.025.vspace,
        MaterialButton(
          color: ColorConst.Primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
    );
  }
}
