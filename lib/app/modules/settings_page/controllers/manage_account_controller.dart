import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';

class ManageAccountPageController extends GetxController {
  Rx<ScrollController> scrollcontroller = ScrollController().obs;
  RxList<AccountModel> accounts = List.generate(
      30,
      (index) => AccountModel(
            isNaanAccount: true,
            name: "Account $index",
          )).obs;

  RxBool isScrolling = false.obs;
  RxBool isRearranging = false.obs;

  makePrimaryAccount(int index) {
    final item = accounts.removeAt(index);
    accounts.insert(0, item);
  }

  removeAccount(int index) {
    accounts.removeAt(index);
  }

  // @override
  // // TODO: implement onDelete
  // InternalFinalCallback<void> get onDelete {
  //   ManageAccountPageController().dispose();
  //   return super.onDelete;
  // }
}
