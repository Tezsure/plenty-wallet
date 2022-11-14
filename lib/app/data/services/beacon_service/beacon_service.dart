import 'dart:convert';

import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/beacon_bottom_sheet/opreation_request/views/opreation_request_view.dart';
import 'package:naan_wallet/app/modules/beacon_bottom_sheet/pair_request/views/pair_request_view.dart';
import 'package:naan_wallet/app/modules/beacon_bottom_sheet/payload_request/views/payload_request_view.dart';

class BeaconService extends GetxService {
  final beaconPlugin = Beacon();

  @override
  void onInit() async {
    super.onInit();
    print('BeaconService Started');
    await beaconPlugin.startBeacon(walletName: "Naan");
    try {
      Future.delayed(const Duration(seconds: 1), () {
        beaconPlugin.getBeaconResponse().listen((data) {
          print('BeaconService fired: $data');
          final Map<String, dynamic> requestJson =
              jsonDecode(data) as Map<String, dynamic>;

          final BeaconRequest beaconRequest =
              BeaconRequest.fromJson(requestJson);

          switch (beaconRequest.type!) {
            case RequestType.permission:
              print("Permission requested");
              Get.bottomSheet(const PairRequestView(),
                  barrierColor: Colors.white.withOpacity(0.09),
                  isScrollControlled: true,
                  settings: RouteSettings(arguments: beaconRequest));
              break;
            case RequestType.signPayload:
              print("payload request $beaconRequest");
              Get.bottomSheet(const PayloadRequestView(),
                  barrierColor: Colors.white.withOpacity(0.09),
                  isScrollControlled: true,
                  settings: RouteSettings(arguments: beaconRequest));
              break;
            case RequestType.operation:
              print("operation request $beaconRequest");
              Get.bottomSheet(const OpreationRequestView(),
                  barrierColor: Colors.white.withOpacity(0.09),
                  isScrollControlled: true,
                  settings: RouteSettings(arguments: beaconRequest));
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
