import 'package:dartez/dartez.dart';
// ignore: implementation_imports
import 'package:dartez/src/soft-signer/soft_signer.dart' show SignerCurve;
import 'package:naan_wallet/app/data/services/service_models/operation_batch_model.dart';
import 'package:naan_wallet/app/data/services/service_models/operation_model.dart';

class OperationService {
  Future<dynamic> sendXtzTx(
      OperationModel operationModel, String rpcNode) async {
    var transactionSigner = Dartez.createSigner(
        Dartez.writeKeyWithHint(
            operationModel.keyStoreModel!.secretKey,
            operationModel.keyStoreModel!.publicKeyHash.startsWith("tz2")
                ? 'spsk'
                : 'edsk'),
        signerCurve:
            operationModel.keyStoreModel!.publicKeyHash.startsWith("tz2")
                ? SignerCurve.SECP256K1
                : SignerCurve.ED25519);
    return await Dartez.sendTransactionOperation(
      rpcNode,
      transactionSigner,
      operationModel.keyStoreModel!,
      operationModel.receiveAddress!,
      (operationModel.amount! * 1e6).toInt(),
      1500,
    );
  }

  Future<Map<String, dynamic>> sendOperation(
      OperationModel operationModel, String rpcNode) async {
    var transactionSigner = Dartez.createSigner(
        Dartez.writeKeyWithHint(
            operationModel.keyStoreModel!.secretKey,
            operationModel.keyStoreModel!.publicKeyHash.startsWith("tz2")
                ? 'spsk'
                : 'edsk'),
        signerCurve:
            operationModel.keyStoreModel!.publicKeyHash.startsWith("tz2")
                ? SignerCurve.SECP256K1
                : SignerCurve.ED25519);
    return await Dartez.sendContractInvocatoinOperation(
      rpcNode,
      transactionSigner,
      operationModel.keyStoreModel!,
      [operationModel.receiverContractAddres!],
      [0],
      120000,
      1000,
      100000,
      [operationModel.parameters!.entryPoint],
      [operationModel.parameters!.value],
      codeFormat: TezosParameterFormat.Micheline,
    );
  }

  Future<Map<String, dynamic>> preApplyOperationBatch(
      List<OperationModelBatch> operationModel,
      String rpcNode,
      KeyStoreModel keyStore) async {
    try {
      var transactionSigner = Dartez.createSigner(
          Dartez.writeKeyWithHint(keyStore.secretKey,
              keyStore.publicKeyHash.startsWith("tz2") ? 'spsk' : 'edsk'),
          signerCurve: keyStore.publicKeyHash.startsWith("tz2")
              ? SignerCurve.SECP256K1
              : SignerCurve.ED25519);
      return await Dartez.preapplyContractInvocationOperation(
        rpcNode,
        transactionSigner,
        keyStore,
        operationModel.map((e) => e.destination!).toList(),
        operationModel
            .map((e) => e.amount == null ? 0 : e.amount!.toInt())
            .toList(),
        120000,
        1000,
        100000,
        operationModel.map((e) => e.entrypoint!).toList(),
        operationModel.map((e) => e.parameters!.toString()).toList(),
        codeFormat: TezosParameterFormat.Micheline,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> preApplyOperation(
      OperationModel operationModel, String rpcNode) async {
    var transactionSigner = Dartez.createSigner(
        Dartez.writeKeyWithHint(
            operationModel.keyStoreModel!.secretKey,
            operationModel.keyStoreModel!.publicKeyHash.startsWith("tz2")
                ? 'spsk'
                : 'edsk'),
        signerCurve:
            operationModel.keyStoreModel!.publicKeyHash.startsWith("tz2")
                ? SignerCurve.SECP256K1
                : SignerCurve.ED25519);
    return await Dartez.preapplyContractInvocationOperation(
      rpcNode,
      transactionSigner,
      operationModel.keyStoreModel!,
      [operationModel.receiverContractAddres!],
      [0],
      120000,
      1000,
      100000,
      [operationModel.parameters!.entryPoint],
      [operationModel.parameters!.value],
      codeFormat: TezosParameterFormat.Michelson,
    );
  }

  Future<String> injectOperation(
      Map<String, dynamic> preAppliedResult, String rpcNode) async {
    return await Dartez.injectOperation(rpcNode, preAppliedResult['opPair']);
  }
}
