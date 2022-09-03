import 'dart:math';

import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/token_model.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';

class AccountSummaryController extends GetxController {
  RxList<TokenModel> tokens = List.generate(
          6,
          (index) => TokenModel(
              tokenName: "tezos",
              price: 24.4,
              imagePath:
                  "${PathConst.SEND_PAGE}token${(Random().nextInt(3) + 1)}.svg"))
      .obs; // List of tokens

}
