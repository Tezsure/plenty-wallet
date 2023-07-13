import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/data/services/service_models/account_model.dart';
import 'package:plenty_wallet/app/modules/common_widgets/back_button.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:plenty_wallet/app/modules/settings_page/widget/backup/select_reveal_key_sheet.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/common_functions.dart';
import 'package:plenty_wallet/utils/constants/constants.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';
import 'package:plenty_wallet/utils/utils.dart';

import '../../../../data/services/enums/enums.dart';
import '../../../home_page/controllers/home_page_controller.dart';

class BackupPage extends StatelessWidget {
  final String? prevPage;
  BackupPage({super.key, this.prevPage});

  // final controller = Get.put(BackupPageController());
  static final _homePageController = Get.find<HomePageController>();

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
        height: AppConstant.naanBottomSheetHeight,
        prevPageName: prevPage,
        bottomSheetWidgets: [
          SizedBox(
            height: AppConstant.naanBottomSheetChildHeight,
            child: Column(
              children: [
                BottomSheetHeading(
                  title: "Backup",
                  leading: backButton(
                      lastPageName: prevPage,
                      ontap: prevPage == null
                          ? null
                          : () => Navigator.pop(context)),
                ),
                0.02.vspace,
                Expanded(
                  child: Obx(
                    () => ListView.builder(
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        if (_homePageController
                            .userAccounts[index].isWatchOnly) {
                          return Container();
                        }
                        return accountMethod(
                            _homePageController.userAccounts[index], context);
                      },
                      itemCount: _homePageController.userAccounts.length,
                      // itemCount: 20.obs.value,
                    ),
                  ),
                )
              ],
            ),
          )
        ]);
  }

  Widget accountMethod(AccountModel accountModel, BuildContext context) {
    return BouncingWidget(
      onPressed: () {
        return Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SelectToRevealKeyBottomSheet(
                prevPage: "Backup",
                accountModel: accountModel,
              ),
            ));
        CommonFunctions.bottomSheet(
          SelectToRevealKeyBottomSheet(
            prevPage: "Backup",
            accountModel: accountModel,
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.arP),
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
                  style: bodySmall.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  tz1Shortner(accountModel.publicKeyHash ?? ''),
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
    );
  }

  Container revealButtonUI() {
    return Container(
      // decoration: BoxDecoration(
      //     // color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
      //     borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Reveal".tr,
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
