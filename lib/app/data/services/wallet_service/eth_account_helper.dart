import 'dart:typed_data';
import 'package:bip39/bip39.dart' as bip39;
import 'package:dartez/helper/generateKeys.dart';
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:hex/hex.dart';
import 'package:web3dart/web3dart.dart';

class EthAccountModel {
  final String privateKey;
  final Credentials credentials;
  int derivationIndex = 0;

  EthAccountModel({required this.privateKey, required this.credentials});
}

class TezToEthPrivateKeyConverter {
  static EthAccountModel convert(String privateKey) {
    var ethPrivateKey = GenerateKeys.writeKeyWithHint(privateKey, "spsk");
    String hexCode = HEX.encode(ethPrivateKey.toList());
    var credentials = EthPrivateKey.fromHex(hexCode);
    return EthAccountModel(privateKey: hexCode, credentials: credentials);
  }
}

class EthToTezPrivateKeyConverter {
  static String convert(String privateKey) {
    var tezPrivateKey = GenerateKeys.readKeysWithHint(
        Uint8List.fromList(HEX.decoder.convert(privateKey)),
        GenerateKeys.keyPrefixes[PrefixEnum.spsk]!);
    return tezPrivateKey;
  }
}

class EthPrivateKeyValidator {
  static bool isValid(String privateKey) {
    try {
      EthPrivateKey.fromHex(privateKey);
      return true;
    } catch (e) {
      return false;
    }
  }
}

class EthAccountHelper {
  static Future<EthAccountModel> getFromMnemonic(String mnemonic,
      {int derivationIndex = 0}) async {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final master =
        await ED25519_HD_KEY.derivePath("m/44'/60'/$derivationIndex'/0'", seed);
    String privateHexCode = HEX.encode(master.key);
    var credentials = EthPrivateKey.fromHex(privateHexCode);

    return EthAccountModel(privateKey: privateHexCode, credentials: credentials)
      ..derivationIndex = derivationIndex;
  }
}
