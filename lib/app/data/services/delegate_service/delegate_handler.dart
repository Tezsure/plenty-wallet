import 'dart:convert';

import 'package:naan_wallet/app/data/services/rpc_service/http_service.dart';
import 'package:naan_wallet/app/data/services/service_models/delegate_baker_list_model.dart';
import 'package:naan_wallet/app/data/services/service_models/delegate_cycle_model.dart';
import 'package:naan_wallet/app/data/services/service_models/delegate_reward_model.dart';

class DelegateHandler {
  Future<List<DelegateBakerModel>> getBakerList() async {
    var response = await HttpService.performGetRequest(
        "https://api.tezos-nodes.com/v1/bakers");

    if (response.isNotEmpty && jsonDecode(response).length != 0) {
      return delegateBakersListResponseFromJson(response);
    }
    return [];
  }

  Future<String?> checkBaker(String pKH) async {
    try {
      var response = await HttpService.performGetRequest(
          "https://api.tzstats.com/explorer/account/$pKH");

      if (response.isNotEmpty && jsonDecode(response).length != 0) {
        return jsonDecode(response)['baker'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<DelegateBakerModel?> bakerDetail(String pKH) async {
    var response = await HttpService.performGetRequest(
        "https://api.baking-bad.org/v2/bakers/$pKH");

    if (response.isNotEmpty && jsonDecode(response).length != 0) {
      return DelegateBakerModel.fromJson(jsonDecode(response));
    }
    return null;
  }

  Future<List<DelegateRewardModel>> getDelegateReward(
    String pKH,
  ) async {
    // pKH = 'tz1epDdf6ixVEJaApZSckJqxo5qr7CxdDhbE';
    // baker = 'tz1gg5bjopPcr9agjamyu9BbXKLibNc2rbAq';
    var response = await HttpService.performGetRequest(
        "https://api.tzkt.io/v1/rewards/delegators/$pKH?limit=10000");

    if (response.isNotEmpty && jsonDecode(response).length != 0) {
      return delegateRewardListResponseFromJson(response);
    }
    return [];
  }

  Future<List<DelegateCycleStatusModel>> getCycleStatus(int limit) async {
    var response = await HttpService.performGetRequest(
        "https://api.tzkt.io/v1/cycles?limit=$limit");

    if (response.isNotEmpty && jsonDecode(response).length != 0) {
      return delegateCycleListResponseFromJson(response);
    }
    return [];
  }
}
