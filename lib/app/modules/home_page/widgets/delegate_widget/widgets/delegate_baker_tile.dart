import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/delegate_baker_list_model.dart';
import 'package:naan_wallet/app/modules/beacon_bottom_sheet/opreation_request/controllers/opreation_request_controller.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/dapp_browser/views/dapp_browser_view.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/delegate_widget/controllers/delegate_widget_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';
import 'delegate_baker.dart';

class DelegateBakerTile extends GetView<DelegateWidgetController> {
  final DelegateBakerModel baker;
  final bool redelegate;
  final String? prevPage;
  const DelegateBakerTile({
    required this.baker,
    this.redelegate = false,
    this.prevPage,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 0.01.height),
      // width: 338,
      // height: 125.arP,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xff958e99).withOpacity(0.2),
        border: Border.all(
          color: Colors.transparent,
          width: 2,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 0.03.width,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          0.0075.vspace,
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 20,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: OpreationRequestController.iconBuilder(
                        baker.logo, baker.address),
                    fit: BoxFit.fill,
                    width: 40,
                    height: 40,
                    maxWidthDiskCache: 80,
                    maxHeightDiskCache: 80,
                  ),
                ),
              ),
              0.02.hspace,
              Text(
                baker.name ?? baker.address?.tz1Short() ?? "",
                style: labelMedium,
              ),
              0.015.hspace,
              IconButton(
                  alignment: Alignment.centerLeft,
                  iconSize: 16.aR,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    CommonFunctions.bottomSheet(
                      const DappBrowserView(),
                      fullscreen: true,
                      settings: RouteSettings(
                          arguments: 'https://tzkt.io/${baker.address}'),
                    );
                  },
                  icon: SvgPicture.asset(
                    '${PathConst.SETTINGS_PAGE}svg/external-link.svg',
                    color: ColorConst.textGrey1,
                    fit: BoxFit.fill,
                    height: 16.aR,
                  )),
              const Spacer(),
              if (redelegate)
                BouncingWidget(
                    child: Container(
                      decoration: BoxDecoration(
                          color: ColorConst.Primary,
                          borderRadius: BorderRadius.circular(24.arP)),
                      padding: EdgeInsets.symmetric(
                          vertical: 4.arP, horizontal: 8.arP),
                      child: Text(
                        "Redelegate".tr,
                        style: labelSmall.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    onPressed: () {
                      if (controller.prevPage == null) {
                        Get.back();
                        CommonFunctions.bottomSheet(
                            DelegateSelectBaker(
                              delegatedBaker: baker,
                              isScrollable: true,
                            ),
                            fullscreen: true);
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DelegateSelectBaker(
                                delegatedBaker: baker,
                                isScrollable: true,
                              ),
                            ));
                      }
                    }),
            ],
          ),
          0.024.vspace,
          // const Spacer(),
          Row(
            children: [
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: '${'Baker fee:'.tr}\n',
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
                  text: '${'Staking:'.tr}\n',
                  style: labelMedium.copyWith(
                      color: ColorConst.NeutralVariant.shade70),
                  children: [
                    TextSpan(
                        text: baker.freespaceMin ?? "N/A", style: labelLarge)
                  ],
                ),
              ),
              0.06.hspace,
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: '${'Yield:'.tr}\n',
                  style: labelMedium.copyWith(
                      color: ColorConst.NeutralVariant.shade70),
                  children: [
                    TextSpan(
                        text: baker.delegateBakersListResponseYield == null
                            ? "N/A"
                            : '${baker.delegateBakersListResponseYield}%',
                        style: labelLarge)
                  ],
                ),
              ),
            ],
          ),
          0.018.vspace,
        ],
      ),
    );
  }
}
