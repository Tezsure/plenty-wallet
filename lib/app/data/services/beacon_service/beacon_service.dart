import 'dart:convert';

import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:naan_wallet/app/data/services/rpc_service/rpc_service.dart';
import 'package:naan_wallet/app/modules/beacon_bottom_sheet/opreation_request/views/opreation_request_view.dart';
import 'package:naan_wallet/app/modules/beacon_bottom_sheet/pair_request/views/pair_request_view.dart';
import 'package:naan_wallet/app/modules/beacon_bottom_sheet/payload_request/views/payload_request_view.dart';
import 'package:naan_wallet/app/modules/beacon_bottom_sheet/widgets/test_network_alert_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/no_accounts_founds_bottom_sheet.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:uni_links/uni_links.dart';

class BeaconService extends GetxService {
  final beaconPlugin = Beacon();

  @override
  void onInit() async {
    super.onInit();

    print('BeaconService Started');
    await beaconPlugin.startBeacon(walletName: "Naan");
    try {
      Future.delayed(const Duration(seconds: 1), () async {
        beaconPlugin.getBeaconResponse().listen((data) async {
          print('BeaconService fired: $data');
          final Map<String, dynamic> requestJson =
              jsonDecode(data) as Map<String, dynamic>;

          final BeaconRequest beaconRequest =
              BeaconRequest.fromJson(requestJson);

          switch (beaconRequest.type!) {
            case RequestType.permission:
              print("Permission requested");
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
                Get.bottomSheet(
                  const NoAccountsFoundBottomSheet(),
                  isScrollControlled: true,
                  enterBottomSheetDuration: const Duration(milliseconds: 180),
                  exitBottomSheetDuration: const Duration(milliseconds: 150),
                );

                return;
              }
              if (beaconRequest.request!.network!.type.toString() ==
                  (await RpcService.getCurrentNetworkType()).toString()) {
                Get.bottomSheet(const PairRequestView(),
                    enterBottomSheetDuration: const Duration(milliseconds: 180),
                    exitBottomSheetDuration: const Duration(milliseconds: 150),
                    barrierColor: Colors.white.withOpacity(0.09),
                    isScrollControlled: true,
                    settings: RouteSettings(arguments: beaconRequest));
              } else {
                Get.bottomSheet(
                    TestNetworkBottomSheet(
                      request: beaconRequest,
                    ),
                    enterBottomSheetDuration: const Duration(milliseconds: 180),
                    exitBottomSheetDuration: const Duration(milliseconds: 150),
                    barrierColor: Colors.white.withOpacity(0.09),
                    isScrollControlled: true);
              }
              break;
            case RequestType.signPayload:
              print("payload request $beaconRequest");
              Get.bottomSheet(const PayloadRequestView(),
                  enterBottomSheetDuration: const Duration(milliseconds: 180),
                  exitBottomSheetDuration: const Duration(milliseconds: 150),
                  barrierColor: Colors.white.withOpacity(0.09),
                  isScrollControlled: true,
                  settings: RouteSettings(arguments: beaconRequest));
              break;
            case RequestType.operation:
              print("operation request $beaconRequest");
              if (beaconRequest.request!.network!.type.toString() ==
                  (await RpcService.getCurrentNetworkType()).toString()) {
                Get.bottomSheet(const OpreationRequestView(),
                    enterBottomSheetDuration: const Duration(milliseconds: 180),
                    exitBottomSheetDuration: const Duration(milliseconds: 150),
                    barrierColor: Colors.white.withOpacity(0.09),
                    isScrollControlled: true,
                    settings: RouteSettings(arguments: beaconRequest));
              } else {
                Get.bottomSheet(
                    TestNetworkBottomSheet(
                      request: beaconRequest,
                    ),
                    enterBottomSheetDuration: const Duration(milliseconds: 180),
                    exitBottomSheetDuration: const Duration(milliseconds: 150),
                    barrierColor: Colors.white.withOpacity(0.09),
                    isScrollControlled: true);
              }
              break;
            case RequestType.broadcast:
              print("broadcast request $beaconRequest");
              break;
          }
        }, onError: (err) {
          print('BeaconService error: $err');
          Get.snackbar("Error", err.toString());
        }, onDone: () {
          print("BeaconService done");
        });
        String link = (await getInitialUri()).toString();
        if (link.isNotEmpty || link != "null") {
          if (link.startsWith('tezos://') || link.startsWith('naan://')) {
            link = link.substring(link.indexOf("data=") + 5, link.length);

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
                await beaconPlugin.pair(pairingRequest: link);
              } catch (e) {}
            }
          }
        }, onError: (err) {
          print(err.toString());
        });
      });
    } catch (e) {
      print('BeaconService error: $e');
      Get.snackbar("Error", e.toString());
    }
  }

  @override
  void onClose() {
    print("BeaconService Closed");
    super.onClose();
  }
}
