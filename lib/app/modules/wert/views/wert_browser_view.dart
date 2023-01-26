import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:get/get.dart';

import 'package:naan_wallet/app/modules/wert/controllers/wert_browser_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class WertBrowserView extends GetView<WertBrowserController> {
  final String? tagString;
  const WertBrowserView({Key? key, this.tagString}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(WertBrowserController(), tag: tagString);

    final GlobalKey webViewKey = GlobalKey();
    InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
            useShouldOverrideUrlLoading: true,
            mediaPlaybackRequiresUserGesture: false,
            allowUniversalAccessFromFileURLs: true,
            useOnLoadResource: true),
        android: AndroidInAppWebViewOptions(
          useHybridComposition: true,
        ),
        ios: IOSInAppWebViewOptions(
          allowsInlineMediaPlayback: true,
        ));
    PullToRefreshController pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          controller.webViewController?.reload();
        } else if (Platform.isIOS) {
          controller.webViewController?.loadUrl(
              urlRequest: URLRequest(
                  url: await controller.webViewController?.getUrl()));
        }
      },
    );

    return Container(
      height: 0.95.height,
      width: 1.width,
      margin: EdgeInsets.only(top: 0.05.height),
      padding: EdgeInsets.only(
        bottom: Platform.isIOS ? 0.03.height : 0.01.height,
      ),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          color: ColorConst.darkGrey),
      child: Center(
        child: Column(
          children: [
            0.005.vspace,
            Container(
              height: 5,
              width: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
              ),
            ),
            AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset(
                    "assets/dapp_browser/lock.png",
                    height: 12,
                    width: 12,
                  ),
                  0.01.hspace,
                  Text(
                    "Buy NFT",
                    style: bodyMedium,
                  ),
                ],
              ),
              backgroundColor: ColorConst.darkGrey,
              centerTitle: true,
              toolbarHeight: 60,
              automaticallyImplyLeading: false,
            ),
            Expanded(
              child: InAppWebView(
                gestureRecognizers: {
                  Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer(),
                  ),
                },
                key: webViewKey,
                initialUrlRequest: URLRequest(
                    url: Uri.parse(
                  controller.initUrl,
                )),
                initialOptions: options,
                pullToRefreshController: pullToRefreshController,
                onWebViewCreated: (webViewcontroller) {
                  controller.webViewController = webViewcontroller;
                },
                onLoadStart: (controller, url) {
                  this.controller.url.value = url.toString();
                },
                androidOnPermissionRequest:
                    (controller, origin, resources) async {
                  return PermissionRequestResponse(
                    resources: resources,
                    action: PermissionRequestResponseAction.GRANT,
                  );
                },
                onLoadStop: (controller, url) async {
                  pullToRefreshController.endRefreshing();
                  this.controller.url.value = url.toString();
                  this.controller.setCanGoBackForward();
                },
                onLoadError: (controller, url, code, message) {
                  pullToRefreshController.endRefreshing();
                },
                onProgressChanged: (webController, progress) {
                  if (progress == 100) {
                    pullToRefreshController.endRefreshing();
                    controller.setCanGoBackForward();
                  }
                  controller.progress.value = progress / 100;
                },
                onUpdateVisitedHistory: (controller, url, androidIsReload) {
                  print(url.toString());
                  this.controller.url.value = url.toString();
                  this.controller.onUrlUpdate(url.toString());
                },
                onConsoleMessage: (controller, consoleMessage) {
                  print(consoleMessage);
                },
              ),
            ),
            Obx(
              () => controller.progress.value < 1.0
                  ? LinearProgressIndicator(value: controller.progress.value)
                  : Container(),
            ),
            Divider(
              height: 1,
              color: Colors.white.withOpacity(0.5),
            ),
            KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
              return isKeyboardVisible
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Obx(
                                  () => IconButton(
                                    icon: controller.canGoBack.value
                                        ? Image.asset(
                                            "assets/dapp_browser/back_light.png",
                                            height: 20,
                                            width: 20,
                                          )
                                        : Image.asset(
                                            "assets/dapp_browser/back_dark.png",
                                            height: 20,
                                            width: 20,
                                          ),
                                    onPressed: () {
                                      if (controller.canGoBack.value) {
                                        controller.webViewController?.goBack();
                                      }
                                    },
                                  ),
                                ),
                                Obx(
                                  () => IconButton(
                                    icon: controller.canGoForward.value
                                        ? Image.asset(
                                            "assets/dapp_browser/forward_light.png",
                                            height: 20,
                                            width: 20,
                                          )
                                        : Image.asset(
                                            "assets/dapp_browser/forward_dark.png",
                                            height: 20,
                                            width: 20,
                                          ),
                                    onPressed: () {
                                      if (controller.canGoForward.value) {
                                        controller.webViewController
                                            ?.goForward();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          0.2.hspace,
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                IconButton(
                                  icon: Image.asset(
                                    "assets/dapp_browser/reload.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                  color: Colors.white,
                                  onPressed: () {
                                    controller.webViewController?.reload();
                                  },
                                ),
                                IconButton(
                                  icon: Image.asset(
                                    "assets/dapp_browser/home.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                  color: Colors.white,
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
            })
          ],
        ),
      ),
    );
  }
}
