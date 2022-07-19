import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/register_widgets.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../controllers/home_page_controller.dart';

class HomePageView extends GetView<HomePageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 1.width,
        decoration: BoxDecoration(
          gradient: background,
        ),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Stack(
            children: [
              //background gradient color
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: background,
                  ),
                ),
              ),
              Column(
                children: [
                  (MediaQuery.of(context).padding.top + 20)
                      .vspace, //notification bar padding + 20

                  appBar(),

                  32.vspace, //header spacing

                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24),
                    child: Wrap(
                      runSpacing: 28,
                      spacing: 20,
                      children: registeredWidgets,
                    ),
                  ),
                  28.vspace,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// App Bar for Home Page
  Widget appBar() => Container(
        height: 34,
        padding: const EdgeInsets.symmetric(
            horizontal:
                35), // 24 + 11 = 35.24 is Foundation padding and 11 is internal widget padding
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/home_page/scanner.png",
              height: 25,
            ),
            Container(
              height: 34,
              width: 34,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
}
