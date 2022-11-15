import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../controllers/home_page_controller.dart';
import '../widgets/account_value_widget/account_value_widget.dart';
import '../widgets/home_app_bar_widget/home_app_bar_widget.dart';
import '../widgets/register_widgets.dart';

class HomePageView extends GetView<HomePageController>
    with WidgetsBindingObserver {
  const HomePageView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller;
    return Stack(
      children: [
        AnnotatedRegion(
          value: SystemUiOverlayStyle(
            systemNavigationBarColor: ColorConst.Primary.shade0,
          ),
          child: Scaffold(
              body: Container(
                  width: 1.width,
                  color: Colors.black,
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      children: [
                        const HomepageAppBar(),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              runAlignment: WrapAlignment.center,
                              runSpacing: 28,
                              spacing: 22,
                              children: registeredWidgets,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))),
        ),
        // Obx(() => Visibility(
        //       visible: controller.startAnimation.value,
        //       child: Stack(
        //         children: [
        //           Container(
        //             height: 1.height,
        //             width: 1.width,
        //             color: Colors.black,
        //           ),
        //           Align(
        //             alignment: Alignment.center,
        //             child: LottieBuilder.asset(
        //               'assets/create_wallet/lottie/wallet_success.json',
        //               fit: BoxFit.contain,
        //               height: 0.5.height,
        //               width: 0.5.width,
        //               frameRate: FrameRate(60),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ))
      ],
    );
  }
}
