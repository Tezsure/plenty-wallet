import 'package:dartez/dartez.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';

class RpcService {
  Future<double> getUserBalanceInTezos(String address) async {
    var balance =
        await Dartez.getBalance(address, ServiceConfig.currentSelectedNode);
    if (balance == "0") return 0.0;
    return (int.parse(balance) / 1e6);
  }
}
