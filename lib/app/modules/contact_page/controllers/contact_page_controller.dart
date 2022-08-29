import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/modules/contact_page/models/contact_model.dart';

class ContactPageController extends GetxController {
  Rx<TextEditingController> searchTextController = TextEditingController().obs;
  Rx<String> searchText = "".obs;
  RxList<ContactModel> recentsContacts = List.generate(
    3,
    (index) => ContactModel(
        name: 'AmSrik',
        address: "tzAm...Srik",
        imagePath: ServiceConfig.allAssetsProfileImages[
            Random().nextInt(ServiceConfig.allAssetsProfileImages.length - 1)]),
  ).obs;

  RxList<ContactModel> contacts = List.generate(
      20,
      (index) => ContactModel(
          name: 'AmSrik',
          address: "tzAm...Srik",
          imagePath: ServiceConfig.allAssetsProfileImages[Random()
              .nextInt(ServiceConfig.allAssetsProfileImages.length - 1)])).obs;

  RxList<ContactModel> suggestedContacts = <ContactModel>[].obs;

  void paste() async {
    ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);
    if (cdata != null) {
      searchTextController.value.text = cdata.text!;
      searchText.value = cdata.text!;
    }
  }

  @override
  void dispose() {
    searchTextController.value.dispose();
    super.dispose();
  }
}
