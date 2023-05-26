import 'package:dartez/dartez.dart';
// ignore: implementation_imports
import 'package:naan_wallet/app/data/services/service_models/operation_batch_model.dart';
import 'package:naan_wallet/app/data/services/service_models/operation_model.dart';

class OperationService {
  Future<dynamic> sendXtzTx(
      OperationModel operationModel, String rpcNode) async {
    var transactionSigner =
        Dartez.createSigner(operationModel.keyStoreModel!.secretKey!);
    return await Dartez.sendTransactionOperation(
      rpcNode,
      transactionSigner,
      operationModel.keyStoreModel!,
      operationModel.receiveAddress!,
      (operationModel.amount! * 1e6).toInt(),
    );
  }

  Future<Map<String, dynamic>> sendOperation(
      OperationModel operationModel, String rpcNode) async {
    var transactionSigner =
        Dartez.createSigner(operationModel.keyStoreModel!.secretKey!);
    return await Dartez.sendContractInvocatoinOperation(
      rpcNode,
      transactionSigner,
      operationModel.keyStoreModel!,
      [operationModel.receiverContractAddres!],
      [0],
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
      var transactionSigner = Dartez.createSigner(keyStore.secretKey!);
      return await Dartez.preapplyContractInvocationOperation(
        rpcNode,
        transactionSigner,
        keyStore,
        operationModel.map((e) => e.destination!).toList(),
        operationModel
            .map((e) => e.amount == null ? 0 : e.amount!.toInt())
            .toList(),
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
    var transactionSigner =
        Dartez.createSigner(operationModel.keyStoreModel!.secretKey!);
    return await Dartez.preapplyContractInvocationOperation(
      rpcNode,
      transactionSigner,
      operationModel.keyStoreModel!,
      [operationModel.receiverContractAddres!],
      [0],
      [operationModel.parameters!.entryPoint],
      [operationModel.parameters!.value],
      codeFormat: TezosParameterFormat.Michelson,
    );
  }

  Future<String> sendContractOrigination(
      OperationModel operationModel, String rpcNode) async {
    var transactionSigner =
        Dartez.createSigner(operationModel.keyStoreModel!.secretKey!);
    return (await Dartez.sendContractOriginationOperation(
      rpcNode,
      transactionSigner,
      operationModel.keyStoreModel!,
      operationModel.amount!.toInt(),
      "",
      operationModel.parameters!.entryPoint,
      operationModel.parameters!.value,
      codeFormat: TezosParameterFormat.Michelson,
    ))['appliedOp'];
  }

  Future<String> injectOperation(
      Map<String, dynamic> preAppliedResult, String rpcNode) async {
    return await Dartez.injectOperation(rpcNode, preAppliedResult['opPair']);
  }
}
