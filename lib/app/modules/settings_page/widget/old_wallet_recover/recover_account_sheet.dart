import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/extension_service/account_model_ext_service/account_model_ext_service.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/settings_page/bindings/settings_page_binding.dart';
import 'package:naan_wallet/app/modules/settings_page/controllers/settings_page_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

class RecoverOldAccountSheet extends StatelessWidget {
  RecoverOldAccountSheet({super.key});
  final accounts = Get.find<SettingsPageController>().oldWallets;
  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      bottomSheetWidgets: [
        SizedBox(
          height: 0.43.height,
          child: Column(
            children: [
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
                title: 'Recover accounts',
                onPressed: () {},
              ),
              0.016.vspace,
              SolidButton(
                primaryColor: ColorConst.darkGrey,
                title: 'Cancel',
                onPressed: () {},
              ),
              BottomButtonPadding()
            ],
          ),
        ),
      ],
      height: 0.5.height,
      title: "Recover accounts",
    );
  }

  Widget accountWidget(AccountModel accountModel) {
    bool isSelected = false;
    bool isImported = false;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
          isImported
              ? Text(
                  "IMPORTED",
                  style: labelSmall.copyWith(color: ColorConst.Primary),
                )
              : IconButton(
                  onPressed: () {
                    // if (!isSelected) {
                    //   controller.isLegacySelected.value
                    //       ? controller.selectedLegacyAccount.add(accountModel)
                    //       : controller.isTz1Selected.value
                    //           ? controller.selectedAccountsTz1.add(accountModel)
                    //           : controller.selectedAccountsTz2
                    //               .add(accountModel);
                    // } else {
                    //   controller.isLegacySelected.value
                    //       ? controller.selectedLegacyAccount
                    //           .remove(accountModel)
                    //       : controller.isTz1Selected.value
                    //           ? controller.selectedAccountsTz1
                    //               .remove(accountModel)
                    //           : controller.selectedAccountsTz2
                    //               .remove(accountModel);
                    // }
                  },
                  icon: isSelected
                      ? SvgPicture.asset(
                          "assets/svg/check_3.svg",
                          height: 20.arP,
                          width: 20.arP,
                        )
                      : Icon(
                          Icons.circle_outlined,
                          color: ColorConst.NeutralVariant.shade30,
                        )),
        ],
      ),
    );
  }
}
