import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/data/services/enums/enums.dart';
import 'package:plenty_wallet/app/data/services/service_models/account_model.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';

class AccountSwitchSelector extends StatelessWidget {
  final List<AccountModel>? accountModels;
  final int? index;
  const AccountSwitchSelector({this.accountModels, this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      isScrollControlled: true,
      title: "Wallet",
      // height: 0.65.height,
      bottomSheetWidgets: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return BouncingWidget(
              onPressed: () {
                Get.back(result: index);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 16.arP),
                      child: Container(
                        height: 44.arP,
                        width: 44.arP,
                        alignment: Alignment.bottomRight,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: accountModels![index].imageType ==
                                    AccountProfileImageType.assets
                                ? AssetImage(accountModels![index]
                                    .profileImage
                                    .toString())
                                : FileImage(
                                    File(
                                      accountModels![index]
                                          .profileImage
                                          .toString(),
                                    ),
                                  ) as ImageProvider,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(accountModels![index].name.toString(),
                              style: titleSmall),
                          Text(
                            "${accountModels![index].accountDataModel!.xtzBalance!} Tez",
                            style: bodySmall.copyWith(color: ColorConst.grey),
                          ),
                        ],
                      ),
                    ),
                    this.index == index
                        ? SvgPicture.asset(
                            "assets/svg/check_3.svg",
                            height: 14.arP,
                            width: 14.arP,
                          )
                        : SizedBox(
                            height: 14.arP,
                            width: 14.arP,
                          )
                  ],
                ),
              ),
            );
          },
          itemCount: accountModels!.length,
        ),
        const BottomButtonPadding()
      ],
    );
  }
}
