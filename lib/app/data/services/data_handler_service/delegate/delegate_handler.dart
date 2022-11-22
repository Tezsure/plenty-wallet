import 'dart:convert';

import 'package:naan_wallet/app/data/services/rpc_service/http_service.dart';
import 'package:naan_wallet/app/data/services/service_models/delegate_baker_list_model.dart';

class DelegateHandler {
  Future<List<DelegateBakerModel>> getBakerList() async {
    var response = await HttpService.performGetRequest(
        "https://api.tezos-nodes.com/v1/bakers");

    if (response.isNotEmpty && jsonDecode(response).length != 0) {
      return delegateBakersListResponseFromJson(response);
    }
    return [];
  }
}
