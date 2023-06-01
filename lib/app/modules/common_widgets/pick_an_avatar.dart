import 'dart:io';

import 'package:flutter/material.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import 'bottom_button_padding.dart';
import 'solid_button.dart';

class PickAvatar extends StatefulWidget {
  final String? selectedAvatar;
  final Function(String) onConfirm;
  final AccountProfileImageType? imageType;
  const PickAvatar({
    Key? key,
    required this.onConfirm,
    this.selectedAvatar,
    this.imageType,
  }) : super(key: key);

  @override
  State<PickAvatar> createState() => _PickAvatarState();
}

class _PickAvatarState extends State<PickAvatar> {
  late String selectedAvatar;
  late AccountProfileImageType imageType;
  @override
  void initState() {
    selectedAvatar = widget.selectedAvatar ?? "";
    imageType = widget.imageType ?? AccountProfileImageType.assets;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      title: "Pick an avatar",
      leading: backButton(),
      // isScrollControlled: true,
      height: AppConstant.naanBottomSheetHeight,
      bottomSheetWidgets: [
        SizedBox(
          height: AppConstant.naanBottomSheetChildHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              0.02.vspace,
              Container(
                height: 0.3.width,
                width: 0.3.width,
                alignment: Alignment.bottomRight,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: imageType == AccountProfileImageType.assets
                        ? AssetImage(selectedAvatar)
                        : FileImage(
                            File(selectedAvatar),
                          ) as ImageProvider,
                  ),
                ),
              ),
              0.02.vspace,
              Expanded(
                child: GridView.count(
                  physics: AppConstant.scrollPhysics,
                  crossAxisCount: 4,
                  mainAxisSpacing: 0.06.width,
                  crossAxisSpacing: 0.06.width,
                  children: List.generate(
                    ServiceConfig.allAssetsProfileImages.length,
                    (index) => BouncingWidget(
                      onPressed: () {
                        imageType = AccountProfileImageType.assets;
                        selectedAvatar =
                            ServiceConfig.allAssetsProfileImages[index];
                        setState(() {});
                      },
                      child: ClipOval(
                        // radius: 70.arP,
                        child: Image.asset(
                          ServiceConfig.allAssetsProfileImages[index],
                          fit: BoxFit.cover,
                          height: 72.arP,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              0.02.vspace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.arP),
                child: SolidButton(
                  onPressed: () {
                    widget.onConfirm(selectedAvatar);
                  },
                  title: "Confirm",
                ),
              ),
              const BottomButtonPadding()
            ],
          ),
        ),
      ],
    );
  }
}
