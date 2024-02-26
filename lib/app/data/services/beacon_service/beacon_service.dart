// ignore_for_file: override_on_non_overriding_member

import 'dart:convert';

import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:plenty_wallet/app/data/services/rpc_service/rpc_service.dart';
import 'package:plenty_wallet/app/modules/beacon_bottom_sheet/opreation_request/views/opreation_request_view.dart';
import 'package:plenty_wallet/app/modules/beacon_bottom_sheet/pair_request/views/pair_request_view.dart';
import 'package:plenty_wallet/app/modules/beacon_bottom_sheet/payload_request/views/payload_request_view.dart';
import 'package:plenty_wallet/app/modules/beacon_bottom_sheet/widgets/test_network_alert_sheet.dart';
import 'package:plenty_wallet/app/modules/common_widgets/no_accounts_founds_bottom_sheet.dart';
import 'package:plenty_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:plenty_wallet/utils/common_functions.dart';
import 'package:uni_links/uni_links.dart';
import 'package:bs58check/bs58check.dart' as bs58check;

class BeaconService extends GetxService {
  final beaconPlugin = Beacon();

  @override
  void onInit() async {
    super.onInit();

    debugPrint('BeaconService Started');

    try {
      await beaconPlugin.startBeacon(walletName: "naan");
      Future.delayed(const Duration(seconds: 1), () async {
        beaconPlugin.getBeaconResponse().listen((data) async {
          debugPrint('BeaconService fired: $data');
          final Map<String, dynamic> requestJson =
              jsonDecode(data) as Map<String, dynamic>;

          final BeaconRequest beaconRequest =
              BeaconRequest.fromJson(requestJson);

          switch (beaconRequest.type!) {
            case RequestType.permission:
              debugPrint("Permission requested");
              HomePageController home = Get.find<HomePageController>();
              final address = home.userAccounts.isEmpty
                  ? null
                  : home.userAccounts[home.selectedIndex.value].publicKeyHash;
              NaanAnalytics.logEvent(NaanAnalyticsEvents.DAPP_CLICK, param: {
                "type": beaconRequest.type!,
                "name": beaconRequest.peer?.name,
                "address": address
              });
              if (home.userAccounts
                  .where((element) => element.isWatchOnly == false)
                  .toList()
                  .isEmpty) {
                await beaconPlugin.permissionResponse(
                  id: beaconRequest.request!.id!,
                  publicKey: null,
                  address: null,
                );
                CommonFunctions.bottomSheet(NoAccountsFoundBottomSheet());

                return;
              }
              if (beaconRequest.request!.network!.type.toString() ==
                  (await RpcService.getCurrentNetworkType()).toString()) {
                CommonFunctions.bottomSheet(const PairRequestView(),
                    settings: RouteSettings(arguments: beaconRequest));
              } else {
                CommonFunctions.bottomSheet(
                    TestNetworkBottomSheet(request: beaconRequest));
              }
              break;
            case RequestType.signPayload:
              debugPrint("payload request $beaconRequest");
              CommonFunctions.bottomSheet(const PayloadRequestView(),
                  settings: RouteSettings(arguments: beaconRequest));
              break;
            case RequestType.operation:
              debugPrint("operation request $beaconRequest");
              if (beaconRequest.request!.network!.type.toString() ==
                  (await RpcService.getCurrentNetworkType()).toString()) {
                CommonFunctions.bottomSheet(const OpreationRequestView(),
                    settings: RouteSettings(arguments: beaconRequest));
              } else {
                CommonFunctions.bottomSheet(
                  TestNetworkBottomSheet(
                    request: beaconRequest,
                  ),
                );
              }
              break;
            case RequestType.broadcast:
              debugPrint("broadcast request $beaconRequest");
              break;
          }
        }, onError: (err) {
          debugPrint('BeaconService error: $err');
          Get.snackbar("Error", err.toString());
        }, onDone: () {
          debugPrint("BeaconService done");
        });
        String link = (await getInitialUri()).toString();
        if (link.isNotEmpty || link != "null") {
          if (link.startsWith('tezos://') || link.startsWith('naan://')) {
            link = link.substring(link.indexOf("data=") + 5, link.length);
            // check for base58 is valid
            try {
              bs58check.decode(link);
            } catch (e) {
              return;
            }

            try {
              await beaconPlugin.pair(pairingRequest: link);
            } catch (e) {}
          }
        }
        linkStream.listen((String? link) async {
          if (link != null) {
            if (link.startsWith('tezos://') || link.startsWith('naan://')) {
              link = link.substring(link.indexOf("data=") + 5, link.length);

              try {
                bs58check.decode(link);
              } catch (e) {
                return;
              }

              try {
                await beaconPlugin.pair(pairingRequest: link);
              } catch (e) {}
            }
          }
        }, onError: (err) {
          debugPrint("beacon ${err.toString()}");
        });
      });
    } catch (e) {
      debugPrint('BeaconService error: $e');
      Get.snackbar("Error", e.toString());
    }
  }

  @override
  void stop() {
    beaconPlugin.stop();
    super.onClose();
  }

  @override
  void onClose() {
    debugPrint("BeaconService Closed");
    super.onClose();
  }
}
