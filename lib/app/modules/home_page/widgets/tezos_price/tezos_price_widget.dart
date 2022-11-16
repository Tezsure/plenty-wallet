import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class TezosPriceWidget extends StatelessWidget {
  const TezosPriceWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.405.width,
      width: 0.405.width,
      padding: EdgeInsets.all(0.035.width),
      margin: EdgeInsets.only(right: 24.sp),
      decoration: BoxDecoration(
        color: ColorConst.NeutralVariant.shade10,
        borderRadius: BorderRadius.circular(22.sp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: SvgPicture.asset(
              "${PathConst.HOME_PAGE.SVG}tezos_price.svg",
              width: 0.2.width,
            ),
          ),
          Text(
            "Tez",
            style: labelSmall.apply(
              color: ColorConst.NeutralVariant.shade60,
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$${Get.find<HomePageController>().xtzPrice.value.toStringAsFixed(2)}",
                  style: headlineSmall,
                ),
                0.02.hspace,
                Padding(
                  padding: EdgeInsets.only(bottom: 0.006.height),
                  child: RichText(
                    text: TextSpan(children: [
                      const WidgetSpan(
                        child: Icon(
                          true
                              ? Icons.arrow_upward_outlined
                              : Icons.arrow_downward_outlined,
                          size: 14,
                          color: ColorConst.green,
                        ),
                      ),
                      WidgetSpan(child: 0.005.hspace),
                      TextSpan(
                        text: "${0.03}%",
                        style: labelMedium.apply(
                          color: ColorConst.green,
                        ),
                      )
                    ]),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
