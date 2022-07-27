import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/import_wallet_page/widgets/accounts_widget.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../../../../utils/colors/colors.dart';
import '../../../../utils/constants/path_const.dart';
import '../../common_widgets/back_button.dart';
import '../controllers/import_wallet_page_controller.dart';

class ImportWalletPageView extends GetView<ImportWalletPageController> {
  const ImportWalletPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: GradConst.GradientBackground),
      width: 1.width,
      padding: EdgeInsets.symmetric(horizontal: 0.05.width),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          0.05.vspace,
          Row(
            children: [
              backButton(),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Get.bottomSheet(
                    infoBottomSheet(),
                    isScrollControlled: true,
                    barrierColor: Colors.white.withOpacity(0.2),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: ColorConst.NeutralVariant.shade60,
                      size: 16,
                    ),
                    0.01.hspace,
                    Text(
                      "Info",
                      style: titleMedium.apply(
                          color: ColorConst.NeutralVariant.shade60),
                    )
                  ],
                ),
              )
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  0.05.vspace,
                  Text(
                    "Import wallet",
                    style: titleLarge,
                  ),
                  0.05.vspace,
                  Material(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white.withOpacity(0.2),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 0.02.height,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 0.18.height,
                        child: Column(
                          children: [
                            0.02.vspace,
                            Expanded(
                              child: TextFormField(
                                cursorColor: ColorConst.Primary,
                                expands: true,
                                controller:
                                    controller.phraseTextController.value,
                                style: bodyMedium,
                                onChanged: (value) {
                                  print(value);
                                },
                                maxLines: null,
                                minLines: null,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(0),
                                    hintStyle: bodyMedium.apply(
                                        color: Colors.white.withOpacity(0.2)),
                                    hintText:
                                        "Paste your secret phrase, private key\nor watch address",
                                    border: InputBorder.none),
                              ),
                            ),
                            Obx(() => controller.phraseTextController.value
                                            .value.text !=
                                        "" &&
                                    controller.phraseTextController.value.text
                                        .isNotEmpty
                                ? Align(
                                    alignment: Alignment.bottomRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.phraseTextController.value
                                            .text = "";
                                        controller.phraseTextController.value =
                                            controller
                                                .phraseTextController.value;
                                      },
                                      child: Text(
                                        "Clear",
                                        style: titleSmall.apply(
                                            color: ColorConst.Primary),
                                      ),
                                    ),
                                  )
                                : Container()),
                            0.01.vspace,
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Obx(
            () => controller.phraseTextController.value.value.text != "" &&
                    controller.phraseTextController.value.text.isEmpty
                ? pasteButton()
                : importButton(),
          ),
          0.05.vspace,
          SizedBox(
            height: MediaQuery.of(context).viewInsets.bottom,
          )
        ],
      ),
    );
  }

  SolidButton pasteButton() {
    return SolidButton(
      onPressed: controller.paste,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            PathConst.SVG + "paste.svg",
            fit: BoxFit.scaleDown,
          ),
          0.02.hspace,
          Text(
            "Paste",
            style: titleSmall.apply(color: ColorConst.Neutral.shade95),
          )
        ],
      ),
    );
  }

  Widget importButton() {
    return Obx(
      () => SolidButton(
        onPressed: () {
          Get.bottomSheet(
            accountBottomSheet(),
            isScrollControlled: true,
            barrierColor: Colors.white.withOpacity(0.2),
          );
        },
        active: controller.phraseTextController.value.value.text
                .split(" ")
                .length ==
            12,
        inActiveChild: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              PathConst.SVG + "import.svg",
              fit: BoxFit.scaleDown,
              color: ColorConst.NeutralVariant.shade60,
            ),
            0.03.hspace,
            Text(
              "Import",
              style: titleSmall.apply(color: ColorConst.NeutralVariant.shade60),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              PathConst.SVG + "import.svg",
              fit: BoxFit.scaleDown,
              color: ColorConst.Neutral.shade95,
            ),
            0.03.hspace,
            Text(
              "Import",
              style: titleSmall.apply(color: ColorConst.Neutral.shade95),
            )
          ],
        ),
      ),
    );
  }

  Widget accountBottomSheet() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff07030c).withOpacity(0.49),
              Color(0xff2d004f),
            ],
          ),
        ),
        width: 1.width,
        height: 0.85.height,
        padding: EdgeInsets.symmetric(horizontal: 0.05.width),
        child: Column(
          children: [
            0.005.vspace,
            Container(
              height: 5,
              width: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
              ),
            ),
            0.05.vspace,
            Text(
              "Wallets ready to import",
              textAlign: TextAlign.start,
              style: titleLarge,
            ),
            0.03.vspace,
            Expanded(
              child: AccountWidget(),
            ),
            0.03.vspace,
            SolidButton(
              onPressed: () {},
              title: "Continue",
            ),
            0.05.vspace
          ],
        ),
      ),
    );
  }

  Widget infoBottomSheet() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 1,
        minChildSize: 0.85,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff07030c).withOpacity(0.49),
                  Color(0xff2d004f),
                ],
              ),
            ),
            width: 1.width,
            padding: EdgeInsets.symmetric(horizontal: 0.05.width),
            child: Column(
              children: [
                0.005.vspace,
                Container(
                  height: 5,
                  width: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
                  ),
                ),
                0.05.vspace,
                Text(
                  "Wallets ready to import",
                  textAlign: TextAlign.start,
                  style: titleLarge,
                ),
                0.05.vspace,
                Expanded(
                  child: RawScrollbar(
                    controller: scrollController,
                    radius: Radius.circular(2),
                    trackRadius: Radius.circular(2),
                    thickness: 4,
                    isAlwaysShown: true,
                    thumbColor: ColorConst.NeutralVariant.shade60,
                    trackColor:
                        ColorConst.NeutralVariant.shade60.withOpacity(0.4),
                    trackBorderColor:
                        ColorConst.NeutralVariant.shade60.withOpacity(0.4),
                    child: ListView.separated(
                        physics: BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        controller: scrollController,
                        padding: EdgeInsets.only(right: 0.03.width),
                        itemBuilder: (_, index) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${index}. What is Secret Phrase?",
                                  style: bodyMedium,
                                ),
                                0.012.vspace,
                                Text(
                                  "Secret Recovery Phrase is a unique 12-word phrase that is generated when you first set up MetaMask. Your funds are connected to that phrase. If you ever lose your password, your Secret Recovery Phrase allows you to recover your wallet and your funds. Write it down on paper and hide it somewhere, put it in a safety deposit box, or use a secure password manager. Some users even engrave their phrases into metal plates!",
                                  style: bodySmall.apply(
                                      color: ColorConst.NeutralVariant.shade60),
                                ),
                              ],
                            ),
                        separatorBuilder: (_, index) => 0.04.vspace,
                        itemCount: 5),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
