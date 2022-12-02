import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/contact_model.dart';
import 'package:naan_wallet/app/data/services/tezos_domain_service/tezos_domain_service.dart';
import 'package:naan_wallet/app/modules/send_page/views/pages/contact_page_view.dart';
import 'package:naan_wallet/app/modules/send_page/views/pages/token_collection_page_view.dart';
import 'package:naan_wallet/utils/colors/colors.dart';

import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../controllers/send_page_controller.dart';
import 'pages/send_review_page.dart';
import 'widgets/add_button.dart';
import 'widgets/paste_button.dart';
import 'package:naan_wallet/utils/utils.dart';

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
        height: double.infinity,
        width: 1.width,
        margin: EdgeInsets.only(top: 27.arP),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            color: Colors.black),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                        autofocus: true,
                        controller: controller.searchTextController.value,
                        onChanged: (value) {
                          if (controller.searchDebounceTimer != null) {
                            controller.searchDebounceTimer!.cancel();
                          }
                          controller.searchDebounceTimer =
                              Timer(const Duration(milliseconds: 300), () {
                            TezosDomainService()
                                .searchUsingText(value)
                                .then((data) {
                              /// add if not exits
                              data = data
                                  .map<ContactModel>((e) => controller.contacts
                                          .contains(e)
                                      ? controller.contacts[
                                          controller.contacts.indexOf(e)]
                                      : controller.suggestedContacts.contains(e)
                                          ? controller.suggestedContacts[
                                              controller.suggestedContacts
                                                  .indexOf(e)]
                                          : e)
                                  .toList();
                              if (value.isValidWalletAddress && data.isEmpty) {
                                data.add(ContactModel(
                                    name: "Account",
                                    address: value,
                                    imagePath:
                                        ServiceConfig.allAssetsProfileImages[
                                            Random().nextInt(
                                      ServiceConfig
                                              .allAssetsProfileImages.length -
                                          1,
                                    )]));
                              }
                              controller.suggestedContacts.value = data;
                            });
                          });
                          controller.searchText.value = value;
                        },
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
                Obx(
                  () => controller.selectedPageIndex.value == 0
                      ? (controller.suggestedContacts.isEmpty
                          ? PasteButton(
                              onTap: controller.paste,
                            )
                          : controller.contacts
                                  .where((p0) =>
                                      p0.address ==
                                          controller.searchTextController.value
                                              .text ||
                                      (controller.suggestedContacts.isNotEmpty
                                          ? controller.suggestedContacts[0]
                                                  .address ==
                                              p0.address
                                          : false))
                                  .isEmpty
                              ? AddContactButton(
                                  contactModel:
                                      controller.suggestedContacts.first,
                                )
                              : const SizedBox())
                      : const SizedBox(),
                )
              ],
            ),
          ),
        ],
      );
}
