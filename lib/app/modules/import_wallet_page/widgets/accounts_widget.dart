import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/import_wallet_page/controllers/import_wallet_page_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/utils.dart';
import 'package:naan_wallet/app/data/services/extension_service/extension_service.dart';
import '../../../../utils/styles/styles.dart';

class AccountWidget extends StatelessWidget {
  AccountWidget({Key? key}) : super(key: key);

  final ImportWalletPageController controller =
      Get.find<ImportWalletPageController>();

  // final Map<String, double> accountBalances = <String, double>{};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () {
            if (controller.generatedAccounts.isEmpty) {
              controller.genAndLoadMoreAccounts(0, 3);
            }
            return Visibility(
                visible: controller.generatedAccounts.length > 4 &&
                    !controller.isLegacySelected.value,
                replacement: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                  ),
                  child: Column(
                    children: [
                      Column(
                        children: controller.isLegacySelected.value
                            ? List.generate(
                                controller.generatedAccounts.isEmpty ? 0 : 1,
                                (index) => accountWidget(index),
                              )
                            : List.generate(
                                controller.generatedAccounts.length - 1,
                                (index) => accountWidget(index + 1),
                              ),
                      ),
                      controller.generatedAccounts.length < 100 &&
                              !controller.isLegacySelected.value
                          ? showMoreAccountButton(
                              controller.generatedAccounts.length - 1)
                          : SizedBox(
                              height: 10.arP,
                            ),
                    ],
                  ),
                ),
                child: Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.only(top: 12, left: 12, right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: controller.isLegacySelected.value
                              ? ListView.builder(
                                  physics: AppConstant.scrollPhysics,
                                  itemBuilder: (context, index) =>
                                      accountWidget(index),
                                  itemCount:
                                      controller.generatedAccounts.isEmpty
                                          ? 0
                                          : 1,
                                  shrinkWrap: true,
                                )
                              : ListView.builder(
                                  physics: AppConstant.scrollPhysics,
                                  itemBuilder: (context, index) =>
                                      accountWidget(index + 1),
                                  itemCount:
                                      controller.generatedAccounts.length - 1,
                                  shrinkWrap: true,
                                ),
                        ),
                        controller.generatedAccounts.length < 100 &&
                                !controller.isLegacySelected.value
                            ? showMoreAccountButton(
                                controller.generatedAccounts.length - 1)
                            : SizedBox(
                                height: 10.arP,
                              ),
                      ],
                    ),
                  ),
                ));
          },
        ),
      ],
    );
  }

  Widget showMoreAccountButton(int index) {
    return Obx(() {
      if (controller.isLoading.value) {
        return SizedBox(
          height: 50,
          width: 50,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CupertinoActivityIndicator(
              color: ColorConst.Primary,
            ),
          ),
        );
      }
      return GestureDetector(
        onTap: () {
          controller.genAndLoadMoreAccounts(index, 3);

          // controller.showMoreAccounts();
          controller.isExpanded.value = true;
        },
        child: SizedBox(
          height: 50,
          child: Center(
            child: Text(
              "Show more accounts",
              style: labelMedium,
            ),
          ),
        ),
      );
    });
  }

  final homeController = Get.put(HomePageController());
  Widget accountWidget(int index) {
    final AccountModel accountModel = controller.generatedAccounts[index];
    final bool isSelected = controller.isLegacySelected.value
        ? controller.selectedLegacyAccount
            .any((e) => e.publicKeyHash == accountModel.publicKeyHash)
        : controller.isTz1Selected.value
            ? controller.selectedAccountsTz1
                .any((e) => e.publicKeyHash == accountModel.publicKeyHash)
            : controller.selectedAccountsTz2
                .any((e) => e.publicKeyHash == accountModel.publicKeyHash);
    final bool isImported = homeController.userAccounts
        .any((element) => element.publicKeyHash == accountModel.publicKeyHash);

    return BouncingWidget(
      onPressed: () {
        if (isImported) return;
        if (!isSelected) {
          controller.isLegacySelected.value
              ? controller.selectedLegacyAccount.add(accountModel)
              : controller.isTz1Selected.value
                  ? controller.selectedAccountsTz1.add(accountModel)
                  : controller.selectedAccountsTz2.add(accountModel);
        } else {
          controller.isLegacySelected.value
              ? controller.selectedLegacyAccount.remove(accountModel)
              : controller.isTz1Selected.value
                  ? controller.selectedAccountsTz1.remove(accountModel)
                  : controller.selectedAccountsTz2.remove(accountModel);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Row(
          children: [
            Container(
              height: 48.arP,
              width: 48.arP,
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
                    log("${accountModel.publicKeyHash}:${accountModel.accountDataModel?.xtzBalance}");
                    // accountBalances[accountModel.publicKeyHash!] = snapshot.data;
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
                      if (!isSelected) {
                        controller.isLegacySelected.value
                            ? controller.selectedLegacyAccount.add(accountModel)
                            : controller.isTz1Selected.value
                                ? controller.selectedAccountsTz1
                                    .add(accountModel)
                                : controller.selectedAccountsTz2
                                    .add(accountModel);
                      } else {
                        controller.isLegacySelected.value
                            ? controller.selectedLegacyAccount
                                .remove(accountModel)
                            : controller.isTz1Selected.value
                                ? controller.selectedAccountsTz1
                                    .remove(accountModel)
                                : controller.selectedAccountsTz2
                                    .remove(accountModel);
                      }
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
                            size: 20.arP,
                          )),
          ],
        ),
      ),
    );
  }

  // Widget accountLoadingShimmer() {
  //   return Row(
  //     children: [
  //       Shimmer.fromColors(
  //           direction: ShimmerDirection.ltr,
  //           child: CircleAvatar(radius: 24),
  //           baseColor: Colors.transparent,
  //           highlightColor: Color(0xffe8e8e8).withOpacity(0.24)),
  //       0.05.hspace,

  //       ],
  //   );
  // }
}
