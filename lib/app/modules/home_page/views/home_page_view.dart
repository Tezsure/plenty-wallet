import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/register_widgets.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../utils/material_Tap.dart';
import '../../../../utils/styles/styles.dart';
import '../../../routes/app_pages.dart';
import '../../common_widgets/solid_button.dart';
import '../controllers/home_page_controller.dart';

class HomePageView extends GetView<HomePageController>
    with WidgetsBindingObserver {
  const HomePageView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (Get.arguments != null) {
        var showBottomSheet = Get.arguments[0] ?? false;
        Get.bottomSheet(
          NaanBottomSheet(
            gradientStartingOpacity: 1,
            blurRadius: 5,
            title: 'Backup Your Wallet',
            bottomSheetWidgets: [
              Text(
                'With no backup. losing your device will result\nin the loss of access forever. The only way to\nguard against losses is to backup your wallet.',
                textAlign: TextAlign.start,
                style: bodySmall.copyWith(
                    color: ColorConst.NeutralVariant.shade60),
              ),
              30.vspace,
              SolidButton(
                  textColor: ColorConst.Neutral.shade95,
                  title: "Backup Wallet ( ~1 min )",
                  onPressed: () => Get.toNamed(Routes.BACKUP_WALLET)),
              12.vspace,
              materialTap(
                inkwellRadius: 8,
                onPressed: () => Get.back(),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: ColorConst.Neutral.shade80,
                      width: 1.50,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text("I will risk it",
                      style:
                          titleSmall.apply(color: ColorConst.Primary.shade80)),
                ),
              ),
            ],
          ),
          enableDrag: true,
          isDismissible: true,
        );
      }
    });

    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
          systemNavigationBarColor: ColorConst.Neutral),
      child: Scaffold(
        body: Container(
          width: 1.width,
          height: 1.height,
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
      ),
    );
  }

  /// App Bar for Home Page
  Widget appBar() => Container(
        height: 34,
        padding: const EdgeInsets.symmetric(
            horizontal:
                35), // 24 + 11 = 35. 24 is Foundation padding and 11 is internal widget padding
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
