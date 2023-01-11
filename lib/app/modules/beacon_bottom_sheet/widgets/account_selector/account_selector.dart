import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class AccountSelector extends StatelessWidget {
  final List<AccountModel>? accountModels;
  final int? index;
  const AccountSelector({this.accountModels, this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.65.height,
      width: 1.width,
      padding: EdgeInsets.only(
        bottom: Platform.isIOS ? 0.05.height : 0.02.height,
      ),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          color: Colors.black),
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
          0.04.vspace,
          Text("Account", style: titleLarge),
          0.04.vspace,
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Get.back(result: index);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Container(
                            height: 0.1.width,
                            width: 0.1.width,
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(accountModels![index].name.toString(),
                                style: titleSmall),
                            Text(
                              "${accountModels![index].accountDataModel!.xtzBalance!.toStringAsFixed(2)} Tez",
                              style: bodySmall.copyWith(color: ColorConst.grey),
                            ),
                          ],
                        ),
                        this.index == index
                            ? Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: SvgPicture.asset(
                                    "assets/svg/check_3.svg",
                                    height: 14.arP,
                                    width: 14.arP,
                                  ),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
                );
              },
              itemCount: accountModels!.length,
            ),
          ),
        ],
      ),
    );
  }
}
