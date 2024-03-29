// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartez/dartez.dart';
import 'package:plenty_wallet/app/data/services/enums/enums.dart';
import 'package:plenty_wallet/app/data/services/service_models/account_token_model.dart';
import 'package:plenty_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:plenty_wallet/utils/utils.dart';

class OperationModel<T> {
  int? counter;
  KeyStoreModel? keyStoreModel;
  Map<String, dynamic>? preAppliedResult;
  T? model;
  String? receiverContractAddres;
  String? receiveAddress;
  double? amount;
  Parameters? parameters;
  String? code;
  String? storage;
  OperationModel(
      {this.counter,
      this.keyStoreModel,
      this.preAppliedResult,
      this.model,
      this.receiverContractAddres,
      this.receiveAddress,
      this.amount,
      this.code,
      this.storage});

  buildParams() {
    if (model is AccountTokenModel &&
        (model as AccountTokenModel).name != "Tezos") {
      var tokenModel = model as AccountTokenModel;
      var newAmount = ((amount! *
              double.parse(1
                  .toStringAsFixed(
                      tokenModel.decimals > 20 ? 20 : tokenModel.decimals)
                  .replaceAll('.', ''))))
          .toString()
          .removeTrailing0;

      if (newAmount.contains("e")) {
        newAmount = eToStringAmount(newAmount);
      }

      parameters = Parameters(
          entryPoint: "transfer",
          value: tokenModel.tokenStandardType == TokenStandardType.fa1
              ? """(Pair "${keyStoreModel!.publicKeyHash}" (Pair "$receiveAddress" $newAmount))"""
              : """{Pair "${keyStoreModel!.publicKeyHash}" {Pair "$receiveAddress" (Pair ${tokenModel.tokenId} $newAmount)}}""");
    } else if (model is NftTokenModel) {
      var nftModel = model as NftTokenModel;
      parameters = Parameters(
          entryPoint: "transfer",
          value:
              """{Pair "${keyStoreModel!.publicKeyHash}" {Pair "$receiveAddress" (Pair ${nftModel.tokenId} 1)}}""");
    }
  }

  String eToStringAmount(String amount) {
    var dotAmount = amount.substring(0, amount.indexOf("e"));

    return (dotAmount.replaceAll(".", "") +
            1
                .toStringAsFixed(int.parse(amount.split("e")[1]) -
                    dotAmount.split(".")[1].length)
                .replaceAll("1.", ""))
        .removeTrailing0;
  }
}

class Parameters {
  String entryPoint;
  String value;
  Parameters({
    required this.entryPoint,
    required this.value,
  });
}
