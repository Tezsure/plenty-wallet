import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/copy_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/info_bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/info_button.dart';
import 'package:naan_wallet/app/modules/settings_page/controllers/backup_page_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../../../../data/services/user_storage_service/user_storage_service.dart';
import '../../controllers/settings_page_controller.dart';

class PrivateKeyPage extends StatefulWidget {
  static final _settingsController = Get.find<SettingsPageController>();
  static final _backupController = Get.find<BackupPageController>();
  final String pkh;
  const PrivateKeyPage({super.key, required this.pkh});

  @override
  State<PrivateKeyPage> createState() => _PrivateKeyPageState();
}

class _PrivateKeyPageState extends State<PrivateKeyPage> {
  @override
  void dispose() {
    if (PrivateKeyPage._backupController.timer.isActive) {
      PrivateKeyPage._backupController.timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PrivateKeyPage._backupController.setup();
    NaanAnalytics.logEvent(NaanAnalyticsEvents.VIEW_PRIVATE_KEY,
        param: {NaanAnalytics.address: widget.pkh});
    return SafeArea(
      bottom: false,
      top: true,
      child: NaanBottomSheet(
          bottomSheetHorizontalPadding: 16.arP,
          height: 0.9.height,
          bottomSheetWidgets: [
            FutureBuilder<AccountSecretModel?>(
                future: UserStorageService().readAccountSecrets(widget.pkh),
                builder: (context, snapshotData) {
                  if (snapshotData.hasData) {
                    return Container(
                      height: 0.85.height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              backButton(),
                              InfoButton(
                                onPressed: () => CommonFunctions.bottomSheet(
                                  const InfoBottomSheet(),
                                 
                                ),
                              ),
                            ],
                          ),
                          0.045.vspace,
                          Text(
                            'Your private key',
                            style: titleLarge,
                          ),
                          0.012.vspace,
                          Text(
                            'Your private key can be used to\naccess all of your funds so do not\nshare with anyone',
                            textAlign: TextAlign.center,
                            style: bodySmall.copyWith(
                                color: ColorConst.NeutralVariant.shade60),
                          ),
                          0.03.vspace,
                          Obx(() => CopyButton(
                              isCopied: PrivateKeyPage
                                  ._settingsController.copyToClipboard.value,
                              onPressed: () => PrivateKeyPage
                                  ._settingsController
                                  .paste(snapshotData.data!.secretKey
                                      ?.toString()))),
                          0.03.vspace,
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 34),
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: ColorConst.NeutralVariant.shade60,
                                    width: 2),
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(
                              snapshotData.data!.secretKey!,
                              style: bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const Spacer(),
                          Obx(() {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'This screen will auto close in ',
                                  textAlign: TextAlign.center,
                                  style: labelSmall.copyWith(
                                      color: ColorConst.NeutralVariant.shade60),
                                ),
                                Text(
                                  '${PrivateKeyPage._backupController.timeLeft.value} seconds',
                                  textAlign: TextAlign.center,
                                  style: labelSmall,
                                )
                              ],
                            );
                          }),
                          0.075.vspace
                        ],
                      ),
                    );
                  } else {
                    return const Center(child: CupertinoActivityIndicator(
                            color: ColorConst.Primary,
                          ));
                  }
                }),
          ]),
    );
  }
}
