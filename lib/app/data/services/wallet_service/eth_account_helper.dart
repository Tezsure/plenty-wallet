import 'dart:typed_data';

import 'package:dartez/helper/generateKeys.dart';
import 'package:hex/hex.dart';
import 'package:plenty_wallet/app/data/services/service_models/account_model.dart';
import 'package:web3dart/web3dart.dart';

class EthAccountModel {
  final String privateKey;
  final Credentials credentials;

  EthAccountModel({required this.privateKey, required this.credentials});
}

/// A helper class for Ethereum account operations.
class EthAccountHelper {
  /// Retrieves Ethereum credentials from a Tezos private key.
  ///
  /// Converts the Tezos private key to an Ethereum private key and returns the corresponding credentials.
  ///
  /// - [privateKey]: The Tezos private key.
  /// Returns the Ethereum credentials.
  static EthAccountModel getFromTezPrivateKey(String privateKey) {
    var ethPrivateKey = GenerateKeys.writeKeyWithHint(privateKey, "spsk");
    String hexCode = HEX.encode(ethPrivateKey.toList());
    var credentials = EthPrivateKey.fromHex(hexCode);
    return EthAccountModel(privateKey: hexCode, credentials: credentials);
  }

  static String getFromEthPrivateKey(String privateKey) {
    var tezPrivateKey = GenerateKeys.readKeysWithHint(
        Uint8List.fromList(HEX.decoder.convert(privateKey)),
        GenerateKeys.keyPrefixes[PrefixEnum.spsk]!);
    return tezPrivateKey;
  }

  static bool checkIfEthPrivateKey(String privateKey) {
    try {
      EthPrivateKey.fromHex(privateKey);
      return true;
    } catch (e) {
      return false;
    }
  }
}
