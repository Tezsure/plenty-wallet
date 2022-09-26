import 'package:dartez/dartez.dart';
import 'package:naan_wallet/app/data/services/service_models/account_token_model.dart';
import 'package:naan_wallet/app/data/services/service_models/operation_model.dart';

class OperationService {
  Future<dynamic> sendXtzTx(
      OperationModel operationModel, String rpcNode) async {
    var transactionSigner = await Dartez.createSigner(Dartez.writeKeyWithHint(
        operationModel.keyStoreModel!.secretKey, 'edsk'));
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
    var transactionSigner = await Dartez.createSigner(Dartez.writeKeyWithHint(
        operationModel.keyStoreModel!.secretKey, 'edsk'));
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
      codeFormat: TezosParameterFormat.Michelson,
    );
  }

  Future<Map<String, dynamic>> preApplyOperation(
      OperationModel operationModel, String rpcNode) async {
    var transactionSigner = await Dartez.createSigner(Dartez.writeKeyWithHint(
        operationModel.keyStoreModel!.secretKey, 'edsk'));
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
    return await Dartez.injectOperation(rpcNode, preAppliedResult);
  }
}
