import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/auth_service/auth_service.dart';
import 'package:naan_wallet/app/data/services/extension_service/account_model_ext_service/account_model_ext_service.dart';
import 'package:naan_wallet/app/data/services/patch_sesrvice/patch_service.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/settings_page/controllers/settings_page_controller.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

class RecoverOldAccountSheet extends StatelessWidget {
  RecoverOldAccountSheet({super.key});
  final accounts = Get.find<SettingsPageController>().oldWallets;
  // final accounts = Get.find<HomePageController>().userAccounts;
  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      // isDraggableBottomSheet: true,
      // itemCount: accounts.length,
      // draggableListBuilder: (context, index) => accountWidget(accounts[index]),
      bottomSheetWidgets: [
        SizedBox(
          height: 0.43.height,
          child: Column(
            children: [
              0.016.vspace,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...List.generate(accounts.length,
                          (index) => accountWidget(accounts[index])).toList()
                    ],
                  ),
                ),
              ),
              0.016.vspace,
              SolidButton(
                width: 1.width - 64.arP,
                title: 'Recover accounts',
                onPressed: () async {
                  await UserStorageService()
                      .writeNewAccount(accounts, false, true);
                  await PatchService().saveDuplicateEntryForStorage();
                  if (!(await AuthService().getIsPassCodeSet())) {
                    Get.toNamed(
                      Routes.PASSCODE_PAGE,
                      arguments: [
                        false,
                        Routes.BIOMETRIC_PAGE,
                      ],
                    );
                  } else {
                    Get.back();
                  }
                  Get.find<SettingsPageController>().getOldWalletAccounts();
                },
              ),
              0.016.vspace,
              SolidButton(
                width: 1.width - 64.arP,
                primaryColor: ColorConst.darkGrey,
                title: 'Cancel',
                onPressed: () {},
              ),
              BottomButtonPadding()
            ],
          ),
        ),
      ],
      height: 0.52.height,
      title: "Recover accounts",
    );
  }

  Widget accountWidget(AccountModel accountModel) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.arP, vertical: 5.arP),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            alignment: Alignment.bottomRight,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage(accountModel.profileImage!),
              ),
            ),
          ),
          0.05.hspace,
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tz1Shortner(accountModel.publicKeyHash!),
                style: bodySmall,
              ),
              FutureBuilder<double>(
                key: Key(accountModel.publicKeyHash!),
                initialData: 0.0,
                future: accountModel.getUserBalanceInTezos(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Text(
                      "0.0 tez",
                      style: labelSmall.apply(
                          color: ColorConst.NeutralVariant.shade60),
                    );
                  }
                  accountModel.accountDataModel =
                      AccountDataModel(xtzBalance: snapshot.data);
                  return Text(
                    "${accountModel.accountDataModel?.xtzBalance ?? 0.0} tez",
                    style: labelSmall.apply(
                        color: ColorConst.NeutralVariant.shade60),
                  );
                },
              ),
            ],
          ),
          const Spacer(),
          // if (isSelected)
        ],
      ),
    );
  }
}
