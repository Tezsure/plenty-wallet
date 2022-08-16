import 'dart:math';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../../utils/colors/colors.dart';
import '../../../../../../utils/styles/styles.dart';
import '../controllers/accounts_widget_controller.dart';
import 'widget/accounts_container.dart';
import 'widget/add_account_widget.dart';

class AccountsWidget extends GetView<AccountsWidgetController> {
  const AccountsWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => AccountsWidgetController());
    return Padding(
      padding: EdgeInsets.only(left: 0.04.width),
      child: SizedBox(
        width: 1.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Wallets',
              style:
                  titleSmall.copyWith(color: ColorConst.NeutralVariant.shade50),
            ),
            0.013.vspace,
            Obx(
              () => Visibility(
                visible: controller.accountsList.isEmpty,
                replacement: SizedBox(
                  width: 1.width,
                  height: 0.28.height,
                  child: PageView.builder(
                      padEnds: false,
                      itemCount: controller.accountsList.length,
                      controller: PageController(
                        viewportFraction: controller.accountsList.length - 1 ==
                                controller.selectedAccountIndex.value
                            ? 1
                            : 0.98,
                        initialPage: 0,
                      ),
                      onPageChanged: (val) => controller.onPageChanged(val),
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, index) {
                        return Visibility(
                          visible: index == controller.accountsList.length - 1,
                          replacement: Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: AccountsContainer(
                                imagePath:
                                    controller.imagePath[Random().nextInt(3)]),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(right: 12.0),
                            child: AddAccountWidget(),
                          ),
                        );
                      }),
                ),
                child: const AddAccountWidget(),
              ),
            ),
            Visibility(
              visible: controller.accountsList.isEmpty,
              replacement: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  0.010.hspace,
                  SizedBox(
                    height: 10,
                    width: 0.55.width,
                    child: ListView.builder(
                      itemCount: controller.accountsList.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemBuilder: ((context, index) {
                        return Obx(() => Visibility(
                              visible:
                                  index == controller.accountsList.length - 1,
                              replacement: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Container(
                                  height: 8,
                                  width: 8,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: controller
                                                  .selectedAccountIndex.value ==
                                              index
                                          ? Colors.white
                                          : ColorConst.NeutralVariant.shade40),
                                ),
                              ),
                              child: Icon(
                                Icons.add,
                                color: controller.selectedAccountIndex.value ==
                                        controller.accountsList.length - 1
                                    ? Colors.white
                                    : ColorConst.NeutralVariant.shade50,
                                size: 10,
                              ),
                            ));
                      }),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'learn account',
                      style: labelSmall.copyWith(
                          color: ColorConst.Neutral.shade95),
                    ),
                  ),
                  0.03.hspace,
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  0.04.hspace,
                  Text(
                    'Already Have A Wallet?',
                    style: labelSmall.copyWith(
                        color: ColorConst.NeutralVariant.shade60),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Restore Account',
                      style: labelSmall.copyWith(
                          color: ColorConst.Neutral.shade95),
                    ),
                  ),
                  0.03.hspace,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
