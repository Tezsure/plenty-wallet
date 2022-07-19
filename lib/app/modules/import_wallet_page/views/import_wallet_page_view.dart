import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/naan_textfield.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/material_Tap.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../../../../utils/colors/colors.dart';
import '../../../../utils/constants/path_const.dart';
import '../../common_widgets/back_button.dart';
import '../controllers/import_wallet_page_controller.dart';

class ImportWalletPageView extends GetView<ImportWalletPageController> {
  const ImportWalletPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Container(
      decoration: BoxDecoration(gradient: GradConst.GradientBackground),
      width: 1.width,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          38.vspace,
          Row(
            children: [
              backButton(),
              Spacer(),
              GestureDetector(
                onTap: (){},
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: ColorConst.NeutralVariant.shade60,
                      size: 16,
                    ),
                    6.hspace,
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
                  53.vspace,
                  Text(
                    "Import wallet",
                    style: titleLarge,
                  ),
                  29.vspace,
                  Material(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white.withOpacity(0.2),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 19,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 137,
                        child: Column(
                          children: [
                            18.vspace,
                            Expanded(
                              child: TextFormField(
                                cursorColor: ColorConst.Primary,
                                expands: true,
                                controller: controller,
                                style: bodyMedium,
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
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                "Clear",
                                style:
                                    titleSmall.apply(color: ColorConst.Primary),
                              ),
                            ),
                            12.vspace,
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          controller.value.text.length > 1 ? pasteButton() : importButton(),
          (44 + MediaQuery.of(context).viewInsets.bottom).vspace
        ],
      ),
    );
  }

  SolidButton pasteButton() {
    return SolidButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            PathConst.SVG + "paste.svg",
            fit: BoxFit.scaleDown,
          ),
          10.hspace,
          Text(
            "Paste",
            style: titleSmall.apply(color: ColorConst.Neutral.shade95),
          )
        ],
      ),
    );
  }

  SolidButton importButton() {
    return SolidButton(
      onPressed: () {
        Get.bottomSheet(accountBottomSheet(),
            isScrollControlled: true, barrierColor: Colors.transparent);
      },
      active: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            PathConst.SVG + "import.svg",
            fit: BoxFit.scaleDown,
            color: ColorConst.Neutral.shade95,
          ),
          10.hspace,
          Text(
            "Import",
            style: titleSmall.apply(color: ColorConst.Neutral.shade95),
          )
        ],
      ),
      inActiveChild: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            PathConst.SVG + "import.svg",
            fit: BoxFit.scaleDown,
            color: ColorConst.NeutralVariant.shade60,
          ),
          10.hspace,
          Text(
            "Import",
            style: titleSmall.apply(color: ColorConst.NeutralVariant.shade60),
          )
        ],
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
        height: 725.h,
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            5.vspace,
            Container(
              height: 5,
              width: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
              ),
            ),
            44.vspace,
            Text(
              "Change profile photo",
              textAlign: TextAlign.start,
              style: titleLarge,
            ),
            25.vspace,
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 12, left: 12, right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
              ),
              child: Column(
                children: [
                  ListView.separated(
                    itemBuilder: (context, index) => accountWidget(),
                    separatorBuilder: (context, index) => Divider(
                        color: Color(0xff4a454e), height: 1, thickness: 1),
                    itemCount: 3,
                    shrinkWrap: true,
                  ),
                  Divider(
                    color: Color(0xff4a454e),
                    height: 1,
                    thickness: 1,
                  ),
                  SizedBox(
                    height: 50,
                    child: Center(
                      child: Text(
                        "Show more accounts",
                        style: labelMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            22.vspace,
            SolidButton(
              title: "Continue",
            ),
            45.vspace
          ],
        ),
      ),
    );
  }

  Widget accountWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: 84,
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
          ),
          20.hspace,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              3.vspace,
              Text(
                "tz1...qfDZg",
                style: bodySmall,
              ),
              Spacer(),
              Text(
                "20 tez",
                style: bodyLarge,
              ),
              3.vspace
            ],
          ),
          Spacer(),
          Material(
            color: Colors.transparent,
            child: Checkbox(
              value: false,
              onChanged: (value) {},
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.all(Colors.white),
              side: BorderSide(color: Colors.white, width: 1),
            ),
          )
        ],
      ),
    );
  }
}
