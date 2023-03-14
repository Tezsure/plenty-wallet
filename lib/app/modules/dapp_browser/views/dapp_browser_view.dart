import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';

import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/text_scale_factor.dart';

import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../controllers/dapp_browser_controller.dart';

class DappBrowserView extends GetView<DappBrowserController> {
  final String? tagString;

  const DappBrowserView({Key? key, this.tagString}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(DappBrowserController(), tag: tagString);

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
          useOnNavigationResponse: true,
        ));
    PullToRefreshController pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: ColorConst.Primary,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          controller.webViewController?.reload();
        } else if (Platform.isIOS) {
          controller.webViewController?.loadUrl(
              urlRequest: URLRequest(
                  url: await controller.webViewController?.getUrl()));
        }
        controller.setCanGoBackForward();
      },
    );

    return OverrideTextScaleFactor(
      child: NaanBottomSheet(
        bottomSheetHorizontalPadding: 0,
        height: AppConstant.naanBottomSheetHeight,
        bottomSheetWidgets: [
          Container(
            height: AppConstant.naanBottomSheetHeight - 14.arP,
            // width: 1.width,
            // margin: EdgeInsets.only(
            //   top: 0.05.height,
            // ),
            padding: EdgeInsets.only(
              bottom: Platform.isIOS ? 0.03.height : 0.01.height,
            ),
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(10.arP)),
                color: Colors.black),
            child: Center(
              child: _buildBody(webViewKey, options, pullToRefreshController),
            ),
          ),
        ],
      ),
    );
  }

  Column _buildBody(
      GlobalKey<State<StatefulWidget>> webViewKey,
      InAppWebViewGroupOptions options,
      PullToRefreshController pullToRefreshController) {
    return Column(
      children: [
        Obx(() => AppBar(
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 16.arP),
                  child: closeButton(),
                )
              ],
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
                    controller.url.value.contains("https://wert")
                        ? "Buy tez".tr
                        : Uri.parse(controller.url.value)
                            .host
                            .replaceAll(RegExp(r".+\/\/|www.|"), ""),
                    style: bodyMedium,
                  ),
                ],
              ),
              backgroundColor: Colors.black,
              centerTitle: true,
              toolbarHeight: 50.arP,
              automaticallyImplyLeading: false,
            )),
        Expanded(
          child: Obx(
            (() => Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: ColorConst.darkGrey,
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerFloat,
                  floatingActionButton: controller.showButton.value
                      ? AnimatedContainer(
                          curve: Curves.fastOutSlowIn,
                          duration: const Duration(milliseconds: 350),
                          transform: Matrix4.identity()
                            ..translate(
                              0.0,
                              controller.isScrolling.value ? 220.0.arP : 0,
                            ),
                          child: SolidButton(
                            height: 45.arP,
                            borderRadius: 30.arP,
                            width: 110.arP,
                            primaryColor: ColorConst.Primary,
                            onPressed: () {
                              print("buy now ${controller.url.value}");
                              controller.naanBuy(controller.webViewController!
                                  .getUrl()
                                  .toString());
                            },
                            child: Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  0.01.hspace,
                                  Text(
                                    "Buy".tr,
                                    style: labelLarge,
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      : null,
                  body: InAppWebView(
                    onScrollChanged: (a, x, y) async {
                      //detect scroll
                      if (y != controller.scrollY.value) {
                        controller.isScrolling.value = true;
                        controller.scrollY.value = y;
                      }
                    },
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
                      this.controller.setCanGoBackForward();
                    },
                    androidOnPermissionRequest:
                        (controller, origin, resources) async {
                      return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT,
                      );
                    },
                    shouldOverrideUrlLoading:
                        (controller, navigationAction) async {
                      await this.controller.setCanGoBackForward();
                      var uri = navigationAction.request.url.toString();
                      if (uri.startsWith('tezos://') ||
                          uri.startsWith('naan://')) {
                        uri =
                            uri.substring(uri.indexOf("data=") + 5, uri.length);
                        try {
                          //print(uri);
                          /*                     var data = String.fromCharCodes(base58.decode(uri));
                            if (!data.endsWith("}"))
                              data = data.substring(0, data.lastIndexOf('}') + 1);
                            var baseData = jsonDecode(data); */
                          print("got here $uri");
                          await this
                              .controller
                              .beaconPlugin
                              .pair(pairingRequest: uri);

                          //print("response yo: $response");
                          // await BeaconPlugin.addPeer(
                          //   baseData['id'],
                          //   baseData['name'],
                          //   baseData['publicKey'],
                          //   baseData['relayServer'],
                          //   baseData['version'] ?? "2",
                          // );
                          return NavigationActionPolicy.CANCEL;
                        } catch (e) {
                          print("Erron from beacon $e");
                        }
                      }

                      return NavigationActionPolicy.ALLOW;
                    },
                    onLoadStop: (controller, url) async {
                      pullToRefreshController.endRefreshing();
                      this.controller.url.value = url.toString();
                      this.controller.setCanGoBackForward();
                    },
                    onLoadError: (controller, url, code, message) {
                      pullToRefreshController.endRefreshing();
                      this.controller.setCanGoBackForward();
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
                      this.controller.setCanGoBackForward();
                    },
                    onConsoleMessage: (controller, consoleMessage) {
                      print(consoleMessage);
                    },
                  ),
                )),
          ),
        ),
        Obx(
          () => controller.progress.value < 1.0
              ? LinearProgressIndicator(
                  value: controller.progress.value,
                  color: ColorConst.Primary,
                )
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
                                    controller.webViewController?.goForward();
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
    );
  }
}
