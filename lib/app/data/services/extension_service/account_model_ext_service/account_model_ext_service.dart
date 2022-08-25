import 'package:naan_wallet/app/data/services/rpc_service/rpc_service.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';

extension AccountModelExtService on AccountModel {
  Future<double> getUserBalanceInTezos() async =>
      await RpcService().getUserBalanceInTezos(publicKeyHash!);
}
