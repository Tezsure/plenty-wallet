import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/settings_page/widget/backup/select_reveal_key_sheet.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

import '../../../../data/services/enums/enums.dart';
import '../../../home_page/controllers/home_page_controller.dart';

class BackupPage extends StatelessWidget {
  BackupPage({super.key});

  // final controller = Get.put(BackupPageController());
  static final _homePageController = Get.find<HomePageController>();

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
        // isScrollControlled: true,
        height: AppConstant.naanBottomSheetHeight,
        title: "Backup",
        leading: backButton(),
        bottomSheetHorizontalPadding: 16.arP,
        bottomSheetWidgets: [
          SizedBox(
            height: AppConstant.naanBottomSheetChildHeight,
            child: Column(
              children: [
                0.02.vspace,
                Expanded(
                  child: Obx(
                    () => ListView.builder(
                      itemBuilder: (context, index) {
                        if (_homePageController
                            .userAccounts[index].isWatchOnly) {
                          return Container();
                        }
                        return accountMethod(
                          _homePageController.userAccounts[index],
                        );
                      },
                      itemCount: _homePageController.userAccounts.length,
                    ),
                  ),
                )
              ],
            ),
          )
        ]);
  }

  Widget accountMethod(AccountModel accountModel) {
    return BouncingWidget(
      onPressed: () {
        CommonFunctions.bottomSheet(
          SelectToRevealKeyBottomSheet(
            accountModel: accountModel,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: SizedBox(
          // height: 44,
          child: Row(
            children: [
              CircleAvatar(
                radius: 22.arP,
                backgroundColor:
                    ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                child: Container(
                  alignment: Alignment.bottomRight,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: accountModel.imageType ==
                              AccountProfileImageType.assets
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
                    style: bodySmall.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    tz1Shortner(accountModel.publicKeyHash ?? 'nxkjfbhedvzbv'),
                    style: labelSmall.apply(
                        color: ColorConst.NeutralVariant.shade60),
                  ),
                ],
              ),
              const Spacer(),
              revealButtonUI()
            ],
          ),
        ),
      ),
    );
  }

  Container revealButtonUI() {
    return Container(
      height: 24,
      width: 74,
      // decoration: BoxDecoration(
      //     // color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
      //     borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Reveal",
            style: labelSmall,
          ),
          const SizedBox(
            width: 5,
          ),
          const Icon(Icons.chevron_right_rounded, size: 15, color: Colors.white)
        ],
      ),
    );
  }
}
