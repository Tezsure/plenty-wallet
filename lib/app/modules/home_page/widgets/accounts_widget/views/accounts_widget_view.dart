import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/receive_page/views/receive_page_view.dart';
import 'package:naan_wallet/app/modules/send_page/views/send_page.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/utils.dart';
import 'dart:math' as math;

import '../../../../../../utils/colors/colors.dart';
import '../../../../../../utils/styles/styles.dart';
import '../controllers/accounts_widget_controller.dart';
import 'widget/add_account_widget.dart';

// ignore: must_be_immutable
class AccountsWidget extends GetView<AccountsWidgetController> {
  AccountsWidget({Key? key}) : super(key: key);

  HomePageController homePageController = Get.find<HomePageController>();

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
              style: titleSmall.copyWith(
                color: ColorConst.NeutralVariant.shade50,
              ),
            ),
            0.013.vspace,
            Obx(
              () => Visibility(
                visible: homePageController.userAccounts.isEmpty,
                replacement: SizedBox(
                  width: 1.width,
                  height: 0.28.height,
                  child: PageView.builder(
                      padEnds: false,
                      itemCount: homePageController.userAccounts.length + 1,
                      controller: PageController(
                        viewportFraction:
                            homePageController.userAccounts.length - 1 ==
                                    controller.selectedAccountIndex.value
                                ? 1
                                : 0.98,
                        initialPage: 0,
                      ),
                      onPageChanged: controller.onPageChanged,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, index) {
                        return index == homePageController.userAccounts.length
                            ? const Padding(
                                padding: EdgeInsets.only(right: 12.0),
                                child: AddAccountWidget(),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: accountContainer(
                                  homePageController.userAccounts[index],
                                ),
                              );
                      }),
                ),
                child: const AddAccountWidget(),
              ),
            ),
            Obx(
              () => homePageController.userAccounts.isEmpty
                  ? Row(
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
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        0.010.hspace,
                        SizedBox(
                          height: 10,
                          width: 0.55.width,
                          child: Obx(
                            () => ListView.builder(
                              itemCount:
                                  // ignore: invalid_use_of_protected_member
                                  homePageController.userAccounts.value.length +
                                      1,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemBuilder: ((context, index) {
                                return Obx(() {
                                  return index ==
                                          homePageController.userAccounts.length
                                      ? Icon(
                                          Icons.add,
                                          color: controller.selectedAccountIndex
                                                      .value ==
                                                  homePageController
                                                      .userAccounts.length
                                              ? Colors.white
                                              : ColorConst
                                                  .NeutralVariant.shade50,
                                          size: 10,
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 2.0),
                                          child: Container(
                                            height: 8,
                                            width: 8,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: controller
                                                          .selectedAccountIndex
                                                          .value ==
                                                      index
                                                  ? Colors.white
                                                  : ColorConst
                                                      .NeutralVariant.shade40,
                                            ),
                                          ),
                                        );
                                });
                              }),
                            ),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget accountContainer(AccountModel model) {
    return Stack(
      children: [
        Container(
          height: 0.26.height,
          width: 1.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SvgPicture.asset(
              controller.imagePath[Random().nextInt(3)],
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 0.26.height,
          width: 1.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: const Alignment(-0.1, 0),
                end: const Alignment(1, 0),
                colors: [
                  ColorConst.Primary.shade50,
                  // const Color(0xff9961EC),
                  const Color(0xff4E4D4D).withOpacity(0),
                ],
              )),
        ),
        Padding(
          padding: EdgeInsets.only(left: 31.0, top: 0.04.height),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    model.name!,
                    style: labelSmall,
                  ),
                  0.010.hspace,
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    maxRadius: 8,
                    minRadius: 8,
                    child: model.imageType == AccountProfileImageType.assets
                        ? Image.asset(model.profileImage!)
                        : Image.file(File(model.profileImage!)),
                  )
                ],
              ),
              0.02.vspace,
              Row(
                children: [
                  Text(
                    tz1Shortner(model.publicKeyHash!),
                    style: bodySmall,
                  ),
                  0.01.hspace,
                  InkWell(
                    onTap: () {
                      Clipboard.setData(
                          ClipboardData(text: model.publicKeyHash));
                      Get.snackbar(
                        "Info",
                        "Copied to clipboard",
                        shouldIconPulse: true,
                        snackPosition: SnackPosition.BOTTOM,
                        // icon: const Icon(Icons.copy),
                        maxWidth: 0.9.width,
                        // ignore: prefer_const_constructors
                        margin: EdgeInsets.only(
                          bottom: 20,
                        ),
                        duration: const Duration(milliseconds: 750),
                      );
                    },
                    child: const Icon(
                      Icons.copy,
                      size: 11,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              0.015.vspace,
              Row(
                children: [
                  Text(
                    model.accountDataModel!.totalBalance!.toStringAsFixed(6),
                    style: headlineSmall,
                  ),
                  0.010.hspace,
                  SvgPicture.asset(
                    'assets/svg/path.svg',
                    color: Colors.white,
                    height: 20,
                    width: 15,
                  ),
                ],
              ),
              0.017.vspace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RawMaterialButton(
                    constraints: const BoxConstraints(),
                    elevation: 1,
                    padding: const EdgeInsets.all(8),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    enableFeedback: true,
                    onPressed: () {
                      Get.bottomSheet(const SendPage(),
                          isScrollControlled: true,
                          settings: RouteSettings(
                            arguments: model,
                          ),
                          barrierColor: Colors.white.withOpacity(0.09));
                    },
                    fillColor: ColorConst.Primary.shade0,
                    shape: const CircleBorder(side: BorderSide.none),
                    child: const Icon(
                      Icons.turn_right_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  0.016.hspace,
                  Transform.rotate(
                    angle: -math.pi / 1,
                    child: RawMaterialButton(
                      enableFeedback: true,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                      elevation: 1,
                      onPressed: () {
                        Get.bottomSheet(
                            ReceivePageView(
                                publicKeyHash: model.publicKeyHash ?? "",
                                accountName: model.name ?? ""),
                            isScrollControlled: true,
                            barrierColor: Colors.white.withOpacity(0.09));
                      },
                      fillColor: ColorConst.Primary.shade0,
                      shape: const CircleBorder(side: BorderSide.none),
                      child: const Icon(
                        Icons.turn_right_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
