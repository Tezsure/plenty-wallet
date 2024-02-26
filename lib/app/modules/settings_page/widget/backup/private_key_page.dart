import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';
import 'package:plenty_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:plenty_wallet/app/data/services/service_models/account_model.dart';
import 'package:plenty_wallet/app/modules/common_widgets/back_button.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:plenty_wallet/app/modules/common_widgets/copy_button.dart';
import 'package:plenty_wallet/app/modules/settings_page/controllers/backup_page_controller.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/constants/constants.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';

import '../../../../data/services/user_storage_service/user_storage_service.dart';
import '../../controllers/settings_page_controller.dart';

class PrivateKeyPage extends StatefulWidget {
  static final _settingsController = Get.find<SettingsPageController>();
  static final _backupController = Get.find<BackupPageController>();
  final String pkh;
  final String? prevPage;
  const PrivateKeyPage({super.key, required this.pkh, this.prevPage});

  @override
  State<PrivateKeyPage> createState() => _PrivateKeyPageState();
}

class _PrivateKeyPageState extends State<PrivateKeyPage>
    with WidgetsBindingObserver {
  @override
  void dispose() {
    if (PrivateKeyPage._backupController.timer?.isActive ?? false) {
      PrivateKeyPage._backupController.timer?.cancel();
    }
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // if paused or inactive, stop the timer and pop the page
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive || state == AppLifecycleState.hidden) {
      if (PrivateKeyPage._backupController.timer?.isActive ?? false) {
        PrivateKeyPage._backupController.timer?.cancel();
      }
      Navigator.pop(context);
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    PrivateKeyPage._backupController.setup(context);
    NaanAnalytics.logEvent(NaanAnalyticsEvents.VIEW_PRIVATE_KEY,
        param: {NaanAnalytics.address: widget.pkh});
    return NaanBottomSheet(
        // bottomSheetHorizontalPadding: 0,
        title: "Private key",
        prevPageName: widget.prevPage,
        leading: backButton(
            ontap: () => Navigator.pop(context), lastPageName: widget.prevPage),
        height: AppConstant.naanBottomSheetHeight - 64.arP,
        bottomSheetWidgets: [
          FutureBuilder<AccountSecretModel?>(
              future: UserStorageService().readAccountSecrets(widget.pkh),
              builder: (context, snapshotData) {
                if (snapshotData.hasData) {
                  return Container(
                    height: AppConstant.naanBottomSheetChildHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     backButton(),
                        //     InfoButton(
                        //       onPressed: () => CommonFunctions.bottomSheet(
                        //         const InfoBottomSheet(),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        0.04.vspace,

                        Text(
                          'Your private key can be used to\naccess all of your funds so do not\nshare with anyone'
                              .tr,
                          textAlign: TextAlign.center,
                          style: bodySmall.copyWith(
                              color: ColorConst.NeutralVariant.shade60),
                        ),
                        0.03.vspace,
                        Obx(() => CopyButton(
                            isCopied: PrivateKeyPage
                                ._settingsController.copyToClipboard.value,
                            onPressed: () => PrivateKeyPage._settingsController
                                .paste(
                                    snapshotData.data!.secretKey?.toString()))),
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
                                'This screen will auto close in '.tr,
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
                  return const Center(
                      child: CupertinoActivityIndicator(
                    color: ColorConst.Primary,
                  ));
                }
              }),
        ]);
  }
}
