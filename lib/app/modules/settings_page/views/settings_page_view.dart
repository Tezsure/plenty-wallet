import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/app/modules/settings_page/enums/network_enum.dart';
import 'package:naan_wallet/app/modules/settings_page/widget/backup_page.dart';
import 'package:naan_wallet/app/modules/settings_page/widget/connected_dapps_sheet.dart';
import 'package:naan_wallet/app/modules/settings_page/widget/flutter_switch.dart';
import 'package:naan_wallet/app/modules/settings_page/widget/manage_accounts_sheet.dart';
import 'package:naan_wallet/app/modules/settings_page/widget/reset_wallet_sheet.dart';
import 'package:naan_wallet/app/modules/settings_page/widget/select_network_sheet.dart';
import 'package:naan_wallet/app/modules/settings_page/widget/select_node_sheet.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../../../data/services/enums/enums.dart';
import '../../home_page/controllers/home_page_controller.dart';
import '../controllers/settings_page_controller.dart';

class SettingsPageView extends GetView<SettingsPageController> {
  const SettingsPageView({super.key});
  static final _homePageController = Get.find<HomePageController>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Material(
        child: Container(
          decoration:
              const BoxDecoration(gradient: GradConst.GradientBackground),
          width: 1.width,
          height: 1.height,
          padding: EdgeInsets.symmetric(horizontal: 0.05.width),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              0.045.vspace,
              Stack(
                children: [
                  Container(
                    height: 0.09.width,
                    width: 1.width,
                    alignment: Alignment.center,
                    child: Text(
                      "Settings",
                      maxLines: 1,
                      style: titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  backButton(),
                ],
              ),
              0.065.vspace,
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: Column(
                    children: [
                      accountOption(),
                      SizedBox(height: 0.05.width),
                      connectedAppsOption(),
                      SizedBox(height: 0.05.width),
                      settingsSeparator(
                        title: "Security",
                        settings: [
                          settingOption(
                            onTap: () {
                              Get.to(
                                () => BackupPage(),
                              );
                            },
                            title: "Backup",
                            svgPath: "${PathConst.SETTINGS_PAGE.SVG}backup.svg",
                          ),
                          settingOption(
                            onTap: () => Get.to(() => const ChangePasscode()),
                            title: "Change passcode",
                            svgPath:
                                "${PathConst.SETTINGS_PAGE.SVG}passcode.svg",
                          ),
                          fingerPrintOption()
                        ],
                      ),
                      SizedBox(height: 0.05.width),
                      backupOption(),
                      SizedBox(height: 0.05.width),
                      settingsSeparator(
                        title: "Social",
                        settings: [
                          settingOption(
                            title: "Share Naan",
                            svgPath:
                                "${PathConst.SETTINGS_PAGE.SVG}share_naan.svg",
                          ),
                          settingOption(
                            title: "Follow us on Twitter",
                            svgPath:
                                "${PathConst.SETTINGS_PAGE.SVG}twitter.svg",
                          ),
                          settingOption(
                            title: "Join our Discord",
                            svgPath:
                                "${PathConst.SETTINGS_PAGE.SVG}discord.svg",
                          ),
                          settingOption(
                            title: "Feedback & Support",
                            svgPath:
                                "${PathConst.SETTINGS_PAGE.SVG}feedback.svg",
                          ),
                        ],
                      ),
                      SizedBox(height: 0.05.width),
                      settingsSeparator(
                        title: "About",
                        settings: [
                          settingOption(
                            title: "Privacy Policy",
                            svgPath:
                                "${PathConst.SETTINGS_PAGE.SVG}privacy.svg",
                          ),
                          settingOption(
                            title: "Terms & Condition",
                            svgPath: "${PathConst.SETTINGS_PAGE.SVG}terms.svg",
                          ),
                        ],
                      ),
                      SizedBox(height: 0.05.width),
                      settingsSeparator(
                        title: "Others",
                        settings: [
                          settingOption(
                            title: "Change Network",
                            svgPath: "${PathConst.SETTINGS_PAGE.SVG}node.svg",
                            onTap: () {
                              Get.bottomSheet(SelectNetworkBottomSheet());
                            },
                            trailing: Row(
                              children: [
                                Obx(
                                  () => Text(
                                    controller.networkType.value ==
                                            NetworkType.mainNet
                                        ? "mainnet"
                                        : "testnet",
                                    style: labelSmall.apply(
                                        color:
                                            ColorConst.NeutralVariant.shade60),
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
                          settingOption(
                              title: "Node Selector",
                              svgPath: "${PathConst.SETTINGS_PAGE.SVG}node.svg",
                              onTap: () {
                                Get.bottomSheet(
                                  SelectNodeBottomSheet(),
                                  barrierColor: Colors.transparent,
                                  isScrollControlled: true,
                                );
                              },
                              trailing: Row(
                                children: [
                                  Obx(
                                    () => Text(
                                      controller.selectedNode.value.title,
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
                              )),
                        ],
                      ),
                      SizedBox(height: 0.05.width),
                      resetOption(),
                      SizedBox(height: 0.065.width),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget settingsSeparator({required List<Widget> settings, required title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            title,
            style: labelLarge,
          ),
        ),
        const SizedBox(
          height: 14,
        ),
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

  GestureDetector settingOption({
    required String title,
    required String svgPath,
    GestureTapCallback? onTap,
    Widget? trailing,
  }) {
    return GestureDetector(
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

  Widget fingerPrintOption() {
    return SizedBox(
      height: 54,
      child: Row(
        children: [
          SizedBox(
            width: 0.165.width,
            child: Align(
              alignment: Alignment.centerLeft,
              child: SvgPicture.asset(
                  "${PathConst.SETTINGS_PAGE.SVG}fingerprint.svg"),
            ),
          ),
          Text(
            "Sign in with Fingerprint",
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

  Widget accountOption() {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          const ManageAccountsBottomSheet(),
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
        child: Obx(() => Row(
              children: [
                SizedBox(
                  width: 0.165.width,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CircleAvatar(
                      radius: 23,
                      backgroundColor:
                          ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                      child: Container(
                        alignment: Alignment.bottomRight,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image:
                                _homePageController.userAccounts[0].imageType ==
                                        AccountProfileImageType.assets
                                    ? AssetImage(_homePageController
                                        .userAccounts[0].profileImage!)
                                    : FileImage(
                                        File(_homePageController
                                            .userAccounts[0].profileImage!),
                                      ) as ImageProvider,
                          ),
                        ),
                      ),
                    ),
                  ),
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
            )),
      ),
    );
  }

  Widget connectedAppsOption() {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(ConnectedDappBottomSheet());
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
              "Connected Applications",
              style: labelMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget resetOption() {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(const ResetWalletBottomSheet());
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
              "Reset Wallet",
              style: labelMedium.apply(color: ColorConst.Error.shade60),
            ),
            const Spacer(),
            SvgPicture.asset("${PathConst.SETTINGS_PAGE.SVG}logout.svg")
          ],
        ),
      ),
    );
  }

  Widget backupOption() {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
            color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8)),
        padding:
            EdgeInsets.symmetric(horizontal: 0.05.width, vertical: 0.04.width),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  PathConst.SETTINGS_PAGE.SVG +
                      (controller.backup.value
                          ? "backup_success.svg"
                          : "backup_warning.svg"),
                ),
                0.02.hspace,
                Text(
                  controller.backup.value
                      ? "Wallet successfully backed up"
                      : "Action required: not backed up",
                  style: labelMedium.apply(
                      color: controller.backup.value
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
              onTap: () => controller.switchbackup(),
              child: Text(
                controller.backup.value
                    ? "View my recovery phrase"
                    : "Backup now",
                style: labelMedium.apply(
                    color: controller.backup.value
                        ? Colors.white
                        : ColorConst.Tertiary),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ChangePasscode extends GetView<SettingsPageController> {
  const ChangePasscode({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: GradConst.GradientBackground),
        padding: const EdgeInsets.symmetric(horizontal: 21),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              0.02.vspace,
              Align(
                alignment: Alignment.centerLeft,
                child: backButton(),
              ),
              0.05.vspace,
              Center(
                child: SizedBox(
                  height: 0.27.width,
                  width: 0.27.width,
                  child: SvgPicture.asset(
                    "${PathConst.SVG}naan_logo.svg",
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              0.05.vspace,
              Obx(() => Text(
                    controller.verifyPassCode.value
                        ? "Set passcode"
                        : "Enter passcode",
                    textAlign: TextAlign.center,
                    style: titleMedium,
                  )),
              0.01.vspace,
              Text(
                "Protect your wallet by setting a passcode",
                style:
                    bodySmall.apply(color: ColorConst.NeutralVariant.shade60),
              ),
              0.05.vspace,
              AppPassCode(onChanged: (value) {
                if (value.length == 6) {
                  controller.changeAppPasscode(value);
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}

class AppPassCode extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  const AppPassCode({Key? key, this.onChanged}) : super(key: key);

  @override
  State<AppPassCode> createState() => _AppPassCode();
}

class _AppPassCode extends State<AppPassCode> {
  // String passCode = "";
  final _controller = Get.find<SettingsPageController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 0.45.width,
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                6,
                (index) => Container(
                  height: 22,
                  width: 22,
                  decoration: BoxDecoration(
                    color: _controller.enteredPassCode.value.length - 1 < index
                        ? Colors.transparent
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ),
          ),
        ),
        0.05.vspace,
        getKeyBoardWidget(),
      ],
    );
  }

  Widget getKeyBoardWidget() => Container(
        width: 0.7.width,
        alignment: Alignment.center,
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            for (var i = 1; i < 4; i++) getButton(i.toString()),
            for (var i = 4; i < 7; i++) getButton(i.toString()),
            for (var i = 7; i < 10; i++) getButton(i.toString()),
            getButton(
              '',
              true,
            ),
            getButton(
              '0',
            ),
            getButton('', false, Icons.backspace_outlined, () {
              if (_controller.enteredPassCode.value.isNotEmpty) {
                _controller.enteredPassCode.value = _controller
                    .enteredPassCode.value
                    .substring(0, _controller.enteredPassCode.value.length - 1);
                if (widget.onChanged != null) {
                  widget.onChanged!(_controller.enteredPassCode.value);
                }
              }
            })
          ],
        ),
      );

  Widget getButton(String value,
          [isDisable = false, IconData? iconData, onIconTap]) =>
      Padding(
        padding: EdgeInsets.only(
          left: 0.04.width,
          right: 0.04.width,
          bottom: 0.04.width,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(0.065.width),
          ),
          child: InkWell(
            borderRadius: BorderRadius.all(
              Radius.circular(0.065.width),
            ),
            highlightColor: ColorConst.NeutralVariant.shade60.withOpacity(0.4),
            splashFactory: NoSplash.splashFactory,
            onTap: iconData != null
                ? onIconTap
                : () {
                    if (_controller.enteredPassCode.value.length < 6) {
                      _controller.enteredPassCode.value =
                          _controller.enteredPassCode.value + value;
                      if (widget.onChanged != null) {
                        widget.onChanged!(_controller.enteredPassCode.value);
                      }
                    }
                  },
            child: Container(
              width: 0.13.width,
              height: 0.13.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(0.065.width),
                  ),
                  color: Colors.transparent),
              alignment: Alignment.center,
              child: isDisable
                  ? Container()
                  : iconData != null
                      ? Icon(
                          iconData,
                          color: ColorConst.NeutralVariant.shade60,
                          size: 18.sp,
                        )
                      : Text(
                          value,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0.sp,
                          ),
                        ),
            ),
          ),
        ),
      );
}
