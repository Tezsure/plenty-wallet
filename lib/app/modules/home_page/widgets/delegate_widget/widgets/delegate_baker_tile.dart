import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/delegate_baker_list_model.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/dapp_browser/views/dapp_browser_view.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

import 'delegate_baker.dart';
import 'delegate_info_sheet.dart';

class DelegateBakerTile extends StatelessWidget {
  final DelegateBakerModel baker;
  final bool redelegate;
  const DelegateBakerTile({
    required this.baker,
    this.redelegate = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.01.height),
      child: Container(
        // width: 338,
        height: 0.12.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xff958e99).withOpacity(0.2),
          border: Border.all(
            color: Colors.transparent,
            width: 2,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 0.04.width),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 20,
                  child: ClipOval(
                    child: Image.network(
                      baker.logo ?? "",
                      fit: BoxFit.fill,
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
                0.02.hspace,
                Text(
                  baker.name ?? "",
                  style: labelMedium,
                ),
                0.015.hspace,
                IconButton(
                    alignment: Alignment.centerLeft,
                    iconSize: 16.aR,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Get.bottomSheet(const DappBrowserView(),
                          barrierColor: Colors.white.withOpacity(0.09),
                          settings: RouteSettings(
                              arguments: 'https://tzkt.io/${baker.address}'),
                          isScrollControlled: true);
                    },
                    icon: SvgPicture.asset(
                      '${PathConst.SETTINGS_PAGE}svg/external-link.svg',
                      color: ColorConst.textGrey1,
                      fit: BoxFit.fill,
                      height: 16.aR,
                    )),
                const Spacer(),
                if (redelegate)
                  SolidButton(
                    title: "Redelegate",
                    onPressed: () {
                      Get.back();
                      Get.bottomSheet(
                          DelegateSelectBaker(
                            delegatedBaker: baker,
                            isScrollable: true,
                          ),
                          enableDrag: true,
                          isScrollControlled: true);
                    },
                    borderRadius: 24,
                    height: 25,
                    titleStyle:
                        labelSmall.copyWith(fontWeight: FontWeight.bold),
                    width: 100,
                  )
              ],
            ),
            0.013.vspace,
            Row(
              children: [
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: 'Baker fee:\n',
                    style: labelMedium.copyWith(
                        color: ColorConst.NeutralVariant.shade70),
                    children: [
                      TextSpan(
                          text: '${((baker.fee) * 100).toStringAsFixed(1)}%',
                          style: labelLarge)
                    ],
                  ),
                ),
                0.06.hspace,
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: 'Staking:\n',
                    style: labelMedium.copyWith(
                        color: ColorConst.NeutralVariant.shade70),
                    children: [
                      TextSpan(
                          text: baker.freespaceMin ?? "", style: labelLarge)
                    ],
                  ),
                ),
                0.06.hspace,
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: 'Yield:\n',
                    style: labelMedium.copyWith(
                        color: ColorConst.NeutralVariant.shade70),
                    children: [
                      TextSpan(
                          text: '${baker.delegateBakersListResponseYield}%',
                          style: labelLarge)
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
