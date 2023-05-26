import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPermissionHandler extends StatelessWidget {
  final Function() callback;
  const CameraPermissionHandler({super.key, required this.callback});

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      height: 0.6.height,
      title: "",
      bottomSheetWidgets: [
        SizedBox(
          height: 0.56.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                '${PathConst.SVG}camera_permission.svg',
                fit: BoxFit.contain,
                height: 0.5.width,
                width: 0.5.width,
              ),
              0.05.vspace,
              Text(
                "Access to camera is \nrestricted".tr,
                style: titleLarge,
                textAlign: TextAlign.center,
              ),
              0.012.vspace,
              Text(
                "Enable camera permissions for naan to \nstart scanning QR".tr,
                style: bodySmall.copyWith(color: ColorConst.textGrey1),
                textAlign: TextAlign.center,
              ),
              Spacer(),
              Row(
                children: [
                  Expanded(
                      child: SolidButton(
                    borderWidth: 1,
                    primaryColor: Colors.transparent,
                    borderColor: ColorConst.Neutral.shade90,
                    textColor: ColorConst.Neutral.shade90,
                    onPressed: () {
                      Get.back();
                    },
                    title: "I’ll do it later",
                  )),
                  0.02.hspace,
                  Expanded(
                      child: SolidButton(
                    onPressed: () async {
                      if (await openAppSettings()) {
                        Get.back();
                        callback
                            .call();
                             // Get.find<HomePageController>().openScanner();
                      }
                    },
                    title: "Enable camera",
                  )),
                ],
              ),
              0.02.vspace
            ],
          ),
        )
      ],
    );
  }
}
