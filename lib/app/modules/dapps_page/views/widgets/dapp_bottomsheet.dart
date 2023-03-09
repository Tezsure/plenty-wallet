import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/dapp_models.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/dapp_browser/views/dapp_browser_view.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:url_launcher/url_launcher_string.dart';

// ignore: must_be_immutable
class DappBottomSheet extends StatelessWidget {
  DappModel dappModel;
  DappBottomSheet({Key? key, required this.dappModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(18.arP),
        topRight: Radius.circular(18.arP),
      ),
      child: Container(
        height: 0.75.height,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.arP),
            topRight: Radius.circular(18.arP),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image
            SizedBox(
              height: 0.3.height,
              child: Stack(
                children: [
                  // image
                  dappModel.backgroundImage!.endsWith('.svg')
                      ? Image.asset(
                          "${ServiceConfig.naanApis}/images/${dappModel.backgroundImage!}",
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                      : Image.network(
                          "${ServiceConfig.naanApis}/images/${dappModel.backgroundImage!}",
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),

                  // back
                  // Positioned(
                  //   top: 30.arP,
                  //   left: 14.arP,
                  //   child: GestureDetector(
                  //     onTap: () => Navigator.pop(context),
                  //     child: Icon(
                  //       Icons.arrow_back_ios_new_rounded,
                  //       color: Colors.white,
                  //       size: 18.arP,
                  //     ),
                  //   ),
                  // ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 40.arP,
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: EdgeInsets.only(top: 0.01.height),
                          height: 5.arP,
                          width: 36.arP,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.arP),
                            color: ColorConst.NeutralVariant.shade60
                                .withOpacity(0.3),
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: 16.arP, top: 0.02.height),
                            child: closeButton(),
                          ))
                    ],
                  ),
                ],
              ),
            ),

            // name
            Container(
              margin: EdgeInsets.only(
                top: 29.arP,
                left: 16.arP,
              ),
              child: Text(
                dappModel.name!,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.arP,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // description
            Container(
              margin: EdgeInsets.only(
                top: 12.arP,
                left: 16.arP,
                right: 16.arP,
              ),
              child: Text(
                dappModel.description!,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.arP,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            // social buttons in row for discord, twitter and telegram
            Container(
              margin: EdgeInsets.only(
                top: 20.arP,
                left: 16.arP,
                right: 16.arP,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // discord if available
                  if (dappModel.discord != null &&
                      dappModel.discord!.isNotEmpty)
                    Row(
                      children: [
                        _getSocialButton(
                            'assets/dapps/discord.svg', dappModel.discord!),
                        SizedBox(
                          width: 12.arP,
                        ),
                      ],
                    ),

                  // twitter if available
                  if (dappModel.twitter != null &&
                      dappModel.twitter!.isNotEmpty)
                    Row(
                      children: [
                        _getSocialButton(
                            'assets/dapps/twitter.svg', dappModel.twitter!),
                        SizedBox(
                          width: 12.arP,
                        ),
                      ],
                    ),

                  // telegram if available
                  if (dappModel.telegram != null &&
                      dappModel.telegram!.isNotEmpty)
                    _getSocialButton(
                        'assets/dapps/telegram.svg', dappModel.telegram!),
                ],
              ),
            ),
            Expanded(child: Container()),

            // launch button
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(
                  bottom: 40.arP,
                ),
                child: SolidButton(
                    // title: 'Launch',
                    width: 1.width - 64.arP,
                    height: 50.arP,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Launch'.tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.arP,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.1.arP,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      Get.back();
                      CommonFunctions.bottomSheet(
                        const DappBrowserView(),
                        settings: RouteSettings(
                          arguments: dappModel.url,
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getSocialButton(String image, String url) {
    return BouncingWidget(
      onPressed: () =>
          launchUrlString(url, mode: LaunchMode.externalApplication),
      child: Container(
        height: 40.arP,
        width: 64.arP,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.arP),
          border: Border.all(
            color: const Color(0xff4A454E),
            width: 1.arP,
          ),
          color: const Color(0xff1E1C1F),
        ),
        child: Center(
          child: SvgPicture.asset(
            image,
            height: 20.arP,
            width: 20.arP,
          ),
        ),
      ),
    );
  }
}
