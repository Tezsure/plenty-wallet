import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:rive/rive.dart';

import '../controllers/settings_page_controller.dart';

class SettingsPageView extends GetView<SettingsPageController> {
  const SettingsPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: GradConst.GradientBackground),
      width: 1.width,
      height: 1.height,
      padding: EdgeInsets.symmetric(horizontal: 0.05.width),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          0.045.vspace,
          backButton(),
          0.065.vspace,
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(
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
                        title: "Change passcode",
                        svgPath: PathConst.SETTINGS_PAGE.SVG+ "passcode.svg",
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
                        svgPath: PathConst.SETTINGS_PAGE.SVG+ "share_naan.svg",
                      ),
                      settingOption(
                        title: "Follow us on Twitter",
                        svgPath: PathConst.SETTINGS_PAGE.SVG+ "twitter.svg",
                      ),
                      settingOption(
                        title: "Join our Discord",
                        svgPath: PathConst.SETTINGS_PAGE.SVG+ "discord.svg",
                      ),
                      settingOption(
                        title: "Feedback & Support",
                        svgPath: PathConst.SETTINGS_PAGE.SVG+ "feedback.svg",
                      ),
                    ],
                  ),
                  SizedBox(height: 0.05.width),
                  settingsSeparator(
                    title: "About",
                    settings: [
                      settingOption(
                        title: "Privacy Policy",
                        svgPath: PathConst.SETTINGS_PAGE.SVG + "privacy.svg",
                      ),
                      settingOption(
                        title: "Terms & Condition",
                        svgPath: PathConst.SETTINGS_PAGE.SVG+ "terms.svg",
                      ),
                    ],
                  ),
                  SizedBox(height: 0.05.width),
                  settingsSeparator(
                    title: "Others",
                    settings: [
                      settingOption(
                        title: "Change Network",
                        svgPath: PathConst.SETTINGS_PAGE.SVG+ "node.svg",
                      ),
                      settingOption(
                        title: "Node Selector",
                        svgPath: PathConst.SETTINGS_PAGE.SVG+ "node.svg",
                      ),
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
    );
  }

  Widget settingsSeparator({required List<Widget> settings, required title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text(
            title,
            style: labelLarge,
          ),
        ),
        SizedBox(
          height: 14,
        ),
        Container(
          decoration: BoxDecoration(
              color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8)),
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
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
            )
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
                  PathConst.SETTINGS_PAGE.SVG+ "fingerprint.svg"),
            ),
          ),
          Text(
            "Sign in with Fingerprint",
            style: labelMedium,
          ),
          Spacer(),
          // SizedBox(
          //   child: Transform.scale(
          //     scale: 0.8,
          //     child: CupertinoSwitch(
          //       trackColor: ColorConst.Neutral.shade0,
          //       thumbColor: controller.fingerprint.value
          //           ? Color.fromARGB(255, 255, 255, 255)
          //           : ColorConst.NeutralVariant.shade40,
          //       activeColor: ColorConst.Primary.shade50,
          //       value: controller.fingerprint.value,
          //       onChanged: (value) => controller.switchFingerprint(value),
          //     ),
          //   ),
          // ),
          SizedBox(
            width: 32,
            height: 18,
            child: RiveAnimation.asset(
              PathConst.SETTINGS_PAGE.RIVE+ "switch.riv",
              fit: BoxFit.scaleDown,
            ),
          )
        ],
      ),
    );
  }

  Widget accountOption() {
    return Container(
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
              child: CircleAvatar(
                  radius: 23,
                  backgroundColor: ColorConst.NeutralVariant.shade40),
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
                    "Account Name",
                    style: labelMedium,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget connectedAppsOption() {
    return Container(
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
                    PathConst.SETTINGS_PAGE.SVG+ "connected_apps.svg")),
          ),
          Text(
            "Connected Applications",
            style: labelMedium,
          ),
        ],
      ),
    );
  }

  Widget resetOption() {
    return Container(
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
          Spacer(),
          SvgPicture.asset(PathConst.SETTINGS_PAGE.SVG+ "logout.svg")
        ],
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
                  PathConst.SETTINGS_PAGE.SVG+
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
                          ? Color(0xff44CD41)
                          : ColorConst.Tertiary),
                )
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              "If your device gets lost or stolen, or if there’s an unexpected hardware error, you will lose your funds",
              style: labelSmall.apply(
                color: ColorConst.NeutralVariant.shade70,
              ),
            ),
            SizedBox(
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
