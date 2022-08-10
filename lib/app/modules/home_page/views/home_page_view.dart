import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/account_value_widget/account_value_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/home_app_bar_widget/home_app_bar_widget.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../utils/styles/styles.dart';
import '../../../routes/app_pages.dart';
import '../../common_widgets/bottom_sheet.dart';
import '../../common_widgets/solid_button.dart';
import '../controllers/home_page_controller.dart';
import '../widgets/register_widgets.dart';

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
        showBottomSheet
            ? Get.bottomSheet(
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
                    .03.vspace,
                    SolidButton(
                        textColor: ColorConst.Neutral.shade95,
                        title: "Backup Wallet ( ~1 min )",
                        onPressed: () => Get.toNamed(Routes.BACKUP_WALLET)),
                    0.012.vspace,
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.zero,
                      onPressed: () => Get.back(),
                      child: Container(
                        height: 48,
                        width: 1.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: ColorConst.Neutral.shade80,
                            width: 1.50,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text("I will risk it",
                            style: titleSmall.apply(
                                color: ColorConst.Primary.shade80)),
                      ),
                    ),
                  ],
                ),
                enableDrag: true,
                isDismissible: true,
                ignoreSafeArea: false,
              )
            : Container();
      }
    });
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: ColorConst.Primary.shade0,
      ),
      child: Scaffold(
          body: Container(
              width: 1.width,
              color: ColorConst.Primary,
              child: SafeArea(
                child: Stack(
                  children: [
                    Column(
                      children: const [
                        HomepageAppBar(),
                        AccountValueWidget(),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 93),
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
                                    top: Radius.circular(8))),
                            child: Column(
                              children: [
                                0.005.vspace,
                                Container(
                                  height: 5,
                                  width: 36,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: ColorConst.NeutralVariant.shade60
                                        .withOpacity(0.3),
                                  ),
                                ),
                                0.025.vspace,
                                Expanded(
                                  child: SingleChildScrollView(
                                    controller: scrollController,
                                    child: Wrap(
                                      alignment: WrapAlignment.center,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      runAlignment: WrapAlignment.center,
                                      runSpacing: 28,
                                      spacing: 20,
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
    );
  }
}
