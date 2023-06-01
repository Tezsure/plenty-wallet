import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cast/cast.dart';
import 'package:naan_wallet/utils/colors/colors.dart';

class CastScreenController extends GetxController {
  CastSessionManager castSessionManager = CastSessionManager();
  Future<List<CastDevice>>? _future;
  Rx session = null.obs;
  Rx<CastDevice?> device = null.obs;
  Future<void> startSearch() async {
    _future = CastDiscoveryService().search();
  }

  Future<void> connect(CastDevice object) async {
    toggleLoaderOverlay(() async {
      session = (await castSessionManager.startSession(object)).obs;
      device = object.obs;
    });

    session.value?.stateStream.listen((state) {
      if (state == CastSessionState.connected) {
        _sendMessage(session.value!);
      }
    });

    session.value?.messageStream.listen((message) {
      print('receive message: $message');
    });

    session.value?.sendMessage(CastSession.kNamespaceReceiver, {
      'type': 'LAUNCH',
      'appId': 'com.naam', // set the appId of your app here
    });
  }

  Future<void> disconnect() async {
    session.value = null;
    await CastSessionManager().endSession(session.value!.sessionId);
  }

  void _sendMessage(CastSession session) {
    session.sendMessage('urn:x-cast:namespace-of-the-app', {
      'type': 'NFT',
    });
  }

  Future<void> toggleLoaderOverlay(Function() asyncFunction) async {
    await Get.showOverlay(
        asyncFunction: () async => await asyncFunction(),
        loadingWidget: const SizedBox(
          height: 50,
          width: 50,
          child: Center(
              child: CupertinoActivityIndicator(
                            color: ColorConst.Primary,
                          )),
        ));
    // if (Get.isOverlaysOpen) {
    //   Get.back();
    // }
  }
}
