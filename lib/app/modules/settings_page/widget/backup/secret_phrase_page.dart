import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';
import 'package:plenty_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:plenty_wallet/app/data/services/service_models/account_model.dart';
import 'package:plenty_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:plenty_wallet/app/modules/backup_wallet_page/views/widgets/phrase_container.dart';
import 'package:plenty_wallet/app/modules/common_widgets/back_button.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:plenty_wallet/app/modules/common_widgets/copy_button.dart';
import 'package:plenty_wallet/app/modules/settings_page/controllers/backup_page_controller.dart';
import 'package:plenty_wallet/app/modules/settings_page/controllers/settings_page_controller.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/constants/constants.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';

class SecretPhrasePage extends StatefulWidget {
  final String? prevPage;
  final String pkHash;
  static final _settingsController = Get.find<SettingsPageController>();
  static final _backupController = Get.find<BackupPageController>();
  const SecretPhrasePage({super.key, required this.pkHash, this.prevPage});

  @override
  State<SecretPhrasePage> createState() => _SecretPhrasePageState();
}

class _SecretPhrasePageState extends State<SecretPhrasePage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

    @override
      void dispose() {
        // TODO: implement dispose
        WidgetsBinding.instance.removeObserver(this);
      super.dispose();
      }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // if paused or inactive, stop the timer and pop the page
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      Navigator.pop(context);
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    SecretPhrasePage._backupController.setup(context);
    NaanAnalytics.logEvent(NaanAnalyticsEvents.VIEW_SEED_PHRASE,
        param: {NaanAnalytics.address: widget.pkHash});
    return NaanBottomSheet(
      title: "Secret Phrase",
      leading: backButton(
          ontap: () => Navigator.pop(context), lastPageName: widget.prevPage),
      prevPageName: widget.prevPage,
      // isScrollControlled: true,
      height: AppConstant.naanBottomSheetHeight - 64.arP,
      // bottomSheetHorizontalPadding: 0,
      bottomSheetWidgets: [
        SizedBox(
          height: AppConstant.naanBottomSheetChildHeight,
          child: FutureBuilder<AccountSecretModel?>(
              future: UserStorageService().readAccountSecrets(widget.pkHash),
              builder: (context, snapshotData) {
                if (snapshotData.hasData) {
                  final data = snapshotData.data?.seedPhrase?.split(" ");
                  return Column(
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

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• These ${data?.length} words are the keys to your wallet.'
                                .tr,
                            style: bodySmall.copyWith(
                                color: ColorConst.NeutralVariant.shade60),
                          ),
                          0.020.vspace,
                          Text(
                            '• You can save your secret phrase in a password manager or write it down in multiple secret places.'
                                .tr,
                            style: bodySmall.copyWith(
                                color: ColorConst.NeutralVariant.shade60),
                          ),
                          0.020.vspace,
                          Text(
                            '• In case you lose your secret recovery phrase, there is no way to recover the phrase and access the funds.'
                                .tr,
                            style:
                                bodySmall.copyWith(color: ColorConst.NaanRed),
                          ),
                          0.020.vspace,
                          Text(
                            '• If someone asks you to share your secret recovery phrase, it is a scam. Do not share it with anyone.'
                                .tr,
                            style:
                                bodySmall.copyWith(color: ColorConst.NaanRed),
                          ),
                        ],
                      ),

                      0.03.vspace,
                      Obx(() => CopyButton(
                          isCopied: SecretPhrasePage
                              ._settingsController.copyToClipboard.value,
                          onPressed: () => SecretPhrasePage._settingsController
                              .paste(data?.join(" ").toString()))),
                      0.020.vspace,
                      GridView.builder(
                          shrinkWrap: true,
                          primary: false,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: data?.length,
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  (data?.length ?? 0) == 24 ? 20.arP : 57.arP),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: (data?.length ?? 0) == 24 ? 3 : 2,
                            childAspectRatio: 130 / 40,
                            crossAxisSpacing: 20.arP,
                            mainAxisSpacing: 12.arP,
                          ),
                          itemBuilder: (_, index) {
                            return PhraseContainer(
                                index: index, phrase: data![index]);
                          }),
                      0.07.vspace,
                      Text(
                        'Derivation path'.tr,
                        textAlign: TextAlign.center,
                        style: labelMedium.copyWith(
                            color: ColorConst.NeutralVariant.shade60),
                      ),
                      SizedBox(
                        height: 8.arP,
                      ),
                      Text(
                        "m/44'/1729'/${snapshotData.data?.derivationPathIndex}/0'",
                        textAlign: TextAlign.center,
                        style: labelMedium,
                      ),
                      0.03.vspace,
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
                              '${SecretPhrasePage._backupController.timeLeft.value} seconds',
                              textAlign: TextAlign.center,
                              style: labelSmall,
                            )
                          ],
                        );
                      }),
                    ],
                  );
                } else {
                  return const Center(
                    child: CupertinoActivityIndicator(
                      color: ColorConst.Primary,
                    ),
                  );
                }
              }),
        )
      ],
    );
    // return SafeArea(
    //   bottom: false,
    //   top: true,
    //   child: Scaffold(
    //     body: Container(
    //       height: 1.height,
    //       width: 1.width,
    //       padding: const EdgeInsets.only(top: 30),
    //       decoration:
    //           const BoxDecoration(gradient: GradConst.GradientBackground),
    //       child: Center(
    //         child: SingleChildScrollView(
    //           physics: const BouncingScrollPhysics(),
    //           child: FutureBuilder<AccountSecretModel?>(
    //               future: UserStorageService().readAccountSecrets(pkHash),
    //               builder: (context, snapshotData) {
    //                 if (snapshotData.hasData) {
    //                   final data = snapshotData.data?.seedPhrase?.split(" ");
    //                   return Column(
    //                     mainAxisAlignment: MainAxisAlignment.start,
    //                     crossAxisAlignment: CrossAxisAlignment.center,
    //                     children: [
    //                       Padding(
    //                         padding: const EdgeInsets.symmetric(horizontal: 21),
    //                         child: Row(
    //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                           children: [
    //                             backButton(),
    //                             InfoButton(
    //                               onPressed: () => Get.bottomSheet(
    //                                 const InfoBottomSheet(),
    //                                 enterBottomSheetDuration:
    //                                     const Duration(milliseconds: 180),
    //                                 exitBottomSheetDuration:
    //                                     const Duration(milliseconds: 150),
    //                                 enableDrag: true,
    //                                 isDismissible: true,
    //                                 isScrollControlled: true,
    //                                 barrierColor:
    //                                     const Color.fromARGB(09, 255, 255, 255),
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                       0.040.vspace,
    //                       Text(
    //                         'Your Secret Phrase',
    //                         style: titleLarge,
    //                       ),
    //                       0.030.vspace,
    //                       Text(
    //                         'These 12 words are the keys to your\nwallet. Back them up with a password\nmanager or write them down.',
    //                         textAlign: TextAlign.center,
    //                         style: bodyLarge.copyWith(
    //                             color: ColorConst.NeutralVariant.shade60),
    //                       ),
    //                       Obx(() => CopyButton(
    //                           isCopied:
    //                               _settingsController.copyToClipboard.value,
    //                           onPressed: () => _settingsController
    //                               .paste(data?.join().toString()))),
    //                       0.020.vspace,
    //                       GridView.builder(
    //                           shrinkWrap: true,
    //                           primary: false,
    //                           itemCount: data?.length,
    //                           padding:
    //                               const EdgeInsets.symmetric(horizontal: 57),
    //                           gridDelegate:
    //                               const SliverGridDelegateWithFixedCrossAxisCount(
    //                             crossAxisCount: 2,
    //                             childAspectRatio: 130 / 40,
    //                             crossAxisSpacing: 20,
    //                             mainAxisSpacing: 12,
    //                           ),
    //                           itemBuilder: (_, index) {
    //                             return PhraseContainer(
    //                                 index: index, phrase: data![index]);
    //                           }),
    //                       0.03.vspace,
    //                       Text(
    //                         'Derivation path',
    //                         textAlign: TextAlign.center,
    //                         style: labelMedium.copyWith(
    //                             color: ColorConst.NeutralVariant.shade60),
    //                       ),
    //                       const SizedBox(
    //                         height: 8,
    //                       ),
    //                       Text(
    //                         '${snapshotData.data?.derivationPathIndex}',
    //                         textAlign: TextAlign.center,
    //                         style: labelMedium,
    //                       ),
    //                       0.03.vspace,
    //                       Row(
    //                         mainAxisAlignment: MainAxisAlignment.center,
    //                         children: [
    //                           Text(
    //                             'This screen will auto close in ',
    //                             textAlign: TextAlign.center,
    //                             style: labelSmall.copyWith(
    //                                 color: ColorConst.NeutralVariant.shade60),
    //                           ),
    //                           Text(
    //                             '30 seconds',
    //                             textAlign: TextAlign.center,
    //                             style: labelSmall,
    //                           )
    //                         ],
    //                       )
    //                     ],
    //                   );
    //                 } else {
    //                   return const Center(
    //                     child: CircularProgressIndicator(),
    //                   );
    //                 }
    //               }),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
