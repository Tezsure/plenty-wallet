import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class AccountValueWidget extends StatelessWidget {
  const AccountValueWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.width,
      color: ColorConst.Primary,
      child: Column(
        children: [
          0.06.vspace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Total Account Value",
                style: labelSmall.apply(
                  color: ColorConst.NeutralVariant.shade70,
                ),
              ),
              0.01.hspace,
              GestureDetector(
                child: SizedBox(
                  height: 12,
                  width: 12,
                  child: SvgPicture.asset(
                      "${PathConst.HOME_PAGE.SVG}eye_hide.svg"),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("${PathConst.HOME_PAGE.SVG}xtz.svg"),
              0.02.hspace,
              Text(
                "1020.00",
                style: headlineLarge,
              )
            ],
          ),
          0.035.vspace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              actionMethod(
                "Send",
                "${PathConst.HOME_PAGE.SVG}send.svg",
                onTap: () => Get.toNamed(Routes.SEND_TOKEN_PAGE),
              ),
              0.09.hspace,
              actionMethod(
                "Receive",
                "${PathConst.HOME_PAGE.SVG}receive.svg",
                onTap: () => Get.snackbar('', '',
                    backgroundColor: ColorConst.NeutralVariant.shade20,
                    boxShadows: [
                      BoxShadow(
                          color: Colors.white.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 5,
                          offset: const Offset(0, 4)),
                    ],
                    icon: const Icon(
                      Icons.add_a_photo,
                      color: Colors.white,
                    ),
                    barBlur: 1,
                    colorText: Colors.white,
                    onTap: (val) {},
                    borderRadius: 8,
                    maxWidth: 8.width,
                    isDismissible: true,
                    margin:
                        const EdgeInsets.only(bottom: 30, left: 15, right: 15),
                    messageText: Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Sent to tz1KpKTX1........DZ',
                            style: labelSmall.copyWith(
                              color: ColorConst.NeutralVariant.shade60,
                            ),
                          ),
                          TextButton(
                              style: ButtonStyle(
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  maximumSize: MaterialStateProperty.all<Size>(
                                      const Size(80, 20)),
                                  padding: MaterialStateProperty.all<EdgeInsets>(
                                      const EdgeInsets.all(0)),
                                  minimumSize: MaterialStateProperty.all<Size>(
                                      const Size(40, 10)),
                                  fixedSize: MaterialStateProperty.all<Size>(
                                      const Size(80, 20)),
                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(35))),
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                      ColorConst.NeutralVariant.shade30)),
                              onPressed: () {},
                              child: Center(
                                child: Text(
                                  'Pending',
                                  style: labelSmall,
                                ),
                              )),
                        ],
                      ),
                    ),
                    titleText: Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('1.00 tez', style: labelMedium),
                          IconButton(
                              splashRadius: 15,
                              constraints:
                                  BoxConstraints.tight(const Size(20, 20)),
                              iconSize: 15,
                              padding: EdgeInsets.zero,
                              onPressed: () {},
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 15,
                              ))
                        ],
                      ),
                    ),
                    shouldIconPulse: false,
                    snackStyle: SnackStyle.FLOATING,
                    animationDuration: const Duration(seconds: 1),
                    snackPosition: SnackPosition.BOTTOM),
              ),
              0.09.hspace,
              actionMethod("Add", "${PathConst.HOME_PAGE.SVG}plus.svg"),
            ],
          ),
          0.06.vspace,
        ],
      ),
    );
  }

  GestureDetector actionMethod(String title, String svgPath,
      {void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 0.07.width,
            backgroundColor: ColorConst.Primary.shade60,
            child: SvgPicture.asset(svgPath),
          ),
          0.01.vspace,
          Text(
            title,
            style: bodySmall,
          ),
        ],
      ),
    );
  }
}
