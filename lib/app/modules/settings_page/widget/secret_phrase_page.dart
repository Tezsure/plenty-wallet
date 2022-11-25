import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/app/modules/backup_wallet_page/views/widgets/phrase_container.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/copy_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/info_button.dart';
import 'package:naan_wallet/app/modules/settings_page/controllers/settings_page_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import 'package:naan_wallet/app/data/mock/mock_data.dart';

class SecretPhrasePage extends StatelessWidget {
  final String pkHash;
  static final _settingsController = Get.find<SettingsPageController>();
  const SecretPhrasePage({super.key, required this.pkHash});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: true,
      child: Scaffold(
        body: Container(
          height: 1.height,
          width: 1.width,
          padding: const EdgeInsets.only(top: 30),
          decoration:
              const BoxDecoration(gradient: GradConst.GradientBackground),
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: FutureBuilder<AccountSecretModel?>(
                  future: UserStorageService().readAccountSecrets(pkHash),
                  builder: (context, snapshotData) {
                    if (snapshotData.hasData) {
                      final data = snapshotData.data?.seedPhrase?.split(" ");
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 21),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                backButton(),
                                InfoButton(
                                  onPressed: () => Get.bottomSheet(
                                    infoBottomSheet(),
                                    enterBottomSheetDuration:
                                        const Duration(milliseconds: 180),
                                    exitBottomSheetDuration:
                                        const Duration(milliseconds: 150),
                                    enableDrag: true,
                                    isDismissible: true,
                                    isScrollControlled: true,
                                    barrierColor:
                                        const Color.fromARGB(09, 255, 255, 255),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          0.040.vspace,
                          Text(
                            'Your Secret Phrase',
                            style: titleLarge,
                          ),
                          0.030.vspace,
                          Text(
                            'These 12 words are the keys to your\nwallet. Back them up with a password\nmanager or write them down.',
                            textAlign: TextAlign.center,
                            style: bodyLarge.copyWith(
                                color: ColorConst.NeutralVariant.shade60),
                          ),
                          Obx(() => CopyButton(
                              isCopied:
                                  _settingsController.copyToClipboard.value,
                              onPressed: () => _settingsController
                                  .paste(data?.join().toString()))),
                          0.020.vspace,
                          GridView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: data?.length,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 57),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 130 / 40,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 12,
                              ),
                              itemBuilder: (_, index) {
                                return PhraseContainer(
                                    index: index, phrase: data![index]);
                              }),
                          0.03.vspace,
                          Text(
                            'Derivation path',
                            textAlign: TextAlign.center,
                            style: labelMedium.copyWith(
                                color: ColorConst.NeutralVariant.shade60),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            '${snapshotData.data?.derivationPathIndex}',
                            textAlign: TextAlign.center,
                            style: labelMedium,
                          ),
                          0.03.vspace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'This screen will auto close in ',
                                textAlign: TextAlign.center,
                                style: labelSmall.copyWith(
                                    color: ColorConst.NeutralVariant.shade60),
                              ),
                              Text(
                                '30 seconds',
                                textAlign: TextAlign.center,
                                style: labelSmall,
                              )
                            ],
                          )
                        ],
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
          ),
        ),
      ),
    );
  }

  Widget infoBottomSheet() {
    return NaanBottomSheet(
        blurRadius: 5,
        gradientStartingOpacity: 1,
        isDraggableBottomSheet: true,
        title: 'Introduction to crypto wallet',
        draggableListBuilder: (_, index) {
          return RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                text: '${MockData.walletInfo.keys.elementAt(index)}\n',
                style: bodyMedium,
                children: [
                  TextSpan(
                    text: "\n${MockData.walletInfo.values.elementAt(index)}\n",
                    style: bodySmall.copyWith(
                      color: ColorConst.NeutralVariant.shade60,
                    ),
                  )
                ],
              ));
        });
  }
}
