import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/naan_textfield.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/material_Tap.dart';

import '../../../../utils/styles/styles.dart';
import '../controllers/create_profile_page_controller.dart';

class CreateProfilePageView extends GetView<CreateProfilePageController> {
  const CreateProfilePageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          decoration:
              const BoxDecoration(gradient: GradConst.GradientBackground),
          width: 1.width,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: controller.isWalletCreated.value
              ? Container(
                  decoration: const BoxDecoration(
                      gradient: GradConst.GradientBackground),
                  height: 1.height,
                  width: 1.width,
                  child: Center(
                    child: Lottie.asset(
                      '${PathConst.ASSETS}create_wallet/lottie/wallet_success.json',
                      fit: BoxFit.contain,
                      height: 300,
                      width: 300,
                      frameRate: FrameRate(30),
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    89.vspace,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Create Profile", style: titleLarge),
                    ),
                    38.vspace,
                    Container(
                      height: 120,
                      width: 120,
                      alignment: Alignment.bottomRight,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: materialTap(
                        onPressed: () {
                          Get.bottomSheet(changePhotoBottomSheet());
                        },
                        inkwellRadius: 18,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child:
                              SvgPicture.asset("${PathConst.SVG}add_photo.svg"),
                        ),
                      ),
                    ),
                    38.vspace,
                    const NaanTextfield(),
                    27.vspace,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "or  choose a avatar",
                        textAlign: TextAlign.left,
                        style: labelSmall.apply(
                            color: ColorConst.NeutralVariant.shade60),
                      ),
                    ),
                    19.vspace,
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 4,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        children: List.generate(
                          11,
                          (index) => const CircleAvatar(
                            radius: 30,
                          ),
                        ),
                      ),
                    ),
                    SolidButton(
                      title: "Start using Naan wallet",
                      onPressed: () => controller.onWalletSuccess(),
                    ),
                    51.vspace
                  ],
                ),
        ));
  }

  Widget changePhotoBottomSheet() {
    return NaanBottomSheet(title: 'Change profile photo', bottomSheetWidgets: [
      Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
            ),
            child: Column(
              children: [
                materialTap(
                  onPressed: () {},
                  noSplash: true,
                  child: Container(
                    width: double.infinity,
                    height: 51,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Choose photo",
                      style: labelMedium,
                    ),
                  ),
                ),
                const Divider(
                  color: Color(0xff4a454e),
                  height: 1,
                  thickness: 1,
                ),
                materialTap(
                  onPressed: () {},
                  noSplash: true,
                  child: Container(
                    width: double.infinity,
                    height: 51,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Take photo",
                      style: labelMedium,
                    ),
                  ),
                ),
                const Divider(
                  color: Color(0xff4a454e),
                  height: 1,
                  thickness: 1,
                ),
                materialTap(
                  onPressed: () {},
                  noSplash: true,
                  child: Container(
                    width: double.infinity,
                    height: 51,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Remove current photo",
                      style: labelMedium.apply(color: ColorConst.Error.shade60),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ]);
  }
}
