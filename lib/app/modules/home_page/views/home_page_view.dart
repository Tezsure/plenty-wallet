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
                  color: ColorConst.Primary,
                  child: SafeArea(
                    bottom: false,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            const HomepageAppBar(),
                            AccountValueWidget(),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 83),
                          child: SizedBox(
                            height: 1.height,
                            width: 1.width,
                            child: DraggableScrollableSheet(
                              initialChildSize: 0.6,
                              maxChildSize: 1,
                              minChildSize: 0.6,
                              snap: true,
                              builder: (_, scrollController) => Container(
                                decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(12))),
                                child: Column(
                                  children: [
                                    0.01.vspace,
                                    Container(
                                      height: 5,
                                      width: 36,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: ColorConst.NeutralVariant.shade60
                                            .withOpacity(0.3),
                                      ),
                                    ),
                                    0.02.vspace,
                                    Expanded(
                                      child: SingleChildScrollView(
                                        controller: scrollController,
                                        child: Wrap(
                                          alignment: WrapAlignment.center,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          runAlignment: WrapAlignment.center,
                                          runSpacing: 28,
                                          spacing: 10,
                                          children: registeredWidgets,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
