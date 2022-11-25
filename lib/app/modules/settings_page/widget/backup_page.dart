import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/settings_page/controllers/backup_page_controller.dart';
import 'package:naan_wallet/app/modules/settings_page/widget/private_key_page.dart';
import 'package:naan_wallet/app/modules/settings_page/widget/secret_phrase_page.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

import '../../../data/services/enums/enums.dart';
import '../../home_page/controllers/home_page_controller.dart';

class BackupPage extends StatelessWidget {
  BackupPage({super.key});

  final controller = Get.put(BackupPageController());
  static final _homePageController = Get.find<HomePageController>();

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 1.height,
        width: 1.width,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: const BoxDecoration(gradient: GradConst.GradientBackground),
        child: SafeArea(
          child: Column(
            children: [
              0.015.vspace,
              Stack(
                children: [
                  Container(
                    height: 0.09.width,
                    width: 1.width,
                    alignment: Alignment.center,
                    child: Text(
                      "Backup",
                      maxLines: 1,
                      style: titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  backButton(),
                ],
              ),
              0.03.vspace,
              Expanded(
                  child: Obx(
                () => ListView.builder(
                  itemBuilder: (context, index) => accountMethod(
                    _homePageController.userAccounts[index],
                  ),
                  itemCount: _homePageController.userAccounts.length,
                ),
              ))
            ],
          ),
        ));
  }

  Widget accountMethod(AccountModel accountModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        height: 44,
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor:
                  ColorConst.NeutralVariant.shade60.withOpacity(0.2),
              child: Container(
                alignment: Alignment.bottomRight,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image:
                        accountModel.imageType == AccountProfileImageType.assets
                            ? AssetImage(accountModel.profileImage!)
                            : FileImage(
                                File(accountModel.profileImage!),
                              ) as ImageProvider,
                  ),
                ),
              ),
            ),
            0.04.hspace,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  accountModel.name!,
                  style: bodySmall,
                ),
                Text(
                  tz1Shortner(accountModel.accountSecretModel?.publicKey ??
                      'nxkjfbhedvzbv'),
                  style: labelSmall.apply(
                      color: ColorConst.NeutralVariant.shade60),
                ),
              ],
            ),
            const Spacer(),
            GestureDetector(
                onTap: () {
                  Get.bottomSheet(
                    barrierColor: Colors.transparent,
                    enterBottomSheetDuration: const Duration(milliseconds: 180),
                    exitBottomSheetDuration: const Duration(milliseconds: 150),
                    revealBottomSheet(accountModel),
                  );
                },
                child: revealButtonUI())
          ],
        ),
      ),
    );
  }

  NaanBottomSheet revealBottomSheet(AccountModel accountModel) {
    return NaanBottomSheet(
      blurRadius: 5,
      height: 260,
      bottomSheetHorizontalPadding: 30,
      bottomSheetWidgets: [
        Center(
          child: Text(
            "Select what you want to reveal",
            style: labelMedium,
            textAlign: TextAlign.center,
          ),
        ),
        0.03.vspace,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
          ),
          child: Column(
            children: [
              revealOptionMethod(
                  child: Text(
                    "Secret Phrase",
                    style: labelMedium,
                  ),
                  onTap: () {
                    controller.timer;
                    Get.to(() => SecretPhrasePage(
                          pkHash: accountModel.publicKeyHash!,
                        ))?.whenComplete(() => controller.timer.cancel());
                  }),
              const Divider(
                color: Color(0xff4a454e),
                height: 1,
                thickness: 1,
              ),
              revealOptionMethod(
                  child: Text(
                    "Private Key",
                    style: labelMedium,
                  ),
                  onTap: () {
                    controller.timer;
                    Get.to(() => PrivateKeyPage(
                          pkh: accountModel.publicKeyHash!,
                        ))?.whenComplete(() => controller.timer.cancel());
                  }),
              const Divider(
                color: Color(0xff4a454e),
                height: 1,
                thickness: 1,
              ),
              revealOptionMethod(
                  child: Text(
                    "Cancel",
                    style: labelMedium,
                  ),
                  onTap: Get.back),
            ],
          ),
        ),
      ],
    );
  }

  InkWell revealOptionMethod({Widget? child, GestureTapCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: Center(
          child: child,
        ),
      ),
    );
  }

  Container revealButtonUI() {
    return Container(
      height: 24,
      width: 74,
      decoration: BoxDecoration(
          color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Reveal",
            style: labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
          ),
          Icon(Icons.chevron_right_rounded,
              size: 10, color: ColorConst.NeutralVariant.shade60)
        ],
      ),
    );
  }
}
