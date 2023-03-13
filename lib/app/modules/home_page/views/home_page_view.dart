import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/text_scale_factor.dart';
import 'package:naan_wallet/utils/bottom_sheet_manager.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../controllers/home_page_controller.dart';
import '../widgets/home_app_bar_widget/home_app_bar_widget.dart';
import '../widgets/register_widgets.dart';

class HomePageView extends GetView<HomePageController> {
  HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    controller;

    return OverrideTextScaleFactor(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: CupertinoPageScaffold(
            child: SizedBox.expand(

                // decoration: BoxDecoration(
                //     color: controller.scale.value == 1.00
                //         ? Colors.black.withOpacity(controller.scale.value)
                //         : ColorConst.darkGrey,
                //     borderRadius: controller.scale.value == 1.00
                //         ? null
                //         : BorderRadius.circular(24.arP)),
                child: SafeArea(
              bottom: false,
              child: Stack(
                children: [
                  Column(
                    children: [
                      // SizedBox(height: 0.025.height),
                      Expanded(
                          child: ListView(
                        addAutomaticKeepAlives: true,
                        padding: EdgeInsets.only(
                          top: 100.arP,
                        ),
                        physics: AppConstant.scrollPhysics,
                        children: registeredWidgets,
                      )),
                    ],
                  ),

                  Container(
                      height: 100.arP,
                      width: 1.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.2, 0.7, 0.9],
                          colors: [
                            ColorConst.Primary.shade0,
                            ColorConst.Primary.shade0.withOpacity(0.5),
                            ColorConst.Primary.shade0.withOpacity(0.0),
                          ],
                        ),
                      )),
                  // ignore: prefer_const_constructors
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: const HomepageAppBar(),
                  ),
                ],
              ),
            )),
          )),
    );
  }
}
