import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/dapp_browser/views/dapp_browser_view.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/home_widget_frame.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class TezosPriceWidget extends StatelessWidget {
  TezosPriceWidget({Key? key}) : super(key: key);
  HomePageController homePageController = Get.find<HomePageController>();
  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      onPressed: () {
        CommonFunctions.bottomSheet(
          const DappBrowserView(),
          settings: RouteSettings(
            arguments: ServiceConfig.tezPriceChart,
          ),
        );
      },
      child: HomeWidgetFrame(
        child: Container(
          padding: EdgeInsets.all(0.035.width),
          decoration: BoxDecoration(
            color: ColorConst.NeutralVariant.shade10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: SvgPicture.asset(
                  "${PathConst.HOME_PAGE.SVG}tezos_price.svg",
                  width: 0.225.width,
                ),
              ),
              Expanded(
                child: Obx(
                  () => Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${homePageController.xtzPrice.value.toStringAsFixed(2)}",
                        style: headlineSmall,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 0.006.height),
                            child: RichText(
                              text: TextSpan(children: [
                                WidgetSpan(
                                  child: Icon(
                                    homePageController.dayChange.value >= 0
                                        ? Icons.arrow_upward_outlined
                                        : Icons.arrow_downward_outlined,
                                    size: 14,
                                    color:
                                        homePageController.dayChange.value >= 0
                                            ? ColorConst.green
                                            : ColorConst.NaanRed,
                                  ),
                                ),
                                WidgetSpan(child: 0.005.hspace),
                                TextSpan(
                                  text:
                                      "${homePageController.dayChange.value}%",
                                  style: labelMedium.apply(
                                    color:
                                        homePageController.dayChange.value >= 0
                                            ? ColorConst.green
                                            : ColorConst.NaanRed,
                                  ),
                                )
                              ]),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
