import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/dapp_models.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/dapp_browser/views/dapp_browser_view.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:url_launcher/url_launcher_string.dart';

// ignore: must_be_immutable
class DappBottomSheet extends StatelessWidget {
  DappModel dappModel;
  DappBottomSheet({Key? key, required this.dappModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
      child: ClipRRect(
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
                    Positioned(
                      top: 30.arP,
                      left: 14.arP,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 18.arP,
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 5.arP,
                        width: 36.arP,
                        margin: EdgeInsets.only(
                          top: 5.arP,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color(0xffEBEBF5).withOpacity(0.3),
                        ),
                      ),
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
                    width: 326.arP,
                    height: 50.arP,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/dapps/launch.svg',
                          height: 20.arP,
                          width: 20.arP,
                        ),
                        SizedBox(
                          width: 10.arP,
                        ),
                        Text(
                          'Launch App',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.arP,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.1.arP,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () => Get.bottomSheet(
                      const DappBrowserView(),
                      barrierColor: Colors.white.withOpacity(0.09),
                      settings: RouteSettings(
                        arguments: dappModel.url,
                      ),
                      isScrollControlled: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getSocialButton(String image, String url) {
    return GestureDetector(
      onTap: () => launchUrlString(url, mode: LaunchMode.externalApplication),
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