import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';

import 'bottom_sheet.dart';

class ImagePickerSheet extends StatelessWidget {
  final Function() onGallerySelect;
  final Function() onPickAvatarSelect;
  final Function()? onRemoveImage;
  const ImagePickerSheet(
      {super.key,
      this.onRemoveImage,
      required this.onGallerySelect,
      required this.onPickAvatarSelect});

  @override
  Widget build(BuildContext context) {
    return changePhotoBottomSheet();
  }

  Widget changePhotoBottomSheet() {
    return NaanBottomSheet(
      height: .3.height,
      bottomSheetWidgets: [
        Column(
          children: [
            0.02.vspace,
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(
                horizontal: 12.aR,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.aR),
                color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BouncingWidget(
                    onPressed: onGallerySelect,
                    child: Container(
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(8.aR),
                      //   color:
                      //       ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                      // ),
                      width: double.infinity,
                      height: 51.aR,
                      alignment: Alignment.center,
                      child: Text(
                        "Choose from library".tr,
                        style: labelMedium.copyWith(fontSize: 12.aR),
                      ),
                    ),
                  ),
                  const Divider(
                    color: Color(0xff4a454e),
                    height: 1,
                    thickness: 1,
                  ),
                  BouncingWidget(
                    onPressed: onPickAvatarSelect,
                    child: Container(
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(8.aR),
                      //   color:
                      //       ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                      // ),
                      width: double.infinity,
                      height: 51.aR,
                      alignment: Alignment.center,
                      child: Text(
                        "Pick an avatar".tr,
                        style: labelMedium.copyWith(fontSize: 12.aR),
                      ),
                    ),
                  ),
                  if (onRemoveImage != null)
                    const Divider(
                      color: Color(0xff4a454e),
                      height: 1,
                      thickness: 1,
                    ),
                  onRemoveImage != null
                      ? BouncingWidget(
                          onPressed: onRemoveImage,
                          child: Container(
                            width: double.infinity,
                            height: 51.aR,
                            alignment: Alignment.center,
                            child: Text(
                              "Remove photo".tr,
                              style: labelMedium.copyWith(
                                  color: ColorConst.Error.shade60,
                                  fontSize: 12.aR),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            0.016.vspace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.arP),
              child: BouncingWidget(
                onPressed: () => Get.back(),
                child: Container(
                  height: 51.aR,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.aR),
                    color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                  ),
                  child: Text(
                    "Cancel".tr,
                    style: labelMedium.copyWith(
                        color: Colors.white, fontSize: 12.aR),
                  ),
                ),
              ),
            ),
            const BottomButtonPadding()
          ],
        ),
      ],
    );
  }
}
