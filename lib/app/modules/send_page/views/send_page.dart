import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/contact_model.dart';
import 'package:naan_wallet/app/data/services/tezos_domain_service/tezos_domain_service.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
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
        if (controller.selectedPageIndex.value == 0) {
          return Future.value(true);
        }
        controller.selectedPageIndex.value -= 1;
        return Future.value(false);
      },
      child: NaanBottomSheet(
        title: 'Send',
        // isScrollControlled: true,
        height: 0.9.height - MediaQuery.of(context).viewInsets.bottom.arP,
        bottomSheetHorizontalPadding: 16.arP,
        // margin: EdgeInsets.only(top: 27.arP),
        // decoration: const BoxDecoration(
        //     borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        //     color: Colors.black),
        bottomSheetWidgets: [
          searchBar(),
          SizedBox(
            height:
                (0.755.height - MediaQuery.of(context).viewInsets.bottom).arP,
            child: Obx(() => IndexedStack(
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
          ),
        ],
      ),
    );
  }

  Widget searchBar() => Column(
        children: [
          Row(
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
                                  imagePath: ServiceConfig
                                      .allAssetsProfileImages[Random().nextInt(
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
                      style: TextStyle(
                        color: controller.selectedPageIndex.value == 0
                            ? Colors.white
                            : ColorConst.Primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.arP,
                        letterSpacing: 0.25.arP,
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Tez domain or address',
                          hintStyle: TextStyle(
                            color: const Color(0xFF625C66),
                            fontWeight: FontWeight.w400,
                            fontSize: 14.arP,
                            letterSpacing: 0.25.arP,
                          )),
                    ),
                  )),
              0.02.hspace,
              Obx(
                () => controller.suggestedContacts.isEmpty &&
                        controller.selectedReceiver.value == null
                    ? PasteButton(
                        onTap: controller.paste,
                      )
                    : controller.contacts
                                .where((p0) =>
                                    p0.address ==
                                        controller
                                            .searchTextController.value.text ||
                                    (controller.suggestedContacts.isNotEmpty
                                        ? controller
                                                .suggestedContacts[0].address ==
                                            p0.address
                                        : false))
                                .isEmpty &&
                            controller.contacts
                                .where((e) =>
                                    e == controller.selectedReceiver.value)
                                .isEmpty
                        ? AddContactButton(
                            contactModel: controller.suggestedContacts.first,
                          )
                        : const SizedBox(),
              )
            ],
          ),
        ],
      );
}
