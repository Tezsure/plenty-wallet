import 'dart:math';

import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/token_model.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';

class AccountSummaryController extends GetxController {
  RxBool isEditable = false.obs; // for token edit mode
  RxBool expandTokenList =
      false.obs; // false = show 3 tokens, true = show all tokens
  RxBool isAccountDelegated =
      false.obs; // To check if current account is delegated

  void onPinToken() {}

  void onHideToken() {}

  RxList<TokenModel> pinnedTokenList = <TokenModel>[].obs; // pinned tokens list

  RxList<TokenModel> tokens = List.generate(
          6,
          (index) => TokenModel(
              tokenName: "tezos",
              price: 24.4,
              isSelected: false,
              imagePath:
                  "${PathConst.SEND_PAGE}token${(Random().nextInt(3) + 1)}.svg"))
      .obs; // List of tokens

}
