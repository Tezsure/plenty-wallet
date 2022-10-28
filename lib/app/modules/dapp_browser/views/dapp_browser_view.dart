import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../controllers/dapp_browser_controller.dart';

class DappBrowserView extends GetView<DappBrowserController> {
  const DappBrowserView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final GlobalKey webViewKey = GlobalKey();
    InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false,
          allowUniversalAccessFromFileURLs: true,
        ),
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
    Get.put(DappBrowserController());
    return Container(
      height: 0.95.height,
      width: 1.width,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          color: ColorConst.darkGrey),
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
          Obx(() => AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Icon(
                      Icons.lock_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    0.01.hspace,
                    Text(
                      Uri.parse(controller.url.value)
                          .host
                          .replaceAll(RegExp(r".+\/\/|www.|\..+"), ""),
                      style: bodyMedium,
                    ),
                  ],
                ),
                backgroundColor: ColorConst.darkGrey,
                centerTitle: true,
                toolbarHeight: 60,
                automaticallyImplyLeading: false,
              )),
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
                AppConstant.defaultUrl,
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
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                /*       var uri = navigationAction.request.url.toString();
                            if (uri.startsWith('tezos://') || uri.startsWith('naan://')) {
                              uri = uri.substring(uri.indexOf("data=") + 5, uri.length);
                              try {
                                var data = String.fromCharCodes(base58.decode(uri));
                                if (!data.endsWith("}"))
                                  data = data.substring(0, data.lastIndexOf('}') + 1);
                                var baseData = jsonDecode(data);
                                await BeaconPlugin.pair(baseData['name'], uri);
                                // await BeaconPlugin.addPeer(
                                //   baseData['id'],
                                //   baseData['name'],
                                //   baseData['publicKey'],
                                //   baseData['relayServer'],
                                //   baseData['version'] ?? "2",
                                // );
                              } catch (e) {}
                              return NavigationActionPolicy.CANCEL;
                            }
                            widget.controller.lastVisitedUrlOnDapp = uri; */
                return NavigationActionPolicy.ALLOW;
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
                this.controller.url.value = url.toString();
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
          Obx(
            () => Container(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          color: controller.canGoBack.value
                              ? Colors.white
                              : Colors.grey[700],
                          onPressed: () {
                            if (controller.canGoBack.value) {
                              controller.webViewController?.goBack();
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios),
                          color: controller.canGoForward.value
                              ? Colors.white
                              : Colors.grey[700],
                          onPressed: () {
                            if (controller.canGoForward.value) {
                              controller.webViewController?.goForward();
                            }
                          },
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
                          icon: const Icon(Icons.refresh),
                          color: Colors.white,
                          onPressed: () {
                            controller.webViewController?.reload();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.home),
                          color: Colors.white,
                          onPressed: () {
                            controller.webViewController?.loadUrl(
                                urlRequest: URLRequest(
                                    url: Uri.parse(AppConstant.defaultUrl)));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
          )
        ],
      ),
    );
  }
}
