
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../../../utils/colors/colors.dart';
import 'add_account_sheet.dart';

class AddAccountWidget extends StatelessWidget {
  final String? warning;
  const AddAccountWidget({super.key, this.warning});

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      onPressed: () {
        CommonFunctions.bottomSheet(
          addAccountSheet(warning),
        );
      },
      child: Container(
        height: AppConstant.homeWidgetDimension,
        padding: EdgeInsets.only(
          left: 20.arP,
          right: 22.arP,
          top: 22.arP,
          bottom: 22.arP,
        ),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(22),
            color: ColorConst.darkGrey),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topRight,
              child: SvgPicture.asset(
                "assets/nft_page/svg/add_icon.svg",
                height: 38.33.arP,
              ),
            ),
            const Spacer(),
            Text(
              'Add wallet'.tr,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 22.arP,
              ),
            ),
            SizedBox(
              height: 4.arP,
            ),
            Text(
              'Manage multiple wallets\neasily'.tr,
              style: TextStyle(
                color: const Color(0xFF958E99),
                fontWeight: FontWeight.w400,
                fontSize: 12.arP,
                letterSpacing: .5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

InkWell _optionMethod({Widget? child, GestureTapCallback? onTap}) {
  return InkWell(
    onTap: onTap,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    child: SizedBox(
      width: double.infinity,
      height: 54,
      child: Center(
        child: child,
      ),
    ),
  );
}

Widget addAccountSheet(warning) {
  return AddAccountSheet(
    warning: warning,
  );
}
