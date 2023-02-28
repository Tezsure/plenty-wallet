import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/common_widgets/social_login_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/create_wallet_page/controllers/create_wallet_page_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/accounts_widget/controllers/accounts_widget_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/accounts_widget/views/widget/add_new_account_sheet.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:web3auth_flutter/enums.dart';

import '../../../../../../../utils/colors/colors.dart';
import '../../../../../../../utils/styles/styles.dart';
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
              'Add account',
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
              'Manage multiple accounts\neasily',
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
