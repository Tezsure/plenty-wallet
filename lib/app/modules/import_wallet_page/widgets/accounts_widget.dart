import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/import_wallet_page/controllers/import_wallet_page_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/utils.dart';
import 'package:naan_wallet/app/data/services/extension_service/extension_service.dart';
import '../../../../utils/styles/styles.dart';

class AccountWidget extends StatelessWidget {
  AccountWidget({Key? key}) : super(key: key);

  final ImportWalletPageController controller =
      Get.find<ImportWalletPageController>();

  final Map<String, double> accountBalances = <String, double>{};

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
                visible: controller.isExpanded.isTrue,
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
                        children: List.generate(
                          controller.generatedAccounts.length,
                          (index) => accountWidget(
                              controller.generatedAccounts[index], index),
                        ),
                      ),
                      if (controller.generatedAccounts.length < 100)
                        showMoreAccountButton(
                            controller.generatedAccounts.length - 1),
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
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) => accountWidget(
                                controller.generatedAccounts[index], index),
                            itemCount: controller.generatedAccounts.length,
                            shrinkWrap: true,
                          ),
                        ),
                        if (controller.generatedAccounts.length < 100)
                          showMoreAccountButton(
                              controller.generatedAccounts.length - 1),
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
  }

  final homeController = Get.put(HomePageController());
  Widget accountWidget(AccountModel accountModel, index) {
    final bool isSelected = controller.isTz1Selected.value
        ? controller.selectedAccountsTz1
            .any((e) => e.publicKeyHash == accountModel.publicKeyHash)
        : controller.selectedAccountsTz2
            .any((e) => e.publicKeyHash == accountModel.publicKeyHash);
    final bool isImported = homeController.userAccounts
        .any((element) => element.publicKeyHash == accountModel.publicKeyHash);

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
                future: accountModel.getUserBalanceInTezos(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Text(
                      "0.0 tez",
                      style: labelSmall.apply(
                          color: ColorConst.NeutralVariant.shade60),
                    );
                  }
                  accountBalances[accountModel.publicKeyHash!] = snapshot.data;
                  return Text(
                    "${accountBalances[accountModel.publicKeyHash!]} tez",
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
                      controller.isTz1Selected.value
                          ? controller.selectedAccountsTz1.add(accountModel)
                          : controller.selectedAccountsTz2.add(accountModel);
                    } else {
                      controller.isTz1Selected.value
                          ? controller.selectedAccountsTz1.remove(accountModel)
                          : controller.selectedAccountsTz2.remove(accountModel);
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
                        )),
        ],
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
