import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/data/services/auth_service/auth_service.dart';
import 'package:plenty_wallet/app/data/services/service_models/account_model.dart';
import 'package:plenty_wallet/app/modules/common_widgets/back_button.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:plenty_wallet/app/modules/common_widgets/info_button.dart';
import 'package:plenty_wallet/app/modules/settings_page/controllers/backup_page_controller.dart';
import 'package:plenty_wallet/app/modules/settings_page/controllers/select_reveal_controller.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/common_functions.dart';
import 'package:plenty_wallet/utils/constants/constants.dart';
import 'package:plenty_wallet/utils/constants/path_const.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';
import 'package:screen_protector/screen_protector.dart';

import '../../../common_widgets/info_bottom_sheet.dart';
import 'private_key_page.dart';
import 'secret_phrase_page.dart';

class SelectToRevealKeyBottomSheet extends StatefulWidget {
  final AccountModel accountModel;
  final String? prevPage;
  const SelectToRevealKeyBottomSheet(
      {super.key, required this.accountModel, this.prevPage});

  @override
  State<SelectToRevealKeyBottomSheet> createState() =>
      _SelectToRevealKeyBottomSheetState();
}

class _SelectToRevealKeyBottomSheetState
    extends State<SelectToRevealKeyBottomSheet> {
  late final _controller =
      Get.put(SelectRevealController(widget.accountModel.publicKeyHash!));

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      prevPageName: widget.prevPage,
      // isScrollControlled: true,
      title: widget.accountModel.name ?? "",
      leading: backButton(
          ontap: () {
            Navigator.pop(context);
          },
          lastPageName: widget.prevPage),
      height: AppConstant.naanBottomSheetChildHeight,
      // bottomSheetHorizontalPadding: 24,
      bottomSheetWidgets: [
        Column(
          children: [
            0.04.vspace,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: InfoButton(
                      onPressed: () => CommonFunctions.bottomSheet(
                          InfoBottomSheet(),
                          fullscreen: true)),
                ),
              ],
            ),
            0.048.vspace,
            Center(
              child: SvgPicture.asset(
                "${PathConst.SETTINGS_PAGE.SVG}backup_success.svg",
                color: ColorConst.Primary,
                height: 90.arP,
              ),
            ),
            0.048.arP.vspace,
            Center(
              child: Text(
                "Your wallet is backed up".tr,
                style: titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
            0.012.arP.vspace,
            Text(
              "Dont’t risk your money! Backup your\nwallet so you can recover it if you lose\nthis device."
                  .tr,
              style: bodySmall.copyWith(color: ColorConst.textGrey1),
              textAlign: TextAlign.center,
            ),
            0.04.vspace,
            Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (_controller.seedPhraseReveal.value)
                    revealOptionMethod(
                        icon: '${PathConst.SETTINGS_PAGE}svg/secret_phrase.svg',
                        child: Text(
                          "View secret phrase".tr,
                          style: labelMedium,
                        ),
                        onTap: () async {
                          if (!(await AuthService()
                              .verifyBiometricOrPassCodeDirect())) {
                            return;
                          }

                          // controller.timer;
                          final controller = Get.put(BackupPageController());
                          await ScreenProtector.preventScreenshotOn();
                          await ScreenProtector.protectDataLeakageOn();
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SecretPhrasePage(
                                        prevPage:
                                            widget.accountModel.name ?? "",
                                        pkHash:
                                            widget.accountModel.publicKeyHash!,
                                      ))).then((value) async {
                            try {
                              await ScreenProtector.preventScreenshotOff();
                              await ScreenProtector.protectDataLeakageOff();
                              controller.dispose();
                            } catch (e) {}
                          });
                          // CommonFunctions.bottomSheet(
                          //   SecretPhrasePage(
                          //     pkHash: widget.accountModel.publicKeyHash!,
                          //   ),
                          // ).then((_) => controller.timer.cancel());
                        }),
                  0.02.vspace,
                  if (_controller.privateKeyReveal.value)
                    revealOptionMethod(
                        icon: '${PathConst.SETTINGS_PAGE}svg/key.svg',
                        child: Text(
                          "View private key".tr,
                          style: labelMedium,
                        ),
                        onTap: () async {
                          if (!(await AuthService()
                              .verifyBiometricOrPassCodeDirect())) {
                            return;
                          }

                          // controller.timer;

                          final controller = Get.put(BackupPageController());
                          await ScreenProtector.preventScreenshotOn();
                          await ScreenProtector.protectDataLeakageOn();
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PrivateKeyPage(
                                        prevPage:
                                            widget.accountModel.name ?? "",
                                        pkh: widget.accountModel.publicKeyHash!,
                                      ))).then((value) async {
                            try {
                              await ScreenProtector.preventScreenshotOff();
                              await ScreenProtector.protectDataLeakageOff();
                              controller.dispose();
                            } catch (e) {}
                          });
                          // CommonFunctions.bottomSheet(
                          // PrivateKeyPage(
                          //   pkh: widget.accountModel.publicKeyHash!,
                          // ),
                          // ).then((_) => controller.timer.cancel());
                        }),
                  // revealOptionMethod(
                  //     child: Text(
                  //       "Private Key",
                  //       style: labelMedium,
                  //     ),
                  //     onTap: () {
                  //       controller.timer;
                  //       Get.to(() => PrivateKeyPage(
                  //             pkh: accountModel.publicKeyHash!,
                  //           ))?.whenComplete(() => controller.timer.cancel());
                  //     }),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget revealOptionMethod(
      {Widget? child, GestureTapCallback? onTap, String? icon}) {
    return BouncingWidget(
      onPressed: onTap,
      child: Container(
        width: 0.65.width,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 16.arP, horizontal: 24.arP),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              icon ?? "",
              fit: BoxFit.fill,
              height: 25.arP,
            ),
            SizedBox(
              width: 15.arP,
            ),
            Center(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
