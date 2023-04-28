import 'dart:convert';

import 'package:naan_wallet/app/data/services/rpc_service/http_service.dart';
import 'package:naan_wallet/app/data/services/service_models/delegate_baker_list_model.dart';
import 'package:naan_wallet/app/data/services/service_models/delegate_cycle_model.dart';
import 'package:naan_wallet/app/data/services/service_models/delegate_reward_model.dart';

import '../../../modules/settings_page/enums/network_enum.dart';
import '../service_config/service_config.dart';

class DelegateHandler {
  Future<List<DelegateBakerModel>> getBakerList() async {
    String network = "";
    final rpc = ServiceConfig.currentNetwork == NetworkType.mainnet
        ? ""
        : ServiceConfig.currentSelectedNode;
    if (Uri.parse(rpc).path.isNotEmpty) {
      network = "${Uri.parse(rpc).path.replaceAll("/", "")}.";
    }
    network = network.contains("ak-csrjehxhpw0dl3") ? "" : network;
    late String response;
    if (network.isNotEmpty) {
      response = await HttpService.performGetRequest(
          "https://api.${network}tzkt.io/v1/delegates?active=true&sort.desc=stakingBalance");
    } else {
      response = await HttpService.performGetRequest(
          "https://api.tezos-nodes.com/v1/bakers");
    }

    if (response.isNotEmpty && jsonDecode(response).length != 0) {
      return delegateBakersListResponseFromJson(response);
    }
    return [];
  }

  Future<String?> checkBaker(String pKH) async {
    String network = "";
    final rpc = ServiceConfig.currentNetwork == NetworkType.mainnet
        ? ""
        : ServiceConfig.currentSelectedNode;
    if (Uri.parse(rpc).path.isNotEmpty) {
      network = "${Uri.parse(rpc).path.replaceAll("/", "")}.";
    }
    network = network.contains("ak-csrjehxhpw0dl3") ? "" : network;
    network = network.replaceAll("net", "");
    try {
      var response = await HttpService.performGetRequest(
          "https://api.${network}tzstats.com/explorer/account/$pKH");

      if (response.isNotEmpty && jsonDecode(response).length != 0) {
        return jsonDecode(response)['baker'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<DelegateBakerModel?> bakerDetail(String pKH) async {
    String network = "";
    final rpc = ServiceConfig.currentNetwork == NetworkType.mainnet
        ? ""
        : ServiceConfig.currentSelectedNode;
    if (Uri.parse(rpc).path.isNotEmpty) {
      network = "${Uri.parse(rpc).path.replaceAll("/", "")}.";
    }
    network = network.contains("ak-csrjehxhpw0dl3") ? "" : network;
    String url = "https://api.baking-bad.org/v2/bakers/$pKH";
    if (network.isNotEmpty) {
      url = "https://api.${network}tzkt.io/v1/delegates/$pKH";
    }
    var response = await HttpService.performGetRequest(url);

    if (response.isNotEmpty && jsonDecode(response).length != 0) {
      return DelegateBakerModel.fromJson(jsonDecode(response));
    }
    return null;
  }

  Future<List<DelegateRewardModel>> getDelegateReward(
    String pKH,
  ) async {
    String network = "";
    final rpc = ServiceConfig.currentNetwork == NetworkType.mainnet
        ? ""
        : ServiceConfig.currentSelectedNode;
    if (Uri.parse(rpc).path.isNotEmpty) {
      network = "${Uri.parse(rpc).path.replaceAll("/", "")}.";
    }
    network = network.contains("ak-csrjehxhpw0dl3") ? "" : network;
    // pKH = 'tz1epDdf6ixVEJaApZSckJqxo5qr7CxdDhbE';
    // baker = 'tz1gg5bjopPcr9agjamyu9BbXKLibNc2rbAq';
    var response = await HttpService.performGetRequest(
        "https://api.${network}tzkt.io/v1/rewards/delegators/$pKH?limit=10000");

    if (response.isNotEmpty && jsonDecode(response).length != 0) {
      return delegateRewardListResponseFromJson(response);
    }
    return [];
  }

  Future<List<DelegateCycleStatusModel>> getCycleStatus(int limit) async {
    String network = "";
    final rpc = ServiceConfig.currentNetwork == NetworkType.mainnet
        ? ""
        : ServiceConfig.currentSelectedNode;
    if (Uri.parse(rpc).path.isNotEmpty) {
      network = "${Uri.parse(rpc).path.replaceAll("/", "")}.";
    }
    network = network.contains("ak-csrjehxhpw0dl3") ? "" : network;
    var response = await HttpService.performGetRequest(
        "https://api.${network}tzkt.io/v1/cycles?limit=$limit");

    if (response.isNotEmpty && jsonDecode(response).length != 0) {
      return delegateCycleListResponseFromJson(response);
    }
    return [];
  }
}
