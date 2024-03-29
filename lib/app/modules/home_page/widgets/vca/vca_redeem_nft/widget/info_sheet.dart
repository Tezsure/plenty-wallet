import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:plenty_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:plenty_wallet/app/modules/home_page/widgets/vca/vca_redeem_nft/controller/vca_redeem_nft_controller.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/constants/path_const.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';

class VCAPOAPInfoSheet extends StatelessWidget {
  VCAPOAPInfoSheet({super.key});
  List<VCAInfoModel> vcaInfos = [
    VCAInfoModel(
      title: "Authenticity",
      subtitle:
          "Every Souvenir has a unique and unmodifiable serial number, making Souvenirs non-fungible.",
      icon: "authenticity",
    ),
    VCAInfoModel(
      title: "Ownership",
      subtitle:
          "Collectors own their Souvenirs, making them tradeable and transferrable.",
      icon: "ownership",
    ),
    VCAInfoModel(
      title: "Decentralized",
      subtitle:
          "Souvenir NFTs are not controlled by any single authority and are created on a secure blockchain network.",
      icon: "decentralized",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      title: "",
      isScrollControlled: true,
      bottomSheetWidgets: [
        Column(
          children: [
            Text(
              "What is a Souvenir NFT?",
              style: headlineSmall,
            ),
            0.016.vspace,
            Image.asset(
              "${PathConst.HOME_PAGE}vca/info_header.png",
              fit: BoxFit.cover,
              width: .5.width,
            ),
            0.03.vspace,
            Text(
              "Souvenir NFTs are unique digital tokens that serve as proof of attendance or participation in events, such as conferences, festivals, and meetups. They are like a digital version of a ticket or a certificate of attendance.",
              style:
                  bodySmall.copyWith(color: ColorConst.NeutralVariant.shade60),
            ),
            0.02.vspace,
            ListView.separated(
              separatorBuilder: (context, index) => SizedBox(
                height: 20.arP,
              ),
              padding: EdgeInsets.only(
                right: 16.arP,
              ),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "${PathConst.HOME_PAGE}vca/${vcaInfos[index].icon}.png",
                      width: 24.arP,
                      height: 24.arP,
                    ),
                    SizedBox(
                      width: 12.arP,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vcaInfos[index].title,
                            style: labelMedium,
                          ),
                          SizedBox(
                            height: 4.arP,
                          ),
                          Text(
                            vcaInfos[index].subtitle,
                            style: bodySmall.copyWith(
                                color: ColorConst.NeutralVariant.shade60),
                          ),
                        ],
                      ),
                    )
                  ],
                );
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  horizontalTitleGap: 12.arP,
                  minLeadingWidth: 0,
                  minVerticalPadding: 10.arP,
                  leading: Column(
                    children: [
                      Image.asset(
                        "${PathConst.HOME_PAGE}vca/${vcaInfos[index].icon}.png",
                        width: 28.arP,
                        height: 28.arP,
                      ),
                    ],
                  ),
                  title: Text(
                    vcaInfos[index].title,
                    style: labelMedium,
                  ),
                  subtitle: Text(
                    vcaInfos[index].subtitle,
                    style: bodySmall.copyWith(
                        color: ColorConst.NeutralVariant.shade60),
                  ),
                );
              },
              itemCount: vcaInfos.length,
            ),
            0.058.vspace,
            SolidButton(
              width: 1.width - 64.arP,
              title: "Continue",
              onPressed: () {
                Get.back();
                final controller = Get.put(VCARedeemNFTController());
                controller.openScanner();
              },
            ),
            BottomButtonPadding()
          ],
        )
      ],
    );
  }
}

class VCAInfoModel {
  final String title;
  final String subtitle;
  final String icon;

  VCAInfoModel({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
