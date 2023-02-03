import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/custom_image_widget.dart';
import 'package:naan_wallet/app/modules/settings_page/enums/network_enum.dart';
import 'package:naan_wallet/app/modules/settings_page/widget/backup/backup_page.dart';
import 'package:naan_wallet/app/modules/settings_page/widget/connected_dapps_sheet.dart';
import 'package:naan_wallet/app/modules/settings_page/widget/flutter_switch.dart';
import 'package:naan_wallet/app/modules/settings_page/widget/manage_accounts_sheet.dart';
import 'package:naan_wallet/app/modules/settings_page/widget/old_wallet_recover/dismiss_recover_sheet.dart';
import 'package:naan_wallet/app/modules/settings_page/widget/old_wallet_recover/recover_account_sheet.dart';
import 'package:naan_wallet/app/modules/settings_page/widget/reset_wallet_sheet.dart';
import 'package:naan_wallet/app/modules/settings_page/widget/select_network_sheet.dart';
import 'package:naan_wallet/app/modules/settings_page/widget/select_node_sheet.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:share_plus/share_plus.dart';

import '../../home_page/controllers/home_page_controller.dart';
import '../controllers/settings_page_controller.dart';
import '../widget/change_passcode.dart';

class SettingsPageView extends GetView<SettingsPageController> {
  const SettingsPageView({super.key});
  static final _homePageController = Get.find<HomePageController>();
  @override
  Widget build(BuildContext context) {
    Get.put(SettingsPageController());
    return NaanBottomSheet(
        title: "Settings",
        height: .89.height,
        bottomSheetHorizontalPadding: 16.arP,
        bottomSheetWidgets: [
          SizedBox(
            height: 0.81.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                0.01.vspace,
                Expanded(
                  child: Obx(() {
                    return ListView(
                      physics: AppConstant.scrollPhysics,
                      children: [
                        // Obx(() => _homePageController.userAccounts.isEmpty
                        //     ? const SizedBox()
                        //     : _accountOption()),

                        _backupOption(),
                        _oldWalletBackupOption(),
                        if (_homePageController.userAccounts.isNotEmpty)
                          SizedBox(height: 0.05.width),
                        if (_homePageController.userAccounts.isNotEmpty)
                          _settingsSeparator(
                            title: "Security",
                            settings: [
                              if (!_homePageController.userAccounts
                                  .every((element) => element.isWatchOnly))
                                _settingOption(
                                  onTap: () {
                                    Get.bottomSheet(BackupPage(),
                                        isScrollControlled: true);
                                  },
                                  title: "Backup",
                                  svgPath:
                                      "${PathConst.SETTINGS_PAGE.SVG}backup.svg",
                                ),
                              if (controller.isPasscodeSet.value)
                                _settingOption(
                                  onTap: () =>
                                      Get.to(() => const ChangePasscode()),
                                  title: "Change passcode",
                                  svgPath:
                                      "${PathConst.SETTINGS_PAGE.SVG}passcode.svg",
                                ),
                              if (controller.supportBiometric.value)
                                _fingerPrintOption()
                            ],
                          ),
                        if (_homePageController.userAccounts.isNotEmpty)
                          SizedBox(height: 0.05.width),
                        if (_homePageController.userAccounts.isNotEmpty)
                          _connectedAppsOption(),
                        // SizedBox(height: 0.05.width),

                        SizedBox(height: 0.05.width),
                        _settingsSeparator(
                          title: "Others",
                          settings: [
                            _settingOption(
                              title: "Network",
                              svgPath: "${PathConst.SETTINGS_PAGE.SVG}node.svg",
                              onTap: () {
                                Get.bottomSheet(
                                  SelectNetworkBottomSheet(),
                                  enterBottomSheetDuration:
                                      const Duration(milliseconds: 180),
                                  exitBottomSheetDuration:
                                      const Duration(milliseconds: 150),
                                );
                              },
                              trailing: Row(
                                children: [
                                  Obx(
                                    () => Text(
                                      controller.networkType.value ==
                                              NetworkType.mainnet
                                          ? "Mainnet"
                                          : "Testnet",
                                      style: labelSmall.apply(
                                          color: ColorConst
                                              .NeutralVariant.shade60),
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    size: 14,
                                    color: ColorConst.NeutralVariant.shade60,
                                  )
                                ],
                              ),
                            ),
                            _settingOption(
                                title: "Node",
                                svgPath:
                                    "${PathConst.SETTINGS_PAGE.SVG}node.svg",
                                onTap: () {
                                  Get.bottomSheet(
                                    SelectNodeBottomSheet(),
                                    enterBottomSheetDuration:
                                        const Duration(milliseconds: 180),
                                    exitBottomSheetDuration:
                                        const Duration(milliseconds: 150),
                                    barrierColor: Colors.transparent,
                                    isScrollControlled: true,
                                  );
                                },
                                trailing: Row(
                                  children: [
                                    Obx(() => Text(
                                          controller.selectedNode.value.name ??
                                              "Default",
                                          style: labelSmall.apply(
                                              color: ColorConst
                                                  .NeutralVariant.shade60),
                                        )),
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      size: 14,
                                      color: ColorConst.NeutralVariant.shade60,
                                    )
                                  ],
                                )),
                          ],
                        ),
                        SizedBox(height: 0.05.width),
                        _settingsSeparator(
                          title: "About",
                          settings: [
                            _settingOption(
                              onTap: () => CommonFunctions.launchURL(
                                  "https://www.naan.app/privacy-policy"),
                              title: "Privacy Policy",
                              svgPath:
                                  "${PathConst.SETTINGS_PAGE.SVG}privacy.svg",
                            ),
                            _settingOption(
                              onTap: () => CommonFunctions.launchURL(
                                  "https://www.naan.app/terms"),
                              title: "Terms & Conditions",
                              svgPath:
                                  "${PathConst.SETTINGS_PAGE.SVG}terms.svg",
                            ),
                          ],
                        ),
                        SizedBox(height: 0.05.width),
                        _settingsSeparator(
                          title: "Social",
                          settings: [
                            _settingOption(
                              onTap: () => Share.share(
                                  "🔥🔥🔥 Hey friend! You need to check out naan - it's my favorite web3 app for all things Tezos. With naan, you can easily buy NFTs with your credit card, discover trusted web3 apps, and even explore the art collections of other collectors. Trust me, you won't be disappointed. Download it now at https://naan.app 🚀🚀🚀"),
                              title: "Share naan",
                              svgPath:
                                  "${PathConst.SETTINGS_PAGE.SVG}share_naan.svg",
                            ),
                            // if (controller.inAppReviewAvailable.value)
                            _settingOption(
                              onTap: () async {
                                // if (Platform.isAndroid) {
                                await controller.inAppReview
                                    .openStoreListing(appStoreId: "1573210354");
                                // } else {
                                //   await controller.inAppReview.requestReview();
                                // }
                                controller.inAppReviewAvailable.value =
                                    await controller.inAppReview.isAvailable();
                              },
                              title: "Rate naan",
                              svgPath: "${PathConst.SETTINGS_PAGE.SVG}star.svg",
                            ),
                            _settingOption(
                              onTap: (() => CommonFunctions.launchURL(
                                  "https://twitter.com/naan_app")),
                              title: "Follow us on Twitter",
                              svgPath:
                                  "${PathConst.SETTINGS_PAGE.SVG}twitter.svg",
                            ),
                            _settingOption(
                              onTap: () => CommonFunctions.launchURL(
                                  "https://discord.gg/wpcNRsBbxy"),
                              title: "Join our Discord",
                              svgPath:
                                  "${PathConst.SETTINGS_PAGE.SVG}discord.svg",
                            ),
                            _settingOption(
                              onTap: () => CommonFunctions.launchURL(
                                  "https://tally.so/r/w4aKgd"),
                              title: "Feedback & Support",
                              svgPath:
                                  "${PathConst.SETTINGS_PAGE.SVG}feedback.svg",
                            ),
                          ],
                        ),

                        SizedBox(height: 0.05.width),
                        _resetOption(),
                        SizedBox(height: 0.065.width),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ]);
  }

  Widget _settingsSeparator({required List<Widget> settings, required title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8)),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 0.05.width),
            itemBuilder: (_, index) => settings[index],
            separatorBuilder: (_, index) => Divider(
                height: 1,
                thickness: 1,
                color: ColorConst.NeutralVariant.shade30),
            itemCount: settings.length,
          ),
        ),
      ],
    );
  }

  Widget _settingOption({
    required String title,
    required String svgPath,
    GestureTapCallback? onTap,
    Widget? trailing,
  }) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: SizedBox(
        height: 54,
        child: Row(
          children: [
            SizedBox(
              width: 0.165.width,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: SvgPicture.asset(svgPath)),
            ),
            Text(
              title,
              style: labelMedium,
            ),
            const Spacer(),
            if (trailing != null) trailing
          ],
        ),
      ),
    );
  }

  Widget _fingerPrintOption() {
    return SizedBox(
      height: 54,
      child: Row(
        children: [
          SizedBox(
            width: 0.165.width,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Platform.isAndroid
                  ? SvgPicture.asset(
                      "${PathConst.SETTINGS_PAGE.SVG}fingerprint.svg")
                  : SvgPicture.asset(
                      "${PathConst.SVG}faceid.svg",
                      width: 25,
                      color: Colors.white,
                    ),
            ),
          ),
          Text(
            "Sign in with ${Platform.isAndroid ? "Biometrics" : "Face ID"}",
            style: labelMedium,
          ),
          const Spacer(),
          Obx(
            () => FlutterSwitch(
              value: controller.fingerprint.value,
              onToggle: (value) {
                controller.changeBiometricAuth(value);
              },
              height: 18,
              width: 32,
              padding: 2,
              toggleSize: 14,
              activeColor: ColorConst.Primary.shade50,
              activeToggleColor: ColorConst.Primary.shade90,
              inactiveColor: ColorConst.Neutral.shade0,
              inactiveToggleColor: ColorConst.NeutralVariant.shade40,
            ),
          )
        ],
      ),
    );
  }

  Widget _accountOption() {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          ManageAccountsBottomSheet(),
          enterBottomSheetDuration: const Duration(milliseconds: 180),
          exitBottomSheetDuration: const Duration(milliseconds: 150),
          isScrollControlled: true,
          barrierColor: ColorConst.Primary.withOpacity(0.2),
          enableDrag: true,
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8)),
        height: 71,
        padding: EdgeInsets.symmetric(horizontal: 0.05.width),
        child: Row(
          children: [
            SizedBox(
              width: 0.165.width,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomImageWidget(
                    imageType: _homePageController.userAccounts[0].imageType!,
                    imagePath:
                        _homePageController.userAccounts[0].profileImage!,
                    imageRadius: 23,
                  )),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 14,
                  child: Text(
                    "Default wallet",
                    style: labelSmall.apply(
                      color: ColorConst.NeutralVariant.shade60,
                    ),
                  ),
                ),
                SizedBox(
                  height: 27,
                  child: Center(
                    child: Text(
                      _homePageController.userAccounts[0].name ??
                          'Account Name',
                      style: labelMedium,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _connectedAppsOption() {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          ConnectedDappBottomSheet(),
          enterBottomSheetDuration: const Duration(milliseconds: 180),
          exitBottomSheetDuration: const Duration(milliseconds: 150),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8)),
        height: 54,
        padding: EdgeInsets.symmetric(horizontal: 0.05.width),
        child: Row(
          children: [
            SizedBox(
              width: 0.165.width,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: SvgPicture.asset(
                      "${PathConst.SETTINGS_PAGE.SVG}connected_apps.svg")),
            ),
            Text(
              "Connected apps",
              style: labelMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _resetOption() {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          const ResetWalletBottomSheet(),
          enterBottomSheetDuration: const Duration(milliseconds: 180),
          exitBottomSheetDuration: const Duration(milliseconds: 150),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8)),
        height: 54,
        padding: EdgeInsets.symmetric(horizontal: 0.05.width),
        child: Row(
          children: [
            Text(
              "Reset naan",
              style: labelMedium.apply(color: ColorConst.Error.shade60),
            ),
            const Spacer(),
            SvgPicture.asset("${PathConst.SETTINGS_PAGE.SVG}logout.svg")
          ],
        ),
      ),
    );
  }

  Widget _backupOption() {
    return Obx(
      () {
        if (_homePageController.userAccounts.isEmpty) return const SizedBox();

        final isBackedUp = controller.isWalletBackup.value;
        if (isBackedUp) return Container();
        return Container(
          decoration: BoxDecoration(
              color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.symmetric(
              horizontal: 0.05.width, vertical: 0.04.width),
          margin: EdgeInsets.only(
            top: 0.05.width,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    PathConst.SETTINGS_PAGE.SVG +
                        (isBackedUp
                            ? "backup_success.svg"
                            : "backup_warning.svg"),
                  ),
                  0.02.hspace,
                  Text(
                    isBackedUp
                        ? "Wallet successfully backed up"
                        : "Action required: not backed up",
                    style: labelMedium.apply(
                        color: isBackedUp
                            ? const Color(0xff44CD41)
                            : ColorConst.Tertiary),
                  )
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "If your device gets lost or stolen, or if there’s an unexpected hardware error, you will lose your funds",
                style: labelSmall.apply(
                  color: ColorConst.NeutralVariant.shade70,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              GestureDetector(
                onTap: () => controller.checkWalletBackup(),
                child: Text(
                  isBackedUp ? "View my recovery phrase" : "Backup now",
                  style: labelMedium.apply(
                      color: isBackedUp ? Colors.white : ColorConst.Tertiary),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _oldWalletBackupOption() {
    return Obx(
      () {
        // if (_homePageController.userAccounts.isEmpty) return const SizedBox();

        final isBackedUp = controller.oldWallets.isEmpty;
        if (isBackedUp) return Container();
        return Container(
          decoration: BoxDecoration(
              color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.symmetric(
              horizontal: 0.05.width, vertical: 0.04.width),
          margin: EdgeInsets.only(
            top: 0.05.width,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    "${PathConst.SETTINGS_PAGE.SVG}wallet.svg",
                  ),
                  0.02.hspace,
                  Text(
                    "Action required: old backup found",
                    style: labelMedium.apply(color: ColorConst.Tertiary),
                  )
                ],
              ),
              0.01.vspace,
              Text(
                "Restore your accounts from your backup and retrieve your valuable digital assets and collectables.",
                style: labelSmall.apply(
                  color: ColorConst.NeutralVariant.shade70,
                ),
              ),
              0.012.vspace,
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.bottomSheet(RecoverOldAccountSheet(),
                        isScrollControlled: true),
                    child: Text(
                      "Recover now",
                      style: labelMedium.apply(color: ColorConst.Tertiary),
                    ),
                  ),
                  0.064.hspace,
                  GestureDetector(
                    onTap: () => Get.bottomSheet(
                        DismissRecoverAccountBottomSheet(),
                        isScrollControlled: true),
                    child: Text(
                      "Dismiss",
                      style: labelMedium.apply(color: ColorConst.lightGrey),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
