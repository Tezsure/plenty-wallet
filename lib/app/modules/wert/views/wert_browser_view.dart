import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:get/get.dart';
import 'package:plenty_wallet/app/modules/common_widgets/back_button.dart';

import 'package:plenty_wallet/app/modules/wert/controllers/wert_browser_controller.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/constants/constants.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';

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
      height: AppConstant.naanBottomSheetHeight - 18.arP,
      width: 1.width,
      padding: EdgeInsets.only(
        bottom: Platform.isIOS ? 0.03.height : 0.01.height,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(36.arP)),
          color: Colors.black),
      child: Center(
        child: Column(
          children: [
            0.01.vspace,
            Container(
              height: 5.arP,
              width: 36.arP,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.arP),
                color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
              ),
            ),
            AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/dapp_browser/lock.png",
                    height: 12.arP,
                    width: 12.arP,
                  ),
                  0.01.hspace,
                  Text(
                    "Buy NFT".tr,
                    style: bodyMedium,
                  ),
                  0.01.hspace,
                ],
              ),
              leading: SizedBox(
                width: 46.arP,
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 16.arP),
                  child: closeButton(),
                )
              ],
              backgroundColor: Colors.black,
              centerTitle: true,
              toolbarHeight: 50.arP,
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
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  var uri = navigationAction.request.url!;

                  if (!["https", "naan", "tezos"].contains(uri.scheme)) {
                    return NavigationActionPolicy.CANCEL;
                  }

                  return NavigationActionPolicy.ALLOW;
                },
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
                  debugPrint(url.toString());
                  this.controller.url.value = url.toString();
                  this.controller.onUrlUpdate(url.toString());
                },
                onConsoleMessage: (controller, consoleMessage) {
                  debugPrint(consoleMessage.toString());
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
