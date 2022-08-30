import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/send_page/views/pages/contact_page_view.dart';
import 'package:naan_wallet/app/modules/send_page/views/pages/token_collection_page_view.dart';
import 'package:naan_wallet/utils/colors/colors.dart';

import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../controllers/send_page_controller.dart';
import 'pages/send_review_page.dart';
import 'widgets/add_button.dart';
import 'widgets/paste_button.dart';

class SendPage extends GetView<SendPageController> {
  const SendPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SendPageController());
    return WillPopScope(
      onWillPop: () async {
        if (controller.selectedPageIndex.value != 0) {
          controller.selectedPageIndex.value.toInt() - 1;
        }
        return controller.selectedPageIndex.value == 0.0 ? true : false;
      },
      child: Container(
        height: 0.95.height,
        width: 1.width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          gradient: GradConst.GradientBackground,
        ),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              searchBar(),
              Obx(() => IndexedStack(
                    index: controller.selectedPageIndex.value,
                    sizing: StackFit.loose,
                    children: [
                      const ContactsListView(),
                      const TokenAndNftPageView(),
                      SendReviewPage(
                        controller: controller,
                        totalTez: 3.23,
                        showNFTPage: controller.isNFTPage.value,
                        nftImageUrl: 'assets/temp/nft_thumbnail.png',
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget searchBar() => Column(
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
                Obx(() => Flexible(
                      child: TextField(
                        controller: controller.searchTextController.value,
                        onChanged: (value) =>
                            controller.searchText.value = value,
                        focusNode: controller.searchBarFocusNode,
                        cursorColor: ColorConst.Primary,
                        style: bodyMedium.apply(color: ColorConst.Primary),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Tez domain or address',
                            hintStyle: bodyMedium.apply(
                                color: ColorConst.NeutralVariant.shade40)),
                      ),
                    )),
                0.02.hspace,
                Obx(() => controller.searchText.isEmpty
                    ? PasteButton(
                        onTap: controller.paste,
                      )
                    : AddContactButton(
                        contactName: controller.searchTextController.value.text,
                      ))
              ],
            ),
          ),
        ],
      );
}
